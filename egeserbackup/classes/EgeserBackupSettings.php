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
 * Module configuration (stored in ps_configuration) and its validation.
 *
 * A snapshot of these values is copied into every job when it starts, so
 * changing a setting while a backup is running never affects that backup.
 */
class EgeserBackupSettings
{
    public const KEY_BATCH_SIZE = 'EGESERBACKUP_BATCH_SIZE';
    public const KEY_PART_SIZE = 'EGESERBACKUP_PART_SIZE_MB';
    public const KEY_INCLUDE_CACHE = 'EGESERBACKUP_INCLUDE_CACHE';
    public const KEY_INCLUDE_LOGS = 'EGESERBACKUP_INCLUDE_LOGS';
    public const KEY_EXTRA_EXCLUDES = 'EGESERBACKUP_EXTRA_EXCLUDES';
    public const KEY_SUPERADMIN_ONLY = 'EGESERBACKUP_SUPERADMIN_ONLY';
    public const KEY_RETENTION_DAYS = 'EGESERBACKUP_RETENTION_DAYS';

    public const MIN_BATCH = 10;
    public const MAX_BATCH = 2000;
    public const MIN_PART = 100;
    public const MAX_PART = 4096;
    public const MIN_RETENTION = 1;
    public const MAX_RETENTION = 365;
    public const MAX_EXCLUDES = 50;

    /**
     * @return array
     */
    public static function defaults()
    {
        return array(
            self::KEY_BATCH_SIZE => 250,
            self::KEY_PART_SIZE => 1024,
            self::KEY_INCLUDE_CACHE => 0,
            self::KEY_INCLUDE_LOGS => 0,
            self::KEY_EXTRA_EXCLUDES => '',
            self::KEY_SUPERADMIN_ONLY => 1,
            self::KEY_RETENTION_DAYS => 7,
        );
    }

    /**
     * @return bool
     */
    public static function installDefaults()
    {
        $ok = true;
        foreach (self::defaults() as $key => $value) {
            if (Configuration::get($key) === false) {
                $ok = Configuration::updateValue($key, $value) && $ok;
            }
        }

        return $ok;
    }

    /**
     * @return bool
     */
    public static function uninstall()
    {
        foreach (array_keys(self::defaults()) as $key) {
            Configuration::deleteByName($key);
        }

        return true;
    }

    /**
     * Current settings as a typed array.
     *
     * @return array
     */
    public static function load()
    {
        $defaults = self::defaults();
        $raw = array();
        foreach ($defaults as $key => $default) {
            $value = Configuration::get($key);
            $raw[$key] = $value === false ? $default : $value;
        }
        $errors = array();
        $excludes = self::parseExcludes((string) $raw[self::KEY_EXTRA_EXCLUDES], $errors);

        return array(
            'batch_size' => self::clampInt($raw[self::KEY_BATCH_SIZE], self::MIN_BATCH, self::MAX_BATCH, 250),
            'part_size_mb' => self::normalizePartSize($raw[self::KEY_PART_SIZE]),
            'include_cache' => (bool) $raw[self::KEY_INCLUDE_CACHE],
            'include_logs' => (bool) $raw[self::KEY_INCLUDE_LOGS],
            'extra_excludes' => $excludes,
            'superadmin_only' => (bool) $raw[self::KEY_SUPERADMIN_ONLY],
            'retention_days' => self::clampInt(
                $raw[self::KEY_RETENTION_DAYS],
                self::MIN_RETENTION,
                self::MAX_RETENTION,
                7
            ),
        );
    }

