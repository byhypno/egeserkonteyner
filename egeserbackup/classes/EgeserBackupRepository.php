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
 * Finished backups: backups/<id>.json (meta), <id>.zip or <id>.partN.zip,
 * <id>.report.txt.
 *
 * Security: callers only ever pass a backup id (validated against a strict
 * pattern) and a part number. File names are taken from the server side meta
 * file, validated again and resolved with realpath() inside the backups
 * directory. A user supplied file name or path is never used.
 */
class EgeserBackupRepository
{
    public const FILE_PATTERN = '/^[a-z0-9][a-z0-9.-]{2,160}\.(zip|txt)$/';

    /** @var EgeserBackupStorage */
    private $storage;

    /**
     * @param EgeserBackupStorage $storage
     */
    public function __construct(EgeserBackupStorage $storage)
    {
        $this->storage = $storage;
    }

    /**
     * @return array list of meta arrays, newest first
     */
    public function all()
    {
        $result = array();
        $entries = @scandir($this->storage->backupsDir());
        if ($entries === false) {
            return $result;
        }
        foreach ($entries as $entry) {
            if (substr($entry, -5) !== '.json') {
                continue;
            }
            $meta = $this->get(substr($entry, 0, -5));
            if ($meta !== null) {
                $result[] = $meta;
            }
        }
        usort($result, function ($a, $b) {
            return (int) $b['completed_at'] - (int) $a['completed_at'];
        });

        return $result;
    }

    /**
     * @param string $id
     *
     * @return array|null
     */
    public function get($id)
    {
        if (!EgeserBackupJob::isValidId($id)) {
            return null;
        }
        $meta = $this->storage->readJson($this->storage->backupsDir() . '/' . $id . '.json');
        if (!is_array($meta) || !isset($meta['id'], $meta['parts']) || $meta['id'] !== $id || !is_array($meta['parts'])) {
            return null;
        }
        $meta['total_size'] = 0.0;
        $meta['missing_parts'] = 0;
        foreach ($meta['parts'] as $index => $part) {
            $path = isset($part['file']) ? $this->safePath($part['file']) : null;
            $meta['parts'][$index]['number'] = $index + 1;
            $meta['parts'][$index]['exists'] = $path !== null;
            if ($path === null) {
                ++$meta['missing_parts'];
            } else {
                $meta['total_size'] += (float) filesize($path);
            }
        }
        $meta['has_report'] = !empty($meta['report']) && $this->safePath($meta['report']) !== null;

        return $meta;
    }

    /**
     * True when the id is used by a finished backup or a job directory.
     *
     * @param string $id
     *
     * @return bool
     */
    public function exists($id)
    {
        $dir = $this->storage->backupsDir();

        return is_file($dir . '/' . $id . '.json')
            || is_file($dir . '/' . $id . '.zip')
            || is_file($dir . '/' . $id . '.part1.zip')
            || is_dir($this->storage->workDir() . '/' . $id);
    }

    /**
     * @param string $slug
     * @param int $timestamp
     *
     * @return string
     */
    public function generateId($slug, $timestamp)
    {
        $base = $slug . '-files-' . date('Y-m-d-Hi', $timestamp);
        $id = $base;
        $n = 2;
        while ($this->exists($id)) {
            $id = $base . '-' . $n;
            ++$n;
        }

        return $id;
    }

    /**
     * @param string $id
     * @param int $number 1 based part number
     *
     * @return string|null absolute path
     */
    public function partPath($id, $number)
    {
        $meta = $this->get($id);
        $index = (int) $number - 1;
        if ($meta === null || $index < 0 || !isset($meta['parts'][$index]['file'])) {
            return null;
        }

        return $this->safePath($meta['parts'][$index]['file']);
    }

    /**
     * @param string $id
     *
     * @return string|null absolute path
     */
    public function reportPath($id)
    {
        $meta = $this->get($id);
        if ($meta === null || empty($meta['report'])) {
            return null;
        }

        return $this->safePath($meta['report']);
    }

    /**
     * @param string $id
     *
     * @return bool
     */
    public function delete($id)
    {
        $meta = $this->get($id);
        if ($meta === null) {
            return false;
        }
        foreach ($meta['parts'] as $part) {
            $path = $this->safePath($part['file']);
            if ($path !== null) {
                @unlink($path);
            }
        }
        if (!empty($meta['report'])) {
            $path = $this->safePath($meta['report']);
            if ($path !== null) {
                @unlink($path);
            }
        }

        return @unlink($this->storage->backupsDir() . '/' . $id . '.json');
    }

    /**
     * @param int $days
     *
     * @return string[] deleted ids
     */
    public function deleteOlderThan($days)
    {
        $limit = time() - ((int) $days * 86400);
        $deleted = array();
        foreach ($this->all() as $meta) {
            if ((int) $meta['completed_at'] < $limit && $this->delete($meta['id'])) {
                $deleted[] = $meta['id'];
            }
        }

        return $deleted;
    }

