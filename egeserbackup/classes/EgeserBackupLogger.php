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
 * Minimal file logger. The log lives inside the protected storage vault
 * (var/egeserbackup/vault_xxx/logs/egeserbackup.log), which is always
 * excluded from backups, and is readable from the module page.
 */
class EgeserBackupLogger
{
    public const MAX_SIZE = 5242880;

    /** @var string */
    private $file;

    /**
     * @param string $file
     */
    public function __construct($file)
    {
        $this->file = $file;
    }

    /**
     * @param string $message
     */
    public function info($message)
    {
        $this->write('INFO', $message);
    }

    /**
     * @param string $message
     */
    public function warning($message)
    {
        $this->write('WARNING', $message);
    }

    /**
     * @param string $message
     */
    public function error($message)
    {
        $this->write('ERROR', $message);
    }

    /**
     * Returns the last $lines lines of the log (reads at most 256 KB).
     *
     * @param int $lines
     *
     * @return string[]
     */
    public function tail($lines = 100)
    {
        if (!is_file($this->file)) {
            return array();
        }
        $handle = @fopen($this->file, 'rb');
        if ($handle === false) {
            return array();
        }
        $size = (int) filesize($this->file);
        $read = min($size, 262144);
        fseek($handle, $size - $read);
        $chunk = $read > 0 ? (string) fread($handle, $read) : '';
        fclose($handle);
        $all = preg_split('/\r?\n/', trim($chunk));
        if ($read < $size) {
            array_shift($all);
        }

        return array_slice(array_filter($all, 'strlen'), -$lines);
    }

    /**
     * @param string $level
     * @param string $message
     */
    private function write($level, $message)
    {
        if (is_file($this->file) && (int) @filesize($this->file) > self::MAX_SIZE) {
            @rename($this->file, $this->file . '.1');
        }
        $message = preg_replace('/[\x00-\x1F\x7F]+/', ' ', (string) $message);
        @file_put_contents(
            $this->file,
            date('Y-m-d H:i:s') . ' [' . $level . '] ' . $message . PHP_EOL,
            FILE_APPEND | LOCK_EX
        );
    }
}
