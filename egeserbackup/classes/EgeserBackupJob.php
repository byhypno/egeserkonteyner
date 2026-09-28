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
 * File based job state (work/job.json) for the single active backup.
 *
 * Crash safety: the manifest and the issue log are append-only files whose
 * "committed" sizes are stored in job.json. Every step first truncates both
 * files back to the committed sizes (undoing whatever a killed request may
 * have appended) and commits the new sizes together with the new state in a
 * single atomic job.json write. A request killed by max_execution_time can
 * therefore always be retried safely.
 */
class EgeserBackupJob
{
    public const STATUS_SCAN = 'scan';
    public const STATUS_READY = 'ready';
    public const STATUS_ARCHIVE = 'archive';
    public const STATUS_VERIFY = 'verify';
    public const STATUS_FAILED = 'failed';

    public const ISSUE_SKIPPED = 'skipped';
    public const ISSUE_UNREADABLE = 'unreadable';
    public const ISSUE_ERROR = 'error';

    public const ID_PATTERN = '/^[a-z0-9][a-z0-9-]{2,100}$/';

    /**
     * Raw state; persisted as JSON.
     *
     * @var array
     */
    public $data;

    /** @var EgeserBackupStorage */
    private $storage;

    /**
     * @param EgeserBackupStorage $storage
     * @param array $data
     */
    private function __construct(EgeserBackupStorage $storage, array $data)
    {
        $this->storage = $storage;
        $this->data = $data;
    }

    /**
     * @param EgeserBackupStorage $storage
     *
     * @return self|null
     */
    public static function load(EgeserBackupStorage $storage)
    {
        $data = $storage->readJson($storage->jobFile());
        if (!is_array($data) || !isset($data['id'], $data['status']) || !self::isValidId($data['id'])) {
            return null;
        }

        return new self($storage, $data);
    }

    /**
     * @param EgeserBackupStorage $storage
     * @param string $id
     * @param array $settings
     * @param bool $autostart continue with archiving automatically after the scan
     *
     * @return self
     *
     * @throws EgeserBackupException
     */
    public static function create(EgeserBackupStorage $storage, $id, array $settings, $autostart)
    {
        if (!self::isValidId($id)) {
            throw new EgeserBackupException('Geçersiz yedek kimliği.');
        }
        $now = time();
        $job = new self($storage, array(
            'version' => 1,
            'id' => $id,
            'status' => self::STATUS_SCAN,
            // Phases executed after the scan once the user confirms. A future
            // "database dump" feature adds a 'dbdump' phase here (see README).
            'phases' => array(self::STATUS_ARCHIVE, self::STATUS_VERIFY),
            'created_at' => $now,
            'started_at' => $now,
            'updated_at' => $now,
            'autostart' => (bool) $autostart,
            'settings' => $settings,
            'error' => '',
            'scan' => array(
                'stack' => array(rawurlencode('')),
                'dirs_scanned' => 0,
                'finished_at' => 0,
            ),
            'totals' => array('files' => 0, 'dirs' => 0, 'bytes' => 0, 'excluded' => 0),
            'counters' => array('success' => 0, 'skipped' => 0, 'unreadable' => 0, 'errors' => 0),
            'manifest_size' => 0,
            'issues_size' => 0,
            'archive' => array(
                'offset' => 0,
                'processed' => 0,
                'processed_bytes' => 0,
                'part' => 0,
                'parts' => array(array('file' => 'part1.zip', 'entries' => 0)),
                'inflight' => null,
                'safe_until' => 0,
                'current_file' => '',
                'started_at' => 0,
            ),
            'verify' => array('index' => 0, 'stage' => 'check', 'results' => array()),
        ));
        $dir = $job->dir();
        if (!is_dir($dir) && !@mkdir($dir, 0755, true)) {
            throw new EgeserBackupException('Yedek çalışma dizini oluşturulamadı.');
        }
        foreach (array($job->manifestFile(), $job->issuesFile()) as $file) {
            if (@file_put_contents($file, '') === false) {
                throw new EgeserBackupException('Manifest dosyası oluşturulamadı.');
            }
        }
        $job->save();

        return $job;
    }

    /**
     * @param string $id
     *
     * @return bool
     */
    public static function isValidId($id)
    {
        return is_string($id) && (bool) preg_match(self::ID_PATTERN, $id);
    }

    /**
     * @return string
     */
    public function getId()
    {
        return $this->data['id'];
    }

    /**
     * @return string
     */
    public function getStatus()
    {
        return $this->data['status'];
    }

    /**
     * @return bool
     */
    public function isRunnable()
    {
        return in_array($this->getStatus(), array(self::STATUS_SCAN, self::STATUS_ARCHIVE, self::STATUS_VERIFY), true);
    }

    /**
     * @return string
     */
    public function dir()
    {
        return $this->storage->workDir() . '/' . $this->data['id'];
    }

    /**
     * @return string
     */
    public function manifestFile()
    {
        return $this->dir() . '/manifest.txt';
    }

    /**
     * @return string
     */
    public function issuesFile()
    {
        return $this->dir() . '/issues.log';
    }

    /**
     * @param int $index zero based part index
     *
     * @return string
     */
    public function partFile($index)
    {
        return $this->dir() . '/' . $this->data['archive']['parts'][$index]['file'];
    }

