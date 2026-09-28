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
 * Decides which root-relative paths are left out of the backup.
 *
 * The scan walks the whole PrestaShop root recursively; there is no hard coded
 * list of directories to include. Only the rules below exclude something.
 */
class EgeserBackupExclusions
{
    public const REASON_STORAGE = 'storage';
    public const REASON_CACHE = 'cache';
    public const REASON_LOG = 'log';
    public const REASON_USER = 'user';

    /** @var array<string, string> relative directory => reason */
    private $dirRules = array();

    /** @var array<string, bool> */
    private $userPaths = array();

    /** @var bool */
    private $excludeLogFiles;

    /**
     * @param array $settings job settings snapshot
     */
    public function __construct(array $settings)
    {
        if (empty($settings['include_cache'])) {
            foreach (self::cacheDirectories() as $dir) {
                $this->dirRules[$dir] = self::REASON_CACHE;
            }
        }
        $this->excludeLogFiles = empty($settings['include_logs']);
        if ($this->excludeLogFiles) {
            foreach (self::logDirectories() as $dir) {
                $this->dirRules[$dir] = self::REASON_LOG;
            }
        }
        if (!empty($settings['extra_excludes']) && is_array($settings['extra_excludes'])) {
            foreach ($settings['extra_excludes'] as $path) {
                $this->userPaths[(string) $path] = true;
            }
        }
    }

    /**
     * Regenerable cache / temporary / session directories (root relative).
     *
     * @return string[]
     */
    public static function cacheDirectories()
    {
        return array(
            'var/cache',
            'var/sessions',
            'cache/smarty/cache',
            'cache/smarty/compile',
            'cache/cachefs',
            'cache/purifier',
            'img/tmp',
        );
    }

    /**
     * @return string[]
     */
    public static function logDirectories()
    {
        return array(
            'var/logs',
            'log',
        );
    }

    /**
     * @param string $relative
     *
     * @return bool
     */
    public static function isStoragePath($relative)
    {
        $base = EgeserBackupStorage::BASE_REL;

        return $relative === $base || strpos($relative, $base . '/') === 0;
    }

    /**
     * @param string $relative directory path relative to the root
     *
     * @return string|null reason when excluded
     */
    public function matchDirectory($relative)
    {
        // The storage rule is checked first and can not be disabled by any option:
        // the backup must never contain itself.
        if (self::isStoragePath($relative)) {
            return self::REASON_STORAGE;
        }
        if (isset($this->userPaths[$relative])) {
            return self::REASON_USER;
        }
        if (isset($this->dirRules[$relative])) {
            return $this->dirRules[$relative];
        }

        return null;
    }

    /**
     * @param string $relative file path relative to the root
     * @param string $name base name
     *
     * @return string|null reason when excluded
     */
    public function matchFile($relative, $name)
    {
        if (self::isStoragePath($relative)) {
            return self::REASON_STORAGE;
        }
        if (isset($this->userPaths[$relative])) {
            return self::REASON_USER;
        }
        if ($this->excludeLogFiles && self::isLogFileName($name)) {
            return self::REASON_LOG;
        }

        return null;
    }

    /**
     * Excluded cache/log directories are still stored as empty directories so
     * the restored tree keeps its structure (PrestaShop expects them to exist).
     *
     * @param string $reason
     *
     * @return bool
     */
    public static function keepsEmptyDirectory($reason)
    {
        return $reason === self::REASON_CACHE || $reason === self::REASON_LOG;
    }

    /**
     * @param string $name
     *
     * @return bool
     */
    public static function isLogFileName($name)
    {
        return $name === 'error_log' || (bool) preg_match('/\.log(\.\d+)?(\.gz)?$/i', $name);
    }
}
