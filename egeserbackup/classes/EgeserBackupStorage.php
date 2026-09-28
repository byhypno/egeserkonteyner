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
 * Owns every path the module writes to and the low level file helpers.
 *
 * Layout (relative to the PrestaShop root):
 *
 *   var/egeserbackup/                     .htaccess + index.php + web.config (deny all)
 *   var/egeserbackup/vault_<32 hex>/      random, unguessable directory name
 *       backups/                          finished ZIP parts, <id>.json meta, <id>.report.txt
 *       work/                             job.json, .lock, cancel.flag, <job id>/ (manifest, parts in progress)
 *       logs/egeserbackup.log             module log
 *
 * The whole "var/egeserbackup" tree is always excluded from the scan, so a
 * backup can never contain another backup, a manifest or the module log.
 * Downloads never touch these paths directly: they are streamed by the admin
 * controller after authentication, so web server rules (.htaccess) are only a
 * second line of defence.
 */
class EgeserBackupStorage
{
    public const BASE_REL = 'var/egeserbackup';
    public const VAULT_PATTERN = '/^vault_[a-f0-9]{32}$/';

    /** @var string */
    private $root;

    /** @var string */
    private $base;

    /** @var string|null */
    private $vault;

    /**
     * @param string $rootDir PrestaShop root directory (_PS_ROOT_DIR_)
     *
     * @throws EgeserBackupException
     */
    public function __construct($rootDir)
    {
        $real = realpath($rootDir);
        if ($real === false || !is_dir($real)) {
            throw new EgeserBackupException('Site kök dizini bulunamadı.');
        }
        $this->root = self::normalize($real);
        $this->base = $this->root . '/' . self::BASE_REL;
    }

    /**
     * @param string $path
     *
     * @return string
     */
    public static function normalize($path)
    {
        $path = str_replace('\\', '/', (string) $path);
        if ($path === '/') {
            return $path;
        }

        return rtrim($path, '/');
    }

    /**
     * @return string
     */
    public function getRoot()
    {
        return $this->root;
    }

    /**
     * @return string
     */
    public function getBase()
    {
        return $this->base;
    }

    /**
     * Creates (if needed) and protects the storage tree.
     *
     * @throws EgeserBackupException
     */
    public function prepare()
    {
        if ($this->vault !== null) {
            return;
        }
        $this->ensureDir($this->base);
        $this->protect($this->base);

        $vault = $this->findVault();
        if ($vault === null) {
            $vault = $this->base . '/vault_' . bin2hex(random_bytes(16));
            $this->ensureDir($vault);
        }
        $this->protect($vault);
        foreach (array('backups', 'work', 'logs') as $sub) {
            $this->ensureDir($vault . '/' . $sub);
            $this->protect($vault . '/' . $sub);
        }
        $this->vault = $vault;
    }

    /**
     * @return string
     */
    public function getVault()
    {
        $this->prepare();

        return $this->vault;
    }

    /**
     * @return string
     */
    public function backupsDir()
    {
        return $this->getVault() . '/backups';
    }

    /**
     * @return string
     */
    public function workDir()
    {
        return $this->getVault() . '/work';
    }

    /**
     * @return string
     */
    public function logFile()
    {
        return $this->getVault() . '/logs/egeserbackup.log';
    }

    /**
     * @return string
     */
    public function jobFile()
    {
        return $this->workDir() . '/job.json';
    }

    /**
     * @return string
     */
    public function lockFile()
    {
        return $this->workDir() . '/.lock';
    }

    /**
     * @return string
     */
    public function cancelFlagFile()
    {
        return $this->workDir() . '/cancel.flag';
    }

    /**
     * Converts an absolute path below the root into a root relative path
     * (used for every message shown to the user).
     *
     * @param string $absolute
     *
     * @return string
     */
    public function relative($absolute)
    {
        $absolute = self::normalize($absolute);
        if (strpos($absolute, $this->root . '/') === 0) {
            return substr($absolute, strlen($this->root) + 1);
        }

        return basename($absolute);
    }

    /**
     * True when $path resolves (realpath) to a location strictly inside $dir.
     *
     * @param string $path
     * @param string $dir
     *
     * @return bool
     */
    public static function isInside($path, $dir)
    {
        $realPath = realpath($path);
        $realDir = realpath($dir);
        if ($realPath === false || $realDir === false) {
            return false;
        }
        $realPath = self::normalize($realPath);
        $realDir = self::normalize($realDir);

        return $realPath !== $realDir && strpos($realPath, $realDir . '/') === 0;
    }

    /**
     * Recursively deletes a directory. Refuses to touch anything outside the vault
     * and never follows symbolic links.
     *
     * @param string $dir
     *
     * @return bool
     */
    public function deleteTree($dir)
    {
        if (!is_dir($dir) || is_link($dir) || !self::isInside($dir, $this->getVault())) {
            return false;
        }
        $entries = scandir($dir);
        if ($entries === false) {
            return false;
        }
        foreach ($entries as $entry) {
            if ($entry === '.' || $entry === '..') {
                continue;
            }
            $path = $dir . '/' . $entry;
            if (is_link($path) || !is_dir($path)) {
                @unlink($path);
            } else {
                $this->deleteTree($path);
            }
        }

        return @rmdir($dir);
    }