    /**
     * Moves the job to the next phase in its pipeline.
     */
    public function advancePhase()
    {
        $phases = $this->data['phases'];
        $current = array_search($this->data['status'], $phases, true);
        if ($this->data['status'] === self::STATUS_READY) {
            $this->data['status'] = $phases[0];

            return;
        }
        if ($current === false || !isset($phases[$current + 1])) {
            throw new EgeserBackupException('Yedekleme adımları tutarsız.');
        }
        $this->data['status'] = $phases[$current + 1];
    }

    /**
     * Undo anything a previously killed request appended after the last commit.
     */
    public function beginStep()
    {
        self::truncate($this->manifestFile(), (int) $this->data['manifest_size']);
        self::truncate($this->issuesFile(), (int) $this->data['issues_size']);
    }

    /**
     * Persists state together with the new committed file sizes.
     *
     * @throws EgeserBackupException
     */
    public function commit()
    {
        clearstatcache();
        $this->data['manifest_size'] = is_file($this->manifestFile()) ? (int) filesize($this->manifestFile()) : 0;
        $this->data['issues_size'] = is_file($this->issuesFile()) ? (int) filesize($this->issuesFile()) : 0;
        $this->save();
    }

    /**
     * @throws EgeserBackupException
     */
    public function save()
    {
        $this->data['updated_at'] = time();
        $this->storage->writeJson($this->storage->jobFile(), $this->data);
    }

    /**
     * Appends issues and updates the matching counters.
     *
     * @param array $issues list of array(type, relativePath, message)
     *
     * @throws EgeserBackupException
     */
    public function appendIssues(array $issues)
    {
        if (!$issues) {
            return;
        }
        $buffer = '';
        foreach ($issues as $issue) {
            list($type, $path, $message) = $issue;
            if ($type === self::ISSUE_SKIPPED) {
                ++$this->data['counters']['skipped'];
            } elseif ($type === self::ISSUE_UNREADABLE) {
                ++$this->data['counters']['unreadable'];
            } else {
                $type = self::ISSUE_ERROR;
                ++$this->data['counters']['errors'];
            }
            $buffer .= $type . "\t" . self::clean($path) . "\t" . self::clean($message) . "\n";
        }
        if (@file_put_contents($this->issuesFile(), $buffer, FILE_APPEND | LOCK_EX) === false) {
            throw new EgeserBackupException('Hata raporu yazılamadı. Disk alanını kontrol edin.');
        }
    }

    /**
     * Last issues (newest last), read from the end of the issue log.
     *
     * @param int $limit
     *
     * @return array
     */
    public function recentIssues($limit)
    {
        return self::readIssueTail($this->issuesFile(), $limit, (int) $this->data['issues_size']);
    }

    /**
     * @param string $file
     * @param int $limit
     * @param int|null $size committed size (bytes beyond are ignored)
     *
     * @return array
     */
    public static function readIssueTail($file, $limit, $size = null)
    {
        if (!is_file($file)) {
            return array();
        }
        if ($size === null) {
            $size = (int) filesize($file);
        }
        if ($size <= 0) {
            return array();
        }
        $handle = @fopen($file, 'rb');
        if ($handle === false) {
            return array();
        }
        $read = min($size, 131072);
        fseek($handle, $size - $read);
        $chunk = (string) fread($handle, $read);
        fclose($handle);
        $lines = explode("\n", rtrim($chunk, "\n"));
        if ($read < $size) {
            array_shift($lines);
        }
        $result = array();
        foreach (array_slice($lines, -$limit) as $line) {
            $parts = explode("\t", $line, 3);
            if (count($parts) === 3) {
                $result[] = array('type' => $parts[0], 'path' => $parts[1], 'message' => $parts[2]);
            }
        }

        return $result;
    }

    /**
     * Removes the job directory (manifest, partial ZIP parts, libzip temp files)
     * and the state files.
     */
    public function destroy()
    {
        $this->storage->deleteTree($this->dir());
        @unlink($this->storage->jobFile());
        @unlink($this->storage->cancelFlagFile());
    }

    /**
     * @param string $value
     *
     * @return string
     */
    private static function clean($value)
    {
        return preg_replace('/[\x00-\x1F\x7F]+/', ' ', (string) $value);
    }

    /**
     * @param string $file
     * @param int $size
     *
     * @throws EgeserBackupException
     */
    private static function truncate($file, $size)
    {
        clearstatcache(true, $file);
        if (!is_file($file)) {
            if ($size > 0) {
                throw new EgeserBackupException('Yedek çalışma dosyaları eksik. İşlemi iptal edip yeniden başlatın.');
            }
            @file_put_contents($file, '');

            return;
        }
        $current = (int) filesize($file);
        if ($current === $size) {
            return;
        }
        if ($current < $size) {
            throw new EgeserBackupException('Yedek çalışma dosyaları tutarsız. İşlemi iptal edip yeniden başlatın.');
        }
        $handle = @fopen($file, 'r+b');
        if ($handle === false || !ftruncate($handle, $size)) {
            throw new EgeserBackupException('Yedek çalışma dosyası düzeltilemedi.');
        }
        fclose($handle);
    }
}