    /**
     * Validates submitted form values. Returns the normalized configuration
     * values (keyed by configuration key) or fills $errors.
     *
     * @param array $input raw values keyed by configuration key
     * @param bool $canChangeSuperAdminOnly
     * @param string[] $errors
     *
     * @return array
     */
    public static function validate(array $input, $canChangeSuperAdminOnly, array &$errors)
    {
        $current = self::load();
        $values = array();

        $batch = isset($input[self::KEY_BATCH_SIZE]) ? trim((string) $input[self::KEY_BATCH_SIZE]) : '';
        if (!ctype_digit($batch) || (int) $batch < self::MIN_BATCH || (int) $batch > self::MAX_BATCH) {
            $errors[] = sprintf('Batch boyutu %d ile %d arasında bir tam sayı olmalıdır.', self::MIN_BATCH, self::MAX_BATCH);
        } else {
            $values[self::KEY_BATCH_SIZE] = (int) $batch;
        }

        $part = isset($input[self::KEY_PART_SIZE]) ? trim((string) $input[self::KEY_PART_SIZE]) : '';
        if (!ctype_digit($part) || ((int) $part !== 0 && ((int) $part < self::MIN_PART || (int) $part > self::MAX_PART))) {
            $errors[] = sprintf(
                'ZIP parça boyutu 0 (bölme yok) veya %d ile %d MB arasında olmalıdır.',
                self::MIN_PART,
                self::MAX_PART
            );
        } else {
            $values[self::KEY_PART_SIZE] = (int) $part;
        }

        $retention = isset($input[self::KEY_RETENTION_DAYS]) ? trim((string) $input[self::KEY_RETENTION_DAYS]) : '';
        if (!ctype_digit($retention) || (int) $retention < self::MIN_RETENTION || (int) $retention > self::MAX_RETENTION) {
            $errors[] = sprintf('Temizlik gün sayısı %d ile %d arasında olmalıdır.', self::MIN_RETENTION, self::MAX_RETENTION);
        } else {
            $values[self::KEY_RETENTION_DAYS] = (int) $retention;
        }

        $values[self::KEY_INCLUDE_CACHE] = !empty($input[self::KEY_INCLUDE_CACHE]) ? 1 : 0;
        $values[self::KEY_INCLUDE_LOGS] = !empty($input[self::KEY_INCLUDE_LOGS]) ? 1 : 0;

        $text = isset($input[self::KEY_EXTRA_EXCLUDES]) ? (string) $input[self::KEY_EXTRA_EXCLUDES] : '';
        $excludeErrors = array();
        $excludes = self::parseExcludes($text, $excludeErrors);
        if ($excludeErrors) {
            $errors = array_merge($errors, $excludeErrors);
        } else {
            $values[self::KEY_EXTRA_EXCLUDES] = implode("\n", $excludes);
        }

        if ($canChangeSuperAdminOnly) {
            $values[self::KEY_SUPERADMIN_ONLY] = !empty($input[self::KEY_SUPERADMIN_ONLY]) ? 1 : 0;
        } else {
            $values[self::KEY_SUPERADMIN_ONLY] = $current['superadmin_only'] ? 1 : 0;
        }

        return $values;
    }

    /**
     * @param array $values
     *
     * @return bool
     */
    public static function save(array $values)
    {
        $ok = true;
        foreach ($values as $key => $value) {
            if (array_key_exists($key, self::defaults())) {
                $ok = Configuration::updateValue($key, $value) && $ok;
            }
        }

        return $ok;
    }

    /**
     * Parses the "extra excluded paths" textarea. Only plain root-relative paths
     * are accepted: no "..", no absolute paths, no wildcards, no control chars.
     *
     * @param string $text
     * @param string[] $errors
     *
     * @return string[]
     */
    public static function parseExcludes($text, array &$errors)
    {
        $result = array();
        $lines = preg_split('/\r\n|\r|\n/', (string) $text);
        foreach ($lines as $line) {
            $line = trim(str_replace('\\', '/', $line));
            if ($line === '') {
                continue;
            }
            $line = trim($line, '/');
            $valid = $line !== ''
                && strlen($line) <= 255
                && preg_match('#^[A-Za-z0-9._\- /]+$#', $line)
                && !preg_match('#(^|/)\.\.?(/|$)#', $line)
                && strpos($line, '//') === false;
            if (!$valid) {
                $errors[] = 'Geçersiz hariç tutma yolu: "' . $line . '". Yalnızca kök dizine göre göreli yollar '
                    . '(ör. img/tmp veya modules/ornekmodul/cache) kullanılabilir; "..", "*" ve özel karakterler yasaktır.';
                continue;
            }
            $result[$line] = $line;
        }
        if (count($result) > self::MAX_EXCLUDES) {
            $errors[] = sprintf('En fazla %d hariç tutma yolu girilebilir.', self::MAX_EXCLUDES);
        }

        return array_values($result);
    }

    /**
     * @param mixed $value
     *
     * @return int
     */
    private static function normalizePartSize($value)
    {
        $value = (int) $value;
        if ($value === 0) {
            return 0;
        }

        return max(self::MIN_PART, min(self::MAX_PART, $value));
    }

    /**
     * @param mixed $value
     * @param int $min
     * @param int $max
     * @param int $default
     *
     * @return int
     */
    private static function clampInt($value, $min, $max, $default)
    {
        if (!is_numeric($value)) {
            return $default;
        }

        return max($min, min($max, (int) $value));
    }
}
