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
 * Orchestrates the single active job: start, step, cancel, status, cleanup.
 * The admin controller only handles HTTP concerns (auth, token, JSON) and
 * delegates everything else to this class.
 */
class EgeserBackupManager
{
    public const ISSUE_LIMIT = 50;

    /** @var EgeserBackupStorage */
    private $storage;

    /** @var EgeserBackupLogger */
    private $logger;

    /** @var EgeserBackupRepository */
    private $repository;

    /**
     * @param EgeserBackupStorage $storage
     * @param EgeserBackupLogger $logger
     */
    public function __construct(EgeserBackupStorage $storage, EgeserBackupLogger $logger)
    {
        $this->storage = $storage;
        $this->logger = $logger;
        $this->repository = new EgeserBackupRepository($storage);
    }

    /**
     * @return EgeserBackupRepository
     */
    public function getRepository()
    {
        return $this->repository;
    }

    /**
     * Current job. A pending cancel request is executed here as well, so a
     * cancel issued while a step was running is never lost.
     *
     * @return EgeserBackupJob|null
     */
    public function getJob()
    {
        $job = EgeserBackupJob::load($this->storage);
        if ($job !== null && is_file($this->storage->cancelFlagFile())) {
            $lock = new EgeserBackupLock($this->storage->lockFile());
            if ($lock->acquire()) {
                $job = EgeserBackupJob::load($this->storage);
                if ($job !== null) {
                    $this->doCancel($job);
                }
                @unlink($this->storage->cancelFlagFile());
                $lock->release();

                return null;
            }
        }

        return $job;
    }

    /**
     * @param array $settings
     * @param string $slug
     * @param bool $autostart
     *
     * @return EgeserBackupJob
     *
     * @throws EgeserBackupException
     */
    public function startScan(array $settings, $slug, $autostart)
    {
        $lock = new EgeserBackupLock($this->storage->lockFile());
        if (!$lock->acquire()) {
            throw new EgeserBackupException('Devam eden bir backup işlemi var.');
        }
        try {
            if (EgeserBackupJob::load($this->storage) !== null) {
                throw new EgeserBackupException('Devam eden bir backup işlemi var. Önce devam ettirin veya iptal edin.');
            }
            @unlink($this->storage->cancelFlagFile());
            $id = $this->repository->generateId($slug, time());
            $job = EgeserBackupJob::create($this->storage, $id, $settings, $autostart);
            $this->logger->info(sprintf('Job %s created (scan%s).', $id, $autostart ? ' + backup' : ' only'));

            return $job;
        } finally {
            $lock->release();
        }
    }

    /**
     * Moves a scanned job into the archive phase after the disk space check.
     *
     * @param bool $confirmed user accepted the disk space warning
     *
     * @return array array('job' => EgeserBackupJob) or array('need_confirm' => true, 'message' => string)
     *
     * @throws EgeserBackupException
     */
    public function startArchive($confirmed)
    {
        $lock = new EgeserBackupLock($this->storage->lockFile());
        if (!$lock->acquire()) {
            throw new EgeserBackupException('Devam eden bir backup işlemi var.');
        }
        try {
            $job = EgeserBackupJob::load($this->storage);
            if ($job === null) {
                throw new EgeserBackupException('Aktif bir yedekleme işi bulunamadı. Önce dosyaları tarayın.');
            }
            $status = $job->getStatus();
            if ($status === EgeserBackupJob::STATUS_ARCHIVE || $status === EgeserBackupJob::STATUS_VERIFY) {
                return array('job' => $job);
            }
            if ($status !== EgeserBackupJob::STATUS_READY) {
                throw new EgeserBackupException('Tarama henüz tamamlanmadı.');
            }
            if ((int) $job->data['totals']['files'] + (int) $job->data['totals']['dirs'] === 0) {
                throw new EgeserBackupException('Yedeklenecek dosya bulunamadı.');
            }
            $space = $this->spaceCheck($job);
            if ($space['level'] === 'block') {
                throw new EgeserBackupException($space['message']);
            }
            if (($space['level'] === 'warn' || $space['level'] === 'unknown') && !$confirmed) {
                return array('need_confirm' => true, 'message' => $space['message'], 'job' => $job);
            }
            $job->advancePhase();
            $job->data['archive']['started_at'] = time();
            $job->save();
            $this->logger->info(sprintf(
                'Job %s: archiving started (%d files, %s).',
                $job->getId(),
                (int) $job->data['totals']['files'],
                EgeserBackupStorage::formatBytes($job->data['totals']['bytes'])
            ));

            return array('job' => $job);
        } finally {
            $lock->release();
        }
    }

