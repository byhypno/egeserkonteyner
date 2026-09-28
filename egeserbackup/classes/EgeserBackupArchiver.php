<?php
/**
 * Egeser Full Backup
 *
 * @author    Egeser
 * @copyright Egeser
 * @license   Proprietary
 */
if (!defined('_PS_VERSION_')) {
    exit;
}

/**
 * Phase 2: adds the manifest entries to the ZIP in small batches.
 *
 * Every request opens the current ZIP part, registers up to "batch size"
 * files with ZipArchive::addFile() (libzip streams the file content from disk
 * during close(), nothing is loaded into PHP memory), closes the archive and
 * stores the next manifest byte offset in job.json.
 *
 * Why parts: libzip rewrites the complete archive into a temp file on every
 * close(). With one huge archive every batch would copy all previously written
 * gigabytes again. Splitting into parts (default 1 GB, configurable, 0 = one
 * single ZIP) bounds that cost. Every part is an independent, standard ZIP.
 *
 * Failure handling:
 *  - libzip writes to a temp file and renames it only on success, so a failed
 *    or killed close() leaves the previous part content intact;
 *  - a batch that failed or was killed (timeout) is retried file by file
 *    ("safe mode"); a single entry that keeps failing is reported and skipped.
 */
class EgeserBackupArchiver implements EgeserBackupPhaseInterface
{
    public const MAX_BATCH_BYTES = 134217728;
    public const MAX_ATTEMPTS = 3;
    public const SPACE_RESERVE = 67108864;

    /**
     * Already compressed formats: stored without deflate (much faster, same size).
     *
     * @var string[]
     */
    private static $storedExtensions = array(
        'jpg', 'jpeg', 'png', 'gif', 'webp', 'avif', 'ico', 'heic',
        'zip', 'gz', 'tgz', 'bz2', 'xz', '7z', 'rar', 'zst',
        'mp3', 'mp4', 'm4a', 'm4v', 'mov', 'avi', 'webm', 'ogg', 'ogv', 'flv',
        'woff', 'woff2', 'pdf', 'jar', 'phar',
    );

    /** @var EgeserBackupStorage */
    private $storage;

    /** @var EgeserBackupLogger */
    private $logger;

    /**
     * @param EgeserBackupStorage $storage
     * @param EgeserBackupLogger $logger
     */
    public function __construct(EgeserBackupStorage $storage, EgeserBackupLogger $logger)
    {
        $this->storage = $storage;
        $this->logger = $logger;
    }

