<?php
/**
 * Egeser Full Backup
 *
 * File system backup module for PrestaShop 1.7.8.x (PHP 7.1 - 7.4 compatible).
 * Creates a ZIP of every file under the PrestaShop root from the back office,
 * in small AJAX batches, without touching any core file.
 *
 * @author    Egeser
 * @copyright Egeser
 * @license   Proprietary
 */
if (!defined('_PS_VERSION_')) {
    exit;
}

require_once __DIR__ . '/classes/EgeserBackupException.php';
require_once __DIR__ . '/classes/EgeserBackupStorage.php';
require_once __DIR__ . '/classes/EgeserBackupLogger.php';
require_once __DIR__ . '/classes/EgeserBackupLock.php';
require_once __DIR__ . '/classes/EgeserBackupSettings.php';
require_once __DIR__ . '/classes/EgeserBackupExclusions.php';
require_once __DIR__ . '/classes/EgeserBackupJob.php';
require_once __DIR__ . '/classes/EgeserBackupPhaseInterface.php';
require_once __DIR__ . '/classes/EgeserBackupScanner.php';
require_once __DIR__ . '/classes/EgeserBackupArchiver.php';
require_once __DIR__ . '/classes/EgeserBackupRepository.php';
require_once __DIR__ . '/classes/EgeserBackupVerifier.php';
require_once __DIR__ . '/classes/EgeserBackupManager.php';

class EgeserBackup extends Module
{
    public const ADMIN_CONTROLLER = 'AdminEgeserBackup';
    public const PARENT_TAB = 'AdminAdvancedParameters';

    public function __construct()
    {
        $this->name = 'egeserbackup';
        $this->tab = 'administration';
        $this->version = '1.0.0';
        $this->author = 'Egeser';
        $this->need_instance = 0;
        $this->bootstrap = true;
        $this->ps_versions_compliancy = array('min' => '1.7.0.0', 'max' => _PS_VERSION_);

        parent::__construct();

        $this->displayName = $this->l('Egeser Full Backup');
        $this->description = $this->l('Site dosyalarının tamamını Back Office üzerinden, AJAX batch sistemiyle güvenli biçimde ZIP olarak yedekler (dosya sistemi yedeği).');
        $this->confirmUninstall = $this->l('Modül kaldırılsın mı? Oluşturulmuş yedek dosyaları silinmez (var/egeserbackup/ altında kalır).');
    }

    /**
     * @return bool
     */
    public function install()
    {
        return parent::install()
            && EgeserBackupSettings::installDefaults()
            && $this->installTab();
    }

    /**
     * Removes the admin menu entry and the configuration values.
     *
     * IMPORTANT: backup files are intentionally NOT deleted here. A backup is
     * often taken right before risky operations (theme/module changes, server
     * moves) and uninstalling/reinstalling the module must never destroy the
     * user's only copy. They stay in var/egeserbackup/ and are listed again
     * after a reinstall; delete them from the module page when no longer needed.
     *
     * @return bool
     */
    public function uninstall()
    {
        return $this->uninstallTab()
            && EgeserBackupSettings::uninstall()
            && parent::uninstall();
    }

    /**
     * "Configure" in the module manager opens the admin controller.
     */
    public function getContent()
    {
        Tools::redirectAdmin($this->context->link->getAdminLink(self::ADMIN_CONTROLLER));
    }

    /**
     * @return bool
     */
    private function installTab()
    {
        if ((int) Tab::getIdFromClassName(self::ADMIN_CONTROLLER) > 0) {
            return true;
        }
        $tab = new Tab();
        $tab->active = 1;
        $tab->class_name = self::ADMIN_CONTROLLER;
        $tab->module = $this->name;
        $tab->id_parent = (int) Tab::getIdFromClassName(self::PARENT_TAB);
        $tab->name = array();
        foreach (Language::getLanguages(false) as $language) {
            $tab->name[(int) $language['id_lang']] = 'Egeser Full Backup';
        }

        return (bool) $tab->add();
    }

    /**
     * @return bool
     */
    private function uninstallTab()
    {
        $idTab = (int) Tab::getIdFromClassName(self::ADMIN_CONTROLLER);
        if ($idTab <= 0) {
            return true;
        }
        $tab = new Tab($idTab);

        return (bool) $tab->delete();
    }
}
