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
 * Non-blocking exclusive lock (flock) that serialises every request touching
 * the active job. Two browser tabs or a double click can therefore never
 * process the same batch twice. The OS releases the lock automatically when a
 * PHP worker dies (timeout, crash), so a stale lock can not block the module.
 */
class EgeserBackupLock
{
    /** @var string */
    private $file;

    /** @var resource|null */
    private $handle;

    /**
     * @param string $file
     */
    public function __construct($file)
    {
        $this->file = $file;
    }

    /**
     * @return bool true when the lock was acquired, false when another request holds it
     *
     * @throws EgeserBackupException
     */
    public function acquire()
    {
        if ($this->handle !== null) {
            return true;
        }
        $handle = @fopen($this->file, 'c');
        if ($handle === false) {
            throw new EgeserBackupException('Kilit dosyası oluşturulamadı. Yedek dizinine yazma izni kontrol edin.');
        }
        if (!flock($handle, LOCK_EX | LOCK_NB)) {
            fclose($handle);

            return false;
        }
        $this->handle = $handle;

        return true;
    }

    public function release()
    {
        if ($this->handle !== null) {
            flock($this->handle, LOCK_UN);
            fclose($this->handle);
            $this->handle = null;
        }
    }

    public function __destruct()
    {
        $this->release();
    }
}