    /**
     * Executes one bounded unit of work of the active job.
     *
     * @return array keys: job (EgeserBackupJob|null), busy (bool), completed (array|null), cancelled (bool)
     *
     * @throws EgeserBackupException
     */
    public function step()
    {
        $result = array('job' => null, 'busy' => false, 'completed' => null, 'cancelled' => false);
        $lock = new EgeserBackupLock($this->storage->lockFile());
        if (!$lock->acquire()) {
            $result['busy'] = true;
            $result['job'] = EgeserBackupJob::load($this->storage);

            return $result;
        }
        try {
            $job = EgeserBackupJob::load($this->storage);
            if ($job === null) {
                return $result;
            }
            if (is_file($this->storage->cancelFlagFile())) {
                $this->doCancel($job);
                $result['cancelled'] = true;

                return $result;
            }
            if (!$job->isRunnable()) {
                $result['job'] = $job;

                return $result;
            }
            $deadline = microtime(true) + self::timeBudget();
            self::prepareRuntime();
            $job->beginStep();
            $phase = $this->phase($job->getStatus());
            $phase->run($job, $deadline);
            if ($phase instanceof EgeserBackupVerifier && $phase->getCompleted() !== null) {
                $result['completed'] = $phase->getCompleted();

                return $result;
            }
            $result['job'] = $job;

            return $result;
        } finally {
            $lock->release();
        }
    }

    /**
     * @return array keys: cancelled (bool), pending (bool)
     *
     * @throws EgeserBackupException
     */
    public function cancel()
    {
        if (EgeserBackupJob::load($this->storage) === null) {
            @unlink($this->storage->cancelFlagFile());

            return array('cancelled' => true, 'pending' => false);
        }
        if (@file_put_contents($this->storage->cancelFlagFile(), (string) time()) === false) {
            throw new EgeserBackupException('İptal isteği kaydedilemedi.');
        }
        $lock = new EgeserBackupLock($this->storage->lockFile());
        if (!$lock->acquire()) {
            // A step is running right now; it will be cancelled as soon as it ends.
            return array('cancelled' => false, 'pending' => true);
        }
        try {
            $job = EgeserBackupJob::load($this->storage);
            if ($job !== null) {
                $this->doCancel($job);
            }
            @unlink($this->storage->cancelFlagFile());

            return array('cancelled' => true, 'pending' => false);
        } finally {
            $lock->release();
        }
    }

    /**
     * Deletes backups older than $days and orphaned work directories.
     *
     * @param int $days
     *
     * @return array keys: deleted (string[]), orphans (int)
     */
    public function cleanup($days)
    {
        $deleted = $this->repository->deleteOlderThan($days);
        $orphans = 0;
        $lock = new EgeserBackupLock($this->storage->lockFile());
        if ($lock->acquire()) {
            $job = EgeserBackupJob::load($this->storage);
            $activeId = $job !== null ? $job->getId() : null;
            $entries = @scandir($this->storage->workDir());
            foreach ($entries === false ? array() : $entries as $entry) {
                $path = $this->storage->workDir() . '/' . $entry;
                if ($entry !== $activeId && EgeserBackupJob::isValidId($entry) && is_dir($path) && !is_link($path)) {
                    if ($this->storage->deleteTree($path)) {
                        ++$orphans;
                    }
                }
            }
            $lock->release();
        }
        if ($deleted || $orphans) {
            $this->logger->info(sprintf('Cleanup: %d backup(s) older than %d days and %d orphan work dir(s) deleted.', count($deleted), $days, $orphans));
        }

        return array('deleted' => $deleted, 'orphans' => $orphans);
    }