    /**
     * @param string $file
     *
     * @return array|null
     */
    public function readJson($file)
    {
        if (!is_file($file)) {
            return null;
        }
        $content = @file_get_contents($file);
        if ($content === false || $content === '') {
            return null;
        }
        $data = json_decode($content, true);

        return is_array($data) ? $data : null;
    }

    /**
     * Atomic JSON write (temp file + rename) so a killed request never leaves
     * a half written state file behind.
     *
     * @param string $file
     * @param array $data
     *
     * @throws EgeserBackupException
     */
    public function writeJson($file, array $data)
    {
        $json = json_encode($data, self::jsonFlags());
        if ($json === false) {
            throw new EgeserBackupException('Durum bilgisi kaydedilemedi (JSON hatası).');
        }
        $tmp = $file . '.tmp' . bin2hex(random_bytes(4));
        if (@file_put_contents($tmp, $json, LOCK_EX) !== strlen($json)) {
            @unlink($tmp);
            throw new EgeserBackupException('Durum dosyası yazılamadı. Disk dolu veya yazma izni yok olabilir.');
        }
        if (!@rename($tmp, $file)) {
            @unlink($tmp);
            throw new EgeserBackupException('Durum dosyası güncellenemedi.');
        }
    }

    /**
     * @return int
     */
    public static function jsonFlags()
    {
        // JSON_INVALID_UTF8_SUBSTITUTE (PHP >= 7.2): file names that are not valid
        // UTF-8 must not make the whole state file unwritable.
        $substitute = defined('JSON_INVALID_UTF8_SUBSTITUTE') ? constant('JSON_INVALID_UTF8_SUBSTITUTE') : 0;

        return JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE | $substitute;
    }

    /**
     * Free disk space of the storage volume, or null when it cannot be determined
     * (function disabled by the host, open_basedir, ...).
     *
     * @return float|null
     */
    public function freeSpace()
    {
        if (!self::functionAvailable('disk_free_space')) {
            return null;
        }
        $free = @disk_free_space($this->workDir());

        return $free === false ? null : (float) $free;
    }

    /**
     * @param string $name
     *
     * @return bool
     */
    public static function functionAvailable($name)
    {
        if (!function_exists($name)) {
            return false;
        }
        $disabled = (string) ini_get('disable_functions');
        if ($disabled === '') {
            return true;
        }
        $list = array_map('trim', explode(',', strtolower($disabled)));

        return !in_array(strtolower($name), $list, true);
    }

    /**
     * @param float|int $bytes
     *
     * @return string
     */
    public static function formatBytes($bytes)
    {
        $bytes = (float) $bytes;
        $units = array('B', 'KB', 'MB', 'GB', 'TB');
        $i = 0;
        while ($bytes >= 1024 && $i < count($units) - 1) {
            $bytes /= 1024;
            ++$i;
        }

        return number_format($bytes, $i === 0 ? 0 : 2, ',', '.') . ' ' . $units[$i];
    }

    /**
     * @return string|null
     */
    private function findVault()
    {
        $entries = @scandir($this->base);
        if ($entries === false) {
            return null;
        }
        sort($entries, SORT_STRING);
        foreach ($entries as $entry) {
            $path = $this->base . '/' . $entry;
            if (preg_match(self::VAULT_PATTERN, $entry) && is_dir($path) && !is_link($path)) {
                return $path;
            }
        }

        return null;
    }

    /**
     * @param string $dir
     *
     * @throws EgeserBackupException
     */
    private function ensureDir($dir)
    {
        if (is_link($dir)) {
            throw new EgeserBackupException('Yedek dizini sembolik bağlantı olamaz: ' . $this->relative($dir));
        }
        if (!is_dir($dir) && !@mkdir($dir, 0755, true) && !is_dir($dir)) {
            throw new EgeserBackupException('Yedek dizini oluşturulamadı: ' . $this->relative($dir) . ' (var/ klasörüne yazma izni gerekli).');
        }
        if (!is_writable($dir)) {
            throw new EgeserBackupException('Yedek dizini yazılabilir değil: ' . $this->relative($dir));
        }
    }

    /**
     * Drops "deny all" files for Apache 2.2/2.4, LiteSpeed, IIS and a PHP index.
     *
     * @param string $dir
     */
    private function protect($dir)
    {
        $files = array(
            '.htaccess' => "# Egeser Full Backup - web access to this directory is forbidden.\n"
                . "<IfModule mod_authz_core.c>\n    Require all denied\n</IfModule>\n"
                . "<IfModule !mod_authz_core.c>\n    Order deny,allow\n    Deny from all\n</IfModule>\n"
                . "<IfModule mod_autoindex.c>\n    Options -Indexes\n</IfModule>\n",
            'web.config' => "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<configuration>\n  <system.webServer>\n"
                . "    <authorization>\n      <deny users=\"*\" />\n    </authorization>\n"
                . "  </system.webServer>\n</configuration>\n",
            'index.php' => "<?php\nheader('HTTP/1.1 403 Forbidden');\nexit;\n",
        );
        foreach ($files as $name => $content) {
            $path = $dir . '/' . $name;
            if (!is_file($path) || @file_get_contents($path) !== $content) {
                @file_put_contents($path, $content, LOCK_EX);
            }
        }
    }
}