    /**
     * {@inheritdoc}
     */
    public function run(EgeserBackupJob $job, $deadline)
    {
        if (!class_exists('ZipArchive')) {
            throw new EgeserBackupException('Sunucuda PHP ZipArchive extension aktif değil.');
        }
        $archive = &$job->data['archive'];
        $settings = $job->data['settings'];
        $batchSize = max(1, (int) $settings['batch_size']);
        $partLimit = (int) $settings['part_size_mb'] * 1048576;
        $offset = (int) $archive['offset'];
        $manifestSize = (int) $job->data['manifest_size'];

        if ($offset >= $manifestSize) {
            $this->finish($job);

            return;
        }

        $this->checkDiskSpace($job);

        // Timeout / crash protection: the "inflight" marker is saved before the
        // heavy work. Finding it again for the same offset means the previous
        // request died while processing this batch.
        $attempt = 1;
        if (is_array($archive['inflight']) && (int) $archive['inflight']['offset'] === $offset) {
            $attempt = (int) $archive['inflight']['attempt'] + 1;
        }
        if ($attempt > self::MAX_ATTEMPTS) {
            $this->skipPoisonedEntry($job);

            return;
        }
        if ($attempt > 1) {
            $archive['safe_until'] = max((int) $archive['safe_until'], (int) $archive['processed'] + $batchSize);
            $this->logger->warning(sprintf(
                'Job %s: batch at offset %d is retried (attempt %d), switching to one file per request.',
                $job->getId(),
                $offset,
                $attempt
            ));
        }
        $archive['inflight'] = array('offset' => $offset, 'attempt' => $attempt);
        $job->save();

        $limit = (int) $archive['processed'] < (int) $archive['safe_until'] ? 1 : $batchSize;
        $batch = $this->readBatch($job->manifestFile(), $offset, $manifestSize, $limit);
        if (!$batch) {
            $this->finish($job);

            return;
        }

        $partIndex = (int) $archive['part'];
        $partFile = $job->partFile($partIndex);
        $zip = new ZipArchive();
        $opened = $zip->open($partFile, ZipArchive::CREATE);
        if ($opened !== true) {
            throw new EgeserBackupException('ZIP dosyası açılamadı (ZipArchive hata kodu: ' . (int) $opened . ').');
        }

        $root = $this->storage->getRoot();
        $issues = array();
        $addedEntries = 0;
        $bytes = 0;
        $lastFile = '';
        foreach ($batch as $entry) {
            $bytes += $entry['size'];
            if ($entry['invalid']) {
                $issues[] = array(EgeserBackupJob::ISSUE_ERROR, $entry['rel'], 'Manifest satırı geçersiz, atlandı.');
                continue;
            }
            $rel = $entry['rel'];
            $lastFile = $rel;
            if (EgeserBackupExclusions::isStoragePath($rel)) {
                continue;
            }
            if ($entry['type'] === 'D') {
                if ($zip->addEmptyDir($rel)) {
                    if (method_exists($zip, 'setExternalAttributesName')) {
                        $perms = @fileperms($root . '/' . $rel);
                        $perms = $perms !== false ? ($perms & 0xFFFF) : 040755;
                        $zip->setExternalAttributesName($rel . '/', ZipArchive::OPSYS_UNIX, $perms << 16);
                    }
                    ++$addedEntries;
                } else {
                    $issues[] = array(EgeserBackupJob::ISSUE_ERROR, $rel . '/', 'Klasör kaydı ZIP\'e eklenemedi.');
                }
                continue;
            }
            $abs = $root . '/' . $rel;
            clearstatcache(true, $abs);
            if (!is_file($abs)) {
                $issues[] = array(EgeserBackupJob::ISSUE_UNREADABLE, $rel, 'Dosya tarama sonrasında silinmiş veya taşınmış.');
                continue;
            }
            $probe = @fopen($abs, 'rb');
            if ($probe === false) {
                $issues[] = array(EgeserBackupJob::ISSUE_UNREADABLE, $rel, 'Dosya okunamadı (izin yok).');
                continue;
            }
            fclose($probe);
            if (!$zip->addFile($abs, $rel)) {
                $issues[] = array(EgeserBackupJob::ISSUE_ERROR, $rel, 'Dosya ZIP\'e eklenemedi: ' . $zip->getStatusString());
                continue;
            }
            $this->tuneEntry($zip, $rel, $abs);
            ++$addedEntries;
        }

        // Entry count as libzip sees it (replaced duplicates of a replayed batch
        // are not counted twice). Authoritative value for the verification.
        $entriesAfterClose = (int) $zip->numFiles;

        // The actual reading/compression happens here (streamed by libzip).
        $closed = @$zip->close();
        if (!$closed) {
            $error = error_get_last();
            $reason = isset($error['message']) ? $error['message'] : 'bilinmeyen hata';
            $this->logger->error(sprintf('Job %s: ZipArchive::close() failed at offset %d: %s', $job->getId(), $offset, $reason));
            if (count($batch) > 1) {
                // Nothing of this batch was written. Retry it one file per request
                // so the single failing file can be identified and skipped.
                $archive['safe_until'] = max((int) $archive['safe_until'], (int) $archive['processed'] + count($batch));
                $archive['inflight'] = null;
                $job->save();

                return;
            }
            $issues = array(array(
                EgeserBackupJob::ISSUE_ERROR,
                $batch[0]['rel'],
                'Dosya ZIP\'e yazılamadı (okuma hatası veya dosya değişti).',
            ));
            $addedEntries = 0;
            $entriesAfterClose = (int) $archive['parts'][$partIndex]['entries'];
        }

        $last = $batch[count($batch) - 1];
        $archive['offset'] = $last['end'];
        $archive['processed'] = (int) $archive['processed'] + count($batch);
        $archive['processed_bytes'] = (int) $archive['processed_bytes'] + $bytes;
        $archive['current_file'] = $lastFile !== '' ? $lastFile : $archive['current_file'];
        $archive['inflight'] = null;
        $archive['parts'][$partIndex]['entries'] = $entriesAfterClose;
        $job->data['counters']['success'] = (int) $job->data['counters']['success'] + $addedEntries;

        if ($archive['offset'] >= $manifestSize) {
            $job->appendIssues($issues);
            $this->finish($job);

            return;
        }

        clearstatcache(true, $partFile);
        $partSize = is_file($partFile) ? (float) filesize($partFile) : 0.0;
        if ($partLimit > 0 && $partSize >= $partLimit && (int) $archive['parts'][$partIndex]['entries'] > 0) {
            $next = count($archive['parts']);
            $archive['parts'][] = array('file' => 'part' . ($next + 1) . '.zip', 'entries' => 0);
            $archive['part'] = $next;
        }
        $job->appendIssues($issues);
        $job->commit();
    }