    /**
     * Moves the verified parts of a job into backups/ and writes meta + report.
     * Idempotent: can be re-run after an interruption.
     *
     * @param EgeserBackupJob $job
     *
     * @return array meta
     *
     * @throws EgeserBackupException
     */
    public function finalize(EgeserBackupJob $job)
    {
        $id = $job->getId();
        $dir = $this->storage->backupsDir();
        $parts = $job->data['archive']['parts'];
        $results = $job->data['verify']['results'];
        $multi = count($parts) > 1;
        $metaParts = array();

        foreach ($parts as $index => $part) {
            $final = $multi ? sprintf('%s.part%d.zip', $id, $index + 1) : $id . '.zip';
            $source = $job->partFile($index);
            $target = $dir . '/' . $final;
            if (is_file($source)) {
                if (!@rename($source, $target)) {
                    throw new EgeserBackupException('Tamamlanan ZIP dosyası yedek klasörüne taşınamadı.');
                }
            } elseif (!is_file($target)) {
                throw new EgeserBackupException('ZIP parçası bulunamadı: ' . $final);
            }
            $metaParts[] = array(
                'file' => $final,
                'size' => isset($results[$index]['size']) ? $results[$index]['size'] : (float) filesize($target),
                'entries' => isset($results[$index]['entries']) ? $results[$index]['entries'] : (int) $part['entries'],
                'sha256' => isset($results[$index]['sha256']) ? $results[$index]['sha256'] : '',
            );
        }

        $reportName = $id . '.report.txt';
        $this->writeReport($job, $metaParts, $dir . '/' . $reportName);

        $settings = $job->data['settings'];
        $meta = array(
            'id' => $id,
            'type' => 'files',
            'module_version' => '1.0.0',
            'status' => 'completed',
            'created_at' => (int) $job->data['created_at'],
            'completed_at' => time(),
            'duration' => time() - (int) $job->data['started_at'],
            'parts' => $metaParts,
            'report' => $reportName,
            'totals' => $job->data['totals'],
            'counters' => $job->data['counters'],
            'settings' => array(
                'include_cache' => !empty($settings['include_cache']),
                'include_logs' => !empty($settings['include_logs']),
                'extra_excludes' => $settings['extra_excludes'],
                'part_size_mb' => (int) $settings['part_size_mb'],
            ),
        );
        $this->storage->writeJson($dir . '/' . $id . '.json', $meta);

        return $meta;
    }

    /**
     * @param string $file
     *
     * @return string|null
     */
    private function safePath($file)
    {
        if (!is_string($file) || !preg_match(self::FILE_PATTERN, $file)) {
            return null;
        }
        $dir = $this->storage->backupsDir();
        $path = $dir . '/' . $file;
        if (is_link($path) || !is_file($path) || !EgeserBackupStorage::isInside($path, $dir)) {
            return null;
        }

        return $path;
    }

    /**
     * @param EgeserBackupJob $job
     * @param array $parts
     * @param string $target
     *
     * @throws EgeserBackupException
     */
    private function writeReport(EgeserBackupJob $job, array $parts, $target)
    {
        $d = $job->data;
        $lines = array(
            'Egeser Full Backup - Yedek Raporu',
            '==================================',
            'Yedek kimliği     : ' . $d['id'],
            'Tür               : Dosya sistemi yedeği (veritabanı DAHİL DEĞİLDİR)',
            'Başlangıç         : ' . date('Y-m-d H:i:s', (int) $d['started_at']),
            'Bitiş             : ' . date('Y-m-d H:i:s'),
            'Toplam dosya      : ' . (int) $d['totals']['files'],
            'Boş klasör kaydı  : ' . (int) $d['totals']['dirs'],
            'Kaynak boyut      : ' . EgeserBackupStorage::formatBytes($d['totals']['bytes']),
            'Başarılı kayıt    : ' . (int) $d['counters']['success'],
            'Atlanan           : ' . (int) $d['counters']['skipped'],
            'Okunamayan        : ' . (int) $d['counters']['unreadable'],
            'Hata              : ' . (int) $d['counters']['errors'],
            'Hariç tutulan     : ' . (int) $d['totals']['excluded'],
            '',
            'ZIP dosyaları:',
        );
        foreach ($parts as $part) {
            $lines[] = sprintf(
                '  %s  %s  %d kayıt  SHA-256: %s',
                $part['file'],
                EgeserBackupStorage::formatBytes($part['size']),
                (int) $part['entries'],
                $part['sha256']
            );
        }
        $lines[] = '';
        $lines[] = 'Sorunlu dosyalar (tür <TAB> yol <TAB> açıklama):';
        $header = implode("\n", $lines) . "\n";

        $out = @fopen($target, 'wb');
        if ($out === false) {
            throw new EgeserBackupException('Yedek raporu yazılamadı.');
        }
        fwrite($out, $header);
        $issuesSize = (int) $d['issues_size'];
        if ($issuesSize > 0) {
            $in = @fopen($job->issuesFile(), 'rb');
            if ($in !== false) {
                stream_copy_to_stream($in, $out, $issuesSize);
                fclose($in);
            }
        } else {
            fwrite($out, "  (yok)\n");
        }
        fclose($out);
    }
}
