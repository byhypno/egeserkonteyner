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
 * Phase 3: verification and finalisation.
 *
 * For every part (one request per stage):
 *   1. "check": file exists, size > 0, ZipArchive::open(CHECKCONS) succeeds and
 *      numFiles equals the number of entries the archiver added;
 *   2. "hash": SHA-256 of the part (hash_file streams the file).
 * When all parts are verified they are moved to backups/, the meta file and
 * the report are written and the job is removed. Only then the backup is
 * reported as successful.
 */
class EgeserBackupVerifier implements EgeserBackupPhaseInterface
{
    /** @var EgeserBackupRepository */
    private $repository;

    /** @var EgeserBackupLogger */
    private $logger;

    /** @var array|null */
    private $completed;

    /**
     * @param EgeserBackupRepository $repository
     * @param EgeserBackupLogger $logger
     */
    public function __construct(EgeserBackupRepository $repository, EgeserBackupLogger $logger)
    {
        $this->repository = $repository;
        $this->logger = $logger;
    }

    /**
     * @return array|null meta of the backup finished by the last run() call
     */
    public function getCompleted()
    {
        return $this->completed;
    }

    /**
     * {@inheritdoc}
     */
    public function run(EgeserBackupJob $job, $deadline)
    {
        if (!class_exists('ZipArchive')) {
            throw new EgeserBackupException('Sunucuda PHP ZipArchive extension aktif değil.');
        }
        $verify = &$job->data['verify'];
        $parts = $job->data['archive']['parts'];
        $totalEntries = 0;
        foreach ($parts as $part) {
            $totalEntries += (int) $part['entries'];
        }
        if ($totalEntries === 0) {
            $this->fail($job, 'ZIP dosyasına hiçbir dosya eklenemedi. Hata listesini kontrol edin.');

            return;
        }

        $index = (int) $verify['index'];
        if ($index < count($parts)) {
            $file = $job->partFile($index);
            $label = count($parts) > 1 ? sprintf('ZIP parçası %d', $index + 1) : 'ZIP dosyası';
            if ($verify['stage'] === 'check') {
                clearstatcache(true, $file);
                if (!is_file($file)) {
                    $this->fail($job, $label . ' bulunamadı.');

                    return;
                }
                $size = (float) filesize($file);
                if ($size <= 0) {
                    $this->fail($job, $label . ' boş (0 bayt).');

                    return;
                }
                $zip = new ZipArchive();
                $opened = $zip->open($file, ZipArchive::CHECKCONS);
                if ($opened !== true) {
                    $this->fail($job, $label . ' tutarlılık kontrolünden geçemedi (ZipArchive kodu ' . (int) $opened . ').');

                    return;
                }
                $numFiles = (int) $zip->numFiles;
                $zip->close();
                $expected = (int) $parts[$index]['entries'];
                if ($numFiles !== $expected) {
                    $this->fail($job, sprintf(
                        '%s içindeki kayıt sayısı (%d) beklenen sayı (%d) ile uyuşmuyor.',
                        $label,
                        $numFiles,
                        $expected
                    ));

                    return;
                }
                $verify['results'][$index] = array('size' => $size, 'entries' => $numFiles, 'sha256' => '');
                $verify['stage'] = 'hash';
            } else {
                $hash = @hash_file('sha256', $file);
                if ($hash === false) {
                    $this->fail($job, $label . ' için SHA-256 hesaplanamadı.');

                    return;
                }
                $verify['results'][$index]['sha256'] = $hash;
                $verify['stage'] = 'check';
                $verify['index'] = $index + 1;
            }
            $job->commit();

            return;
        }

        $meta = $this->repository->finalize($job);
        $this->logger->info(sprintf(
            'Backup %s completed: %d part(s), %d entries, %d skipped, %d unreadable, %d errors.',
            $meta['id'],
            count($meta['parts']),
            (int) $meta['counters']['success'],
            (int) $meta['counters']['skipped'],
            (int) $meta['counters']['unreadable'],
            (int) $meta['counters']['errors']
        ));
        $job->destroy();
        $this->completed = $this->repository->get($meta['id']);
    }

    /**
     * @param EgeserBackupJob $job
     * @param string $message
     */
    private function fail(EgeserBackupJob $job, $message)
    {
        $job->data['status'] = EgeserBackupJob::STATUS_FAILED;
        $job->data['error'] = $message;
        $job->commit();
        $this->logger->error(sprintf('Job %s failed during verification: %s', $job->getId(), $message));
    }
}