    /**
     * Total size of the ZIP parts written so far.
     *
     * @param EgeserBackupJob $job
     *
     * @return float
     */
    public static function archiveSize(EgeserBackupJob $job)
    {
        $total = 0.0;
        foreach (array_keys($job->data['archive']['parts']) as $index) {
            $file = $job->partFile($index);
            clearstatcache(true, $file);
            if (is_file($file)) {
                $total += (float) filesize($file);
            }
        }

        return $total;
    }

    /**
     * @param string $relative
     *
     * @return bool
     */
    public static function isSafeRelative($relative)
    {
        return $relative !== ''
            && $relative[0] !== '/'
            && strpos($relative, "\0") === false
            && strpos($relative, '\\') === false
            && !preg_match('#(^|/)\.\.?(/|$)#', $relative);
    }

    /**
     * @param EgeserBackupJob $job
     */
    private function finish(EgeserBackupJob $job)
    {
        $archive = &$job->data['archive'];
        // Drop a trailing part that never received an entry (it has no file).
        $lastIndex = count($archive['parts']) - 1;
        if ($lastIndex > 0 && (int) $archive['parts'][$lastIndex]['entries'] === 0) {
            array_pop($archive['parts']);
            $archive['part'] = $lastIndex - 1;
        }
        $archive['inflight'] = null;
        $success = 0;
        foreach ($archive['parts'] as $part) {
            $success += (int) $part['entries'];
        }
        $job->data['counters']['success'] = $success;
        $job->advancePhase();
        $job->commit();
        $this->logger->info(sprintf(
            'Job %s: archiving finished, %d entries in %d part(s).',
            $job->getId(),
            (int) $job->data['counters']['success'],
            count($archive['parts'])
        ));
    }

    /**
     * The same entry killed the PHP worker MAX_ATTEMPTS times: report and skip it.
     *
     * @param EgeserBackupJob $job
     */
    private function skipPoisonedEntry(EgeserBackupJob $job)
    {
        $archive = &$job->data['archive'];
        $batch = $this->readBatch($job->manifestFile(), (int) $archive['offset'], (int) $job->data['manifest_size'], 1);
        if (!$batch) {
            $this->finish($job);

            return;
        }
        $entry = $batch[0];
        $this->logger->error(sprintf('Job %s: skipping "%s" after %d failed attempts.', $job->getId(), $entry['rel'], self::MAX_ATTEMPTS));
        $archive['offset'] = $entry['end'];
        $archive['processed'] = (int) $archive['processed'] + 1;
        $archive['processed_bytes'] = (int) $archive['processed_bytes'] + $entry['size'];
        $archive['inflight'] = null;
        $job->appendIssues(array(array(
            EgeserBackupJob::ISSUE_ERROR,
            $entry['rel'],
            'Dosya işlenirken istek tekrar tekrar zaman aşımına uğradı veya sunucu hatası oluştu; atlandı.',
        )));
        if ($archive['offset'] >= (int) $job->data['manifest_size']) {
            $this->finish($job);

            return;
        }
        $job->commit();
    }