    /**
     * Disk space assessment for the scanned job.
     *
     * - block: free space is below half of the source size (a ZIP of a typical
     *   image heavy shop never gets that small) -> the backup is not started;
     * - warn: free space is below source size + temp copy of one part;
     * - unknown: disk_free_space() is disabled on the host.
     *
     * @param EgeserBackupJob $job
     *
     * @return array
     */
    public function spaceCheck(EgeserBackupJob $job)
    {
        $total = (float) $job->data['totals']['bytes'];
        $free = $this->storage->freeSpace();
        $partLimit = (float) $job->data['settings']['part_size_mb'] * 1048576;
        $tempCopy = $partLimit > 0 ? min($partLimit, $total) : $total;
        $recommended = $total * 1.05 + $tempCopy + 104857600;
        $minimum = $total * 0.5 + 52428800;

        $info = array(
            'total' => $total,
            'total_h' => EgeserBackupStorage::formatBytes($total),
            'free' => $free,
            'free_h' => $free === null ? '-' : EgeserBackupStorage::formatBytes($free),
            'recommended_h' => EgeserBackupStorage::formatBytes($recommended),
            'level' => 'ok',
            'message' => '',
        );
        if ($free === null) {
            $info['level'] = 'unknown';
            $info['message'] = sprintf(
                'Sunucudaki boş disk alanı tespit edilemedi (disk_free_space devre dışı). Kaynak dosya boyutu: %s. '
                . 'Yeterli alan olduğundan emin değilseniz işlemi başlatmayın.',
                $info['total_h']
            );
        } elseif ($free < $minimum) {
            $info['level'] = 'block';
            $info['message'] = sprintf(
                'Yetersiz disk alanı: kaynak dosyalar %s, boş alan yalnızca %s. Yedekleme başlatılamaz. '
                . 'Eski yedekleri silin veya ayarlardan büyük klasörleri hariç tutun.',
                $info['total_h'],
                $info['free_h']
            );
        } elseif ($free < $recommended) {
            $info['level'] = 'warn';
            $info['message'] = sprintf(
                'Boş disk alanı (%s) sınırda olabilir. Kaynak dosya boyutu %s, önerilen boş alan en az %s. '
                . 'ZIP sıkıştırma oranı önceden kesin tahmin edilemez; alan biterse işlem duraklatılır.',
                $info['free_h'],
                $info['total_h'],
                $info['recommended_h']
            );
        } else {
            $info['message'] = sprintf(
                'Kaynak dosya boyutu %s, boş disk alanı %s. ZIP boyutu sıkıştırma oranına göre değişir, kesin tahmin edilemez.',
                $info['total_h'],
                $info['free_h']
            );
        }

        return $info;
    }