    /**
     * @param string $manifest
     * @param int $offset
     * @param int $manifestSize
     * @param int $limit
     *
     * @return array
     *
     * @throws EgeserBackupException
     */
    private function readBatch($manifest, $offset, $manifestSize, $limit)
    {
        $handle = @fopen($manifest, 'rb');
        if ($handle === false) {
            throw new EgeserBackupException('Manifest dosyası okunamadı.');
        }
        if (fseek($handle, $offset) !== 0) {
            fclose($handle);
            throw new EgeserBackupException('Manifest dosyasında konumlanılamadı.');
        }
        $batch = array();
        $bytes = 0;
        while (count($batch) < $limit && ftell($handle) < $manifestSize) {
            if ($batch && $bytes >= self::MAX_BATCH_BYTES) {
                break;
            }
            $line = fgets($handle);
            if ($line === false) {
                break;
            }
            $end = ftell($handle);
            $parts = explode("\t", rtrim($line, "\n"), 3);
            $entry = array('type' => '', 'size' => 0, 'rel' => '', 'end' => $end, 'invalid' => true);
            if (count($parts) === 3 && ($parts[0] === 'F' || $parts[0] === 'D') && ctype_digit($parts[1])) {
                $entry['type'] = $parts[0];
                $entry['size'] = (int) $parts[1];
                $entry['rel'] = $parts[2];
                $entry['invalid'] = !self::isSafeRelative($parts[2]);
            } else {
                $entry['rel'] = substr(preg_replace('/[\x00-\x1F\x7F]/', ' ', $line), 0, 200);
            }
            $bytes += $entry['size'];
            $batch[] = $entry;
        }
        fclose($handle);

        return $batch;
    }

    /**
     * @param ZipArchive $zip
     * @param string $rel
     * @param string $abs
     */
    private function tuneEntry(ZipArchive $zip, $rel, $abs)
    {
        $extension = strtolower((string) pathinfo($rel, PATHINFO_EXTENSION));
        if (in_array($extension, self::$storedExtensions, true) && method_exists($zip, 'setCompressionName')) {
            $zip->setCompressionName($rel, ZipArchive::CM_STORE);
        }
        // Keep unix permissions so a restore on Linux gets the same modes back.
        if (method_exists($zip, 'setExternalAttributesName')) {
            $perms = @fileperms($abs);
            if ($perms !== false) {
                $zip->setExternalAttributesName($rel, ZipArchive::OPSYS_UNIX, ($perms & 0xFFFF) << 16);
            }
        }
    }

    /**
     * Stops (resumable) when the disk is obviously too full for the next close().
     * libzip needs room for a temp copy of the current part plus the new data.
     *
     * @param EgeserBackupJob $job
     *
     * @throws EgeserBackupException
     */
    private function checkDiskSpace(EgeserBackupJob $job)
    {
        $free = $this->storage->freeSpace();
        if ($free === null) {
            return;
        }
        $partFile = $job->partFile((int) $job->data['archive']['part']);
        clearstatcache(true, $partFile);
        $partSize = is_file($partFile) ? (float) filesize($partFile) : 0.0;
        $remaining = max(0, (int) $job->data['totals']['bytes'] - (int) $job->data['archive']['processed_bytes']);
        $need = $partSize + min(self::MAX_BATCH_BYTES, $remaining) + self::SPACE_RESERVE;
        if ($free < $need) {
            $this->logger->error(sprintf('Job %s: paused, free space %.0f < required %.0f bytes.', $job->getId(), $free, $need));
            throw new EgeserBackupException(sprintf(
                'Disk alanı yetersiz (boş: %s, sonraki adım için gereken: yaklaşık %s). İşlem duraklatıldı. '
                . 'Eski yedekleri silip "Devam Et" ile kaldığı yerden sürdürebilirsiniz.',
                EgeserBackupStorage::formatBytes($free),
                EgeserBackupStorage::formatBytes($need)
            ));
        }
    }
}