    /**
     * Data for the progress screen (all paths are root relative).
     *
     * @param EgeserBackupJob $job
     *
     * @return array
     */
    public function summary(EgeserBackupJob $job)
    {
        $d = $job->data;
        $status = $job->getStatus();
        $totalEntries = (int) $d['totals']['files'] + (int) $d['totals']['dirs'];
        $processed = (int) $d['archive']['processed'];
        $percent = null;
        if ($status === EgeserBackupJob::STATUS_READY) {
            $percent = 0;
        } elseif ($status === EgeserBackupJob::STATUS_ARCHIVE) {
            $percent = $totalEntries > 0 ? min(100, round($processed * 100 / $totalEntries, 1)) : 0;
        } elseif ($status === EgeserBackupJob::STATUS_VERIFY) {
            $percent = 100;
        }
        $zipSize = EgeserBackupArchiver::archiveSize($job);
        $labels = array(
            EgeserBackupJob::STATUS_SCAN => 'Dosyalar taranıyor',
            EgeserBackupJob::STATUS_READY => 'Tarama tamamlandı',
            EgeserBackupJob::STATUS_ARCHIVE => 'ZIP oluşturuluyor',
            EgeserBackupJob::STATUS_VERIFY => 'ZIP doğrulanıyor ve SHA-256 hesaplanıyor',
            EgeserBackupJob::STATUS_FAILED => 'Başarısız',
        );
        $summary = array(
            'id' => $d['id'],
            'status' => $status,
            'status_label' => isset($labels[$status]) ? $labels[$status] : $status,
            'autostart' => !empty($d['autostart']),
            'total_files' => (int) $d['totals']['files'],
            'total_dirs' => (int) $d['totals']['dirs'],
            'total_entries' => $totalEntries,
            'total_bytes' => (float) $d['totals']['bytes'],
            'total_bytes_h' => EgeserBackupStorage::formatBytes($d['totals']['bytes']),
            'excluded' => (int) $d['totals']['excluded'],
            'dirs_scanned' => (int) $d['scan']['dirs_scanned'],
            'pending_dirs' => count($d['scan']['stack']),
            'processed' => $processed,
            'percent' => $percent,
            'success' => (int) $d['counters']['success'],
            'skipped' => (int) $d['counters']['skipped'],
            'unreadable' => (int) $d['counters']['unreadable'],
            'errors' => (int) $d['counters']['errors'],
            'current_file' => (string) $d['archive']['current_file'],
            'zip_size' => $zipSize,
            'zip_size_h' => EgeserBackupStorage::formatBytes($zipSize),
            'parts' => count($d['archive']['parts']),
            'verify_part' => (int) $d['verify']['index'] + 1,
            'started_at' => (int) $d['started_at'],
            'now' => time(),
            'error' => (string) $d['error'],
            'space' => null,
            'issues' => $job->recentIssues(self::ISSUE_LIMIT),
        );
        if ($status === EgeserBackupJob::STATUS_READY || $status === EgeserBackupJob::STATUS_ARCHIVE) {
            $summary['space'] = $this->spaceCheck($job);
        }

        return $summary;
    }

    /**
     * Seconds of work per request: 30% of max_execution_time, between 5 and 20 s.
     *
     * @return float
     */
    public static function timeBudget()
    {
        $max = (int) ini_get('max_execution_time');
        if ($max <= 0) {
            $max = 120;
        }

        return (float) max(5, min(20, (int) floor($max * 0.3)));
    }

    /**
     * Keep working if the browser disconnects and give libzip head room.
     */
    public static function prepareRuntime()
    {
        if (EgeserBackupStorage::functionAvailable('ignore_user_abort')) {
            @ignore_user_abort(true);
        }
        if (EgeserBackupStorage::functionAvailable('set_time_limit')) {
            @set_time_limit(300);
        }
    }

    /**
     * Phase registry. A future database dump phase is added here.
     *
     * @param string $status
     *
     * @return EgeserBackupPhaseInterface
     *
     * @throws EgeserBackupException
     */
    private function phase($status)
    {
        switch ($status) {
            case EgeserBackupJob::STATUS_SCAN:
                return new EgeserBackupScanner($this->storage);
            case EgeserBackupJob::STATUS_ARCHIVE:
                return new EgeserBackupArchiver($this->storage, $this->logger);
            case EgeserBackupJob::STATUS_VERIFY:
                return new EgeserBackupVerifier($this->repository, $this->logger);
        }
        throw new EgeserBackupException('Bilinmeyen yedekleme adımı.');
    }

    /**
     * @param EgeserBackupJob $job
     */
    private function doCancel(EgeserBackupJob $job)
    {
        $id = $job->getId();
        $job->destroy();
        $this->logger->info(sprintf('Job %s cancelled; partial ZIP, manifest and state removed.', $id));
    }
}
