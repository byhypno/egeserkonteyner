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

require_once _PS_MODULE_DIR_ . 'egeserbackup/egeserbackup.php';

/**
 * Back office page + JSON API of the module.
 *
 * Every API call goes through ajaxProcessBackupApi() which enforces, in order:
 *  1. operation whitelist,
 *  2. admin token of this controller (checked here too, even if the shop has
 *     "token in URLs" disabled),
 *  3. employee permission on this tab (+ optional "SuperAdmin only"),
 *  4. for state changing operations: POST + custom X-Egeser-Backup header
 *     (cannot be sent cross-site without CORS -> CSRF protection).
 */
class AdminEgeserBackupController extends ModuleAdminController
{
    public const API_ACTION = 'backupApi';
    public const DOWNLOAD_CHUNK = 1048576;

    /** @var string[] */
    private static $operations = array(
        'status',
        'scan',
        'startBackup',
        'processBatch',
        'cancel',
        'deleteBackup',
        'cleanup',
        'download',
    );

    /** @var EgeserBackupStorage|null */
    private $storage;

    /** @var EgeserBackupLogger|null */
    private $logger;

    /** @var EgeserBackupManager|null */
    private $manager;

    /** @var string */
    private $storageError = '';

    public function __construct()
    {
        $this->bootstrap = true;
        parent::__construct();
    }

    public function setMedia($isNewTheme = false)
    {
        parent::setMedia($isNewTheme);
        $this->addCSS($this->module->getPathUri() . 'views/css/admin.css?v=' . $this->module->version);
        $this->addJS($this->module->getPathUri() . 'views/js/admin.js?v=' . $this->module->version);
    }

    public function postProcess()
    {
        if (!$this->ajax && Tools::isSubmit('submitEgeserBackupSettings')) {
            $this->processSaveSettings();

            return true;
        }

        return parent::postProcess();
    }

    public function initContent()
    {
        if (!$this->canUse()) {
            $this->errors[] = $this->t('Bu sayfaya erişim yetkiniz yok. Modül ayarlarında "Yalnızca SuperAdmin" seçeneği açık olabilir.');
            parent::initContent();

            return;
        }

        $this->bootManager();
        $settings = EgeserBackupSettings::load();
        $job = null;
        $backups = array();
        $logLines = array();
        if ($this->manager !== null) {
            try {
                $job = $this->manager->getJob();
                foreach ($this->manager->getRepository()->all() as $meta) {
                    $backups[] = $this->decorateBackup($meta);
                }
                $logLines = $this->logger->tail(100);
            } catch (Throwable $e) {
                $this->errors[] = $this->publicMessage($e);
            }
        }

        $checks = $this->environmentChecks();
        $ready = true;
        foreach ($checks as $check) {
            if ($check['blocking'] && $check['status'] === 'error') {
                $ready = false;
            }
        }

        $config = array(
            'apiUrl' => $this->apiUrl(),
            'ready' => $ready,
            'job' => $job !== null ? $this->manager->summary($job) : null,
            'retentionDays' => $settings['retention_days'],
            'texts' => $this->jsTexts(),
        );

        $this->context->smarty->assign(array(
            'egb_checks' => $checks,
            'egb_ready' => $ready,
            'egb_settings_form' => $this->renderSettingsForm($settings, $job !== null),
            'egb_backups' => $backups,
            'egb_log_lines' => $logLines,
            'egb_log_path' => $this->storage !== null ? $this->storage->relative($this->storage->logFile()) : '-',
            'egb_storage_path' => $this->storage !== null ? $this->storage->relative($this->storage->backupsDir()) : '-',
            'egb_retention_days' => $settings['retention_days'],
            'egb_config_json' => json_encode($config, EgeserBackupStorage::jsonFlags() | JSON_HEX_TAG | JSON_HEX_AMP),
        ));
        $this->content .= $this->context->smarty->fetch(
            $this->module->getLocalPath() . 'views/templates/admin/page.tpl'
        );

        parent::initContent();
    }

    /**
     * Single AJAX entry point: index.php?controller=AdminEgeserBackup&token=<token>&ajax=1&action=backupApi&op=<operation>
     */
    public function ajaxProcessBackupApi()
    {
        $op = $this->stringParam('op');
        if (!in_array($op, self::$operations, true)) {
            $this->jsonResponse(false, $this->t('Geçersiz işlem.'), array(), 400);
        }
        if (!$this->isValidToken()) {
            $this->jsonResponse(false, $this->t('Güvenlik anahtarı (token) geçersiz. Sayfayı yenileyip tekrar deneyin.'), array(), 403);
        }
        if (!$this->canUse()) {
            $this->jsonResponse(false, $this->t('Bu işlem için yetkiniz yok.'), array(), 403);
        }
        if ($op === 'download') {
            $this->processDownload();
        }
        if (!$this->isApiPost()) {
            $this->jsonResponse(false, $this->t('Geçersiz istek.'), array(), 400);
        }

        $this->bootManager();
        if ($this->manager === null) {
            $this->jsonResponse(false, $this->storageError);
        }

        try {
            switch ($op) {
                case 'status':
                    $job = $this->manager->getJob();
                    $this->jsonResponse(true, '', array('job' => $job !== null ? $this->manager->summary($job) : null));
                    break;
                case 'scan':
                case 'startBackup':
                    $this->processStart($op === 'startBackup');
                    break;
                case 'processBatch':
                    $this->processStep();
                    break;
                case 'cancel':
                    $result = $this->manager->cancel();
                    $message = $result['cancelled']
                        ? $this->t('İşlem iptal edildi. Yarım kalan ZIP, manifest ve iş durumu silindi.')
                        : $this->t('İptal isteği alındı; çalışan adım biter bitmez işlem iptal edilecek.');
                    $this->jsonResponse(true, $message, $result);
                    break;
                case 'deleteBackup':
                    $this->processDeleteBackup();
                    break;
                case 'cleanup':
                    $days = EgeserBackupSettings::load()['retention_days'];
                    $result = $this->manager->cleanup($days);
                    $this->jsonResponse(true, sprintf(
                        $this->t('%d günden eski %d yedek silindi.'),
                        $days,
                        count($result['deleted'])
                    ), $result);
                    break;
            }
        } catch (EgeserBackupException $e) {
            $this->logger->warning('API ' . $op . ': ' . $e->getMessage());
            $this->jsonResponse(false, $e->getMessage());
        } catch (Throwable $e) {
            $this->logger->error(sprintf(
                'API %s: %s: %s in %s:%d',
                $op,
                get_class($e),
                $e->getMessage(),
                $e->getFile(),
                $e->getLine()
            ));
            $this->jsonResponse(false, $this->t('Beklenmeyen bir hata oluştu. Ayrıntılar modül log dosyasına yazıldı.'));
        }
        $this->jsonResponse(false, $this->t('Geçersiz işlem.'));
    }

    /**
     * @param bool $withBackup scan and then create the ZIP
     */
    private function processStart($withBackup)
    {
        if (!class_exists('ZipArchive')) {
            $this->jsonResponse(false, $this->t('Sunucuda PHP ZipArchive extension aktif değil.'));
        }
        $job = $this->manager->getJob();
        if ($job === null) {
            $job = $this->manager->startScan(EgeserBackupSettings::load(), $this->shopSlug(), $withBackup);
            $this->logger->info(sprintf('Job %s started by employee #%d.', $job->getId(), (int) $this->context->employee->id));
            $this->jsonResponse(true, '', array('job' => $this->manager->summary($job)));
        }
        if ($job->getStatus() === EgeserBackupJob::STATUS_FAILED) {
            $this->jsonResponse(
                false,
                $this->t('Önceki yedekleme işlemi başarısız oldu. İşlemi iptal edip yeniden başlatın.'),
                array('job' => $this->manager->summary($job), 'active' => true)
            );
        }
        if (!$withBackup || $job->getStatus() === EgeserBackupJob::STATUS_SCAN) {
            $this->jsonResponse(
                false,
                $this->t('Devam eden bir backup işlemi var. "Devam Et" ile sürdürebilir veya iptal edebilirsiniz.'),
                array('job' => $this->manager->summary($job), 'active' => true)
            );
        }
        $result = $this->manager->startArchive($this->stringParam('confirm') === '1');
        $data = array('job' => $this->manager->summary($result['job']));
        if (!empty($result['need_confirm'])) {
            $data['need_confirm'] = true;
            $this->jsonResponse(true, $result['message'], $data);
        }
        $this->jsonResponse(true, '', $data);
    }

    private function processStep()
    {
        $result = $this->manager->step();
        $data = array(
            'busy' => $result['busy'],
            'cancelled' => $result['cancelled'],
            'job' => $result['job'] !== null ? $this->manager->summary($result['job']) : null,
            'completed' => $result['completed'] !== null ? $this->decorateBackup($result['completed']) : null,
        );
        $message = '';
        if ($result['cancelled']) {
            $message = $this->t('İşlem iptal edildi.');
        } elseif ($result['completed'] !== null) {
            $message = $this->t('Yedekleme tamamlandı ve doğrulandı.');
        }
        $this->jsonResponse(true, $message, $data);
    }

    private function processDeleteBackup()
    {
        $id = $this->stringParam('backup');
        if (!EgeserBackupJob::isValidId($id)) {
            $this->jsonResponse(false, $this->t('Geçersiz yedek kimliği.'));
        }
        if (!$this->manager->getRepository()->delete($id)) {
            $this->jsonResponse(false, $this->t('Yedek bulunamadı veya silinemedi.'));
        }
        $this->logger->info(sprintf('Backup %s deleted by employee #%d.', $id, (int) $this->context->employee->id));
        $this->jsonResponse(true, $this->t('Yedek silindi.'), array('id' => $id));
    }

    /**
     * Streams a backup part or report. Only an id + part number are accepted;
     * the file name comes from the server side meta file (see Repository).
     */
    private function processDownload()
    {
        $this->bootManager();
        $id = $this->stringParam('backup');
        $path = null;
        if ($this->manager !== null && EgeserBackupJob::isValidId($id)) {
            $repository = $this->manager->getRepository();
            if ($this->stringParam('report') === '1') {
                $path = $repository->reportPath($id);
            } else {
                $part = $this->stringParam('part');
                if ($part !== '' && strlen($part) <= 4 && ctype_digit($part)) {
                    $path = $repository->partPath($id, (int) $part);
                }
            }
        }
        if ($path === null) {
            $this->plainResponse(404, $this->t('Yedek dosyası bulunamadı.'));
        }

        $name = basename($path);
        $size = (int) filesize($path);
        $isZip = substr($name, -4) === '.zip';
        $this->logger->info(sprintf('Download of %s by employee #%d.', $name, (int) $this->context->employee->id));

        if (session_status() === PHP_SESSION_ACTIVE) {
            session_write_close();
        }
        EgeserBackupManager::prepareRuntime();
        @ini_set('zlib.output_compression', 'Off');
        while (ob_get_level() > 0) {
            @ob_end_clean();
        }

        $start = 0;
        $end = $size - 1;
        $status = 200;
        $range = isset($_SERVER['HTTP_RANGE']) ? (string) $_SERVER['HTTP_RANGE'] : '';
        if ($size > 0 && preg_match('/^bytes=(\d*)-(\d*)$/', trim($range), $m) && ($m[1] !== '' || $m[2] !== '')) {
            if ($m[1] === '') {
                $start = max(0, $size - (int) $m[2]);
            } else {
                $start = (int) $m[1];
                if ($m[2] !== '') {
                    $end = min($end, (int) $m[2]);
                }
            }
            if ($start > $end || $start >= $size) {
                header('HTTP/1.1 416 Requested Range Not Satisfiable');
                header('Content-Range: bytes */' . $size);
                exit;
            }
            $status = 206;
        }

        $handle = @fopen($path, 'rb');
        if ($handle === false) {
            $this->plainResponse(500, $this->t('Yedek dosyası açılamadı.'));
        }
        http_response_code($status);
        header('Content-Type: ' . ($isZip ? 'application/zip' : 'text/plain; charset=utf-8'));
        header('Content-Disposition: attachment; filename="' . $name . '"');
        header('Content-Length: ' . ($end - $start + 1));
        header('Accept-Ranges: bytes');
        if ($status === 206) {
            header('Content-Range: bytes ' . $start . '-' . $end . '/' . $size);
        }
        header('Cache-Control: private, no-store, no-cache, must-revalidate');
        header('Pragma: no-cache');
        header('X-Content-Type-Options: nosniff');
        header('X-LiteSpeed-Cache-Control: no-cache');
        header('Content-Encoding: identity');

        if ($start > 0) {
            fseek($handle, $start);
        }
        $remaining = $end - $start + 1;
        while ($remaining > 0 && !feof($handle)) {
            $chunk = fread($handle, (int) min(self::DOWNLOAD_CHUNK, $remaining));
            if ($chunk === false || $chunk === '') {
                break;
            }
            echo $chunk;
            $remaining -= strlen($chunk);
            flush();
            if (connection_aborted()) {
                break;
            }
        }
        fclose($handle);
        exit;
    }

    private function processSaveSettings()
    {
        if (!$this->isValidToken()) {
            $this->errors[] = $this->t('Güvenlik anahtarı (token) geçersiz. Sayfayı yenileyip tekrar deneyin.');

            return;
        }
        if (!$this->canUse()) {
            $this->errors[] = $this->t('Bu işlem için yetkiniz yok.');

            return;
        }
        $input = array();
        foreach (array_keys(EgeserBackupSettings::defaults()) as $key) {
            $input[$key] = $this->stringParam($key);
        }
        $errors = array();
        $values = EgeserBackupSettings::validate($input, $this->isSuperAdmin(), $errors);
        if ($errors) {
            foreach ($errors as $error) {
                $this->errors[] = $error;
            }

            return;
        }
        if (!EgeserBackupSettings::save($values)) {
            $this->errors[] = $this->t('Ayarlar kaydedilemedi.');

            return;
        }
        $this->redirect_after = self::$currentIndex . '&token=' . $this->token . '&conf=6';
    }

    /**
     * @param array $settings
     * @param bool $jobActive
     *
     * @return string
     */
    private function renderSettingsForm(array $settings, $jobActive)
    {
        $switchValues = array(
            array('id' => 'on', 'value' => 1, 'label' => $this->t('Evet')),
            array('id' => 'off', 'value' => 0, 'label' => $this->t('Hayır')),
        );
        $description = $this->t('Bu ayarlar bir sonraki yedeklemede kullanılır.');
        if ($jobActive) {
            $description .= ' ' . $this->t('Devam eden iş, başladığı andaki ayarlarla tamamlanır.');
        }
        $form = array(
            'form' => array(
                'legend' => array('title' => $this->t('Yedekleme Ayarları'), 'icon' => 'icon-cogs'),
                'description' => $description,
                'input' => array(
                    array(
                        'type' => 'switch',
                        'label' => $this->t('Cache klasörlerini dahil et'),
                        'name' => EgeserBackupSettings::KEY_INCLUDE_CACHE,
                        'is_bool' => true,
                        'values' => $switchValues,
                        'desc' => $this->t('Kapalıyken hariç tutulur (boş klasör olarak saklanır): ') . implode(', ', EgeserBackupExclusions::cacheDirectories()),
                    ),
                    array(
                        'type' => 'switch',
                        'label' => $this->t('Log dosyalarını dahil et'),
                        'name' => EgeserBackupSettings::KEY_INCLUDE_LOGS,
                        'is_bool' => true,
                        'values' => $switchValues,
                        'desc' => $this->t('Kapalıyken var/logs klasörü, *.log dosyaları ve error_log dosyaları hariç tutulur.'),
                    ),
                    array(
                        'type' => 'text',
                        'label' => $this->t('Batch boyutu (dosya / istek)'),
                        'name' => EgeserBackupSettings::KEY_BATCH_SIZE,
                        'class' => 'fixed-width-sm',
                        'desc' => sprintf(
                            $this->t('Her AJAX isteğinde ZIP\'e eklenecek en fazla dosya sayısı (%d-%d). Zaman aşımı yaşanırsa düşürün. Bir istekte en fazla 128 MB kaynak veri işlenir.'),
                            EgeserBackupSettings::MIN_BATCH,
                            EgeserBackupSettings::MAX_BATCH
                        ),
                    ),
                    array(
                        'type' => 'text',
                        'label' => $this->t('ZIP parça boyutu'),
                        'name' => EgeserBackupSettings::KEY_PART_SIZE,
                        'class' => 'fixed-width-sm',
                        'suffix' => 'MB',
                        'desc' => sprintf(
                            $this->t('Arşiv bu boyuta ulaşınca yeni bir ZIP parçasına geçilir (%d-%d MB). 0 = tek ZIP dosyası (büyük sitelerde yavaşlar, README\'ye bakın).'),
                            EgeserBackupSettings::MIN_PART,
                            EgeserBackupSettings::MAX_PART
                        ),
                    ),
                    array(
                        'type' => 'textarea',
                        'label' => $this->t('Ek hariç tutulacak yollar'),
                        'name' => EgeserBackupSettings::KEY_EXTRA_EXCLUDES,
                        'rows' => 4,
                        'desc' => $this->t('Her satıra bir yol, site köküne göre (ör. img/tmp veya modules/ornekmodul/cache). Joker karakter ve ".." kullanılamaz.'),
                    ),
                    array(
                        'type' => 'text',
                        'label' => $this->t('Temizlik: şu günden eski yedekler'),
                        'name' => EgeserBackupSettings::KEY_RETENTION_DAYS,
                        'class' => 'fixed-width-sm',
                        'suffix' => $this->t('gün'),
                        'desc' => $this->t('"Eski yedekleri temizle" butonu bu değeri kullanır. Otomatik silme yapılmaz.'),
                    ),
                    array(
                        'type' => 'switch',
                        'label' => $this->t('Yalnızca SuperAdmin kullanabilsin'),
                        'name' => EgeserBackupSettings::KEY_SUPERADMIN_ONLY,
                        'is_bool' => true,
                        'values' => $switchValues,
                        'disabled' => !$this->isSuperAdmin(),
                        'desc' => $this->t('Yedekler config/ dosyalarını (veritabanı şifresi dahil) içerir. Açık kalması önerilir. Yalnızca SuperAdmin değiştirebilir.'),
                    ),
                ),
                'submit' => array('title' => $this->t('Kaydet')),
            ),
        );

        $helper = new HelperForm();
        $helper->module = $this->module;
        $helper->show_toolbar = false;
        $helper->table = 'egeserbackup';
        $helper->identifier = 'id_egeserbackup';
        $helper->default_form_language = (int) Configuration::get('PS_LANG_DEFAULT');
        $helper->languages = $this->getLanguages();
        $helper->allow_employee_form_lang = (int) Configuration::get('PS_BO_ALLOW_EMPLOYEE_FORM_LANG');
        $helper->submit_action = 'submitEgeserBackupSettings';
        $helper->currentIndex = self::$currentIndex;
        $helper->token = $this->token;
        $helper->fields_value = array(
            EgeserBackupSettings::KEY_INCLUDE_CACHE => (int) $settings['include_cache'],
            EgeserBackupSettings::KEY_INCLUDE_LOGS => (int) $settings['include_logs'],
            EgeserBackupSettings::KEY_BATCH_SIZE => (int) $settings['batch_size'],
            EgeserBackupSettings::KEY_PART_SIZE => (int) $settings['part_size_mb'],
            EgeserBackupSettings::KEY_EXTRA_EXCLUDES => implode("\n", $settings['extra_excludes']),
            EgeserBackupSettings::KEY_RETENTION_DAYS => (int) $settings['retention_days'],
            EgeserBackupSettings::KEY_SUPERADMIN_ONLY => (int) $settings['superadmin_only'],
        );

        return $helper->generateForm(array($form));
    }

    /**
     * @return array
     */
    private function environmentChecks()
    {
        $checks = array();
        $checks[] = array(
            'label' => $this->t('PHP sürümü'),
            'value' => PHP_VERSION,
            'status' => version_compare(PHP_VERSION, '7.1.0', '>=') ? 'ok' : 'error',
            'blocking' => true,
        );
        $checks[] = array(
            'label' => $this->t('PHP ZipArchive extension'),
            'value' => class_exists('ZipArchive')
                ? $this->t('Aktif') . (defined('ZipArchive::LIBZIP_VERSION') ? ' (libzip ' . ZipArchive::LIBZIP_VERSION . ')' : '')
                : $this->t('Sunucuda PHP ZipArchive extension aktif değil.'),
            'status' => class_exists('ZipArchive') ? 'ok' : 'error',
            'blocking' => true,
        );
        $sha = function_exists('hash_algos') && in_array('sha256', hash_algos(), true);
        $checks[] = array(
            'label' => 'SHA-256 (hash)',
            'value' => $sha ? $this->t('Kullanılabilir') : $this->t('Kullanılamıyor'),
            'status' => $sha ? 'ok' : 'error',
            'blocking' => true,
        );
        $root = _PS_ROOT_DIR_;
        $checks[] = array(
            'label' => $this->t('Site kök dizini okunabilir (is_readable)'),
            'value' => is_readable($root) ? $this->t('Evet') : $this->t('Hayır'),
            'status' => is_readable($root) ? 'ok' : 'error',
            'blocking' => true,
        );
        $checks[] = array(
            'label' => $this->t('Yedek dizini yazılabilir (is_writable)'),
            'value' => $this->storage !== null
                ? $this->storage->relative($this->storage->backupsDir())
                : $this->storageError,
            'status' => $this->storage !== null && is_writable($this->storage->backupsDir()) ? 'ok' : 'error',
            'blocking' => true,
        );
        $free = $this->storage !== null ? $this->storage->freeSpace() : null;
        $checks[] = array(
            'label' => $this->t('Boş disk alanı (disk_free_space)'),
            'value' => $free === null ? $this->t('Tespit edilemedi') : EgeserBackupStorage::formatBytes($free),
            'status' => $free === null ? 'warning' : ($free < 524288000 ? 'warning' : 'ok'),
            'blocking' => false,
        );
        $maxTime = (int) ini_get('max_execution_time');
        $checks[] = array(
            'label' => 'max_execution_time',
            'value' => ($maxTime <= 0 ? $this->t('Sınırsız') : $maxTime . ' sn') . ' - '
                . sprintf($this->t('istek başına iş süresi: %d sn'), (int) EgeserBackupManager::timeBudget()),
            'status' => $maxTime > 0 && $maxTime < 30 ? 'warning' : 'ok',
            'blocking' => false,
        );
        $checks[] = array(
            'label' => 'memory_limit',
            'value' => (string) ini_get('memory_limit'),
            'status' => 'ok',
            'blocking' => false,
        );
        $basedir = (string) ini_get('open_basedir');
        $checks[] = array(
            'label' => 'open_basedir',
            'value' => $basedir === '' ? $this->t('Yok') : $this->t('Aktif (kök dışındaki bağlantılar okunamaz)'),
            'status' => 'ok',
            'blocking' => false,
        );

        return $checks;
    }

    /**
     * @param array $meta
     *
     * @return array
     */
    private function decorateBackup(array $meta)
    {
        $parts = array();
        foreach ($meta['parts'] as $part) {
            $parts[] = array(
                'number' => (int) $part['number'],
                'file' => (string) $part['file'],
                'size_h' => EgeserBackupStorage::formatBytes(isset($part['size']) ? $part['size'] : 0),
                'entries' => isset($part['entries']) ? (int) $part['entries'] : 0,
                'sha256' => isset($part['sha256']) ? (string) $part['sha256'] : '',
                'exists' => !empty($part['exists']),
                'url' => $this->apiUrl('download') . '&backup=' . rawurlencode($meta['id']) . '&part=' . (int) $part['number'],
            );
        }
        $counters = isset($meta['counters']) ? $meta['counters'] : array();
        $problems = (isset($counters['skipped']) ? (int) $counters['skipped'] : 0)
            + (isset($counters['unreadable']) ? (int) $counters['unreadable'] : 0)
            + (isset($counters['errors']) ? (int) $counters['errors'] : 0);
        if ($meta['missing_parts'] > 0) {
            $statusLabel = $this->t('Eksik dosya');
            $statusClass = 'danger';
        } elseif ($problems > 0) {
            $statusLabel = sprintf($this->t('Tamamlandı (%d uyarı)'), $problems);
            $statusClass = 'warning';
        } else {
            $statusLabel = $this->t('Tamamlandı, doğrulandı');
            $statusClass = 'success';
        }

        return array(
            'id' => $meta['id'],
            'date' => date('d.m.Y H:i', (int) $meta['completed_at']),
            'size_h' => EgeserBackupStorage::formatBytes($meta['total_size']),
            'files' => isset($meta['totals']['files']) ? (int) $meta['totals']['files'] : 0,
            'status_label' => $statusLabel,
            'status_class' => $statusClass,
            'parts' => $parts,
            'report_url' => $meta['has_report']
                ? $this->apiUrl('download') . '&backup=' . rawurlencode($meta['id']) . '&report=1'
                : '',
        );
    }

    /**
     * @return array
     */
    private function jsTexts()
    {
        $keys = array(
            'confirmCancel' => 'Yedekleme işlemi iptal edilsin mi? Yarım kalan ZIP dosyası silinecek.',
            'confirmDelete' => 'Bu yedek sunucudan kalıcı olarak silinsin mi?',
            'confirmCleanup' => '%d günden eski tüm yedekler silinsin mi?',
            'confirmSpace' => 'Disk alanı uyarısı:',
            'confirmContinue' => 'Yine de devam edilsin mi?',
            'networkError' => 'Sunucuya ulaşılamadı veya istek zaman aşımına uğradı. İşlem duraklatıldı; "Devam Et" ile kaldığı yerden sürdürebilirsiniz.',
            'invalidResponse' => 'Sunucudan geçersiz yanıt alındı (oturum süresi dolmuş olabilir). Sayfayı yenileyin.',
            'retrying' => 'Bağlantı sorunu, yeniden deneniyor',
            'busy' => 'Başka bir istek işleniyor, bekleniyor...',
            'scanning' => 'Taranıyor',
            'leaveWarning' => 'Yedekleme devam ediyor. Sayfadan ayrılırsanız daha sonra "Devam Et" ile sürdürebilirsiniz.',
            'completed' => 'Yedekleme tamamlandı ve doğrulandı.',
            'part' => 'Parça',
            'download' => 'İndir',
            'skipped' => 'Atlandı',
            'unreadable' => 'Okunamadı',
            'error' => 'Hata',
            'noIssues' => 'Sorunlu dosya yok.',
            'paused' => 'Duraklatıldı',
            'verifyPart' => 'Doğrulanan parça',
            'scanDone' => 'Tarama tamamlandı. Yedeği oluşturmak için "Yedek Oluştur" butonuna basın.',
            'resumeHint' => 'Yarım kalmış bir yedekleme işi var. "Devam Et" ile kaldığı yerden sürdürebilir veya iptal edebilirsiniz.',
            'dirsScanned' => 'klasör tarandı',
            'pendingDirs' => 'bekleyen klasör',
            'excluded' => 'hariç tutulan öğe',
            'files' => 'dosya',
            'emptyDirs' => 'boş klasör',
            'entries' => 'kayıt',
            'report' => 'Rapor',
            'cancelled' => 'İşlem iptal edildi.',
        );
        $texts = array();
        foreach ($keys as $key => $text) {
            $texts[$key] = $this->t($text);
        }

        return $texts;
    }

    private function bootManager()
    {
        if ($this->manager !== null || $this->storageError !== '') {
            return;
        }
        try {
            $this->storage = new EgeserBackupStorage(_PS_ROOT_DIR_);
            $this->storage->prepare();
            $this->logger = new EgeserBackupLogger($this->storage->logFile());
            $this->manager = new EgeserBackupManager($this->storage, $this->logger);
        } catch (EgeserBackupException $e) {
            $this->storageError = $e->getMessage();
            $this->manager = null;
        }
    }

    /**
     * Employee must be logged in, have "edit" permission on this tab and,
     * when enabled, be a SuperAdmin.
     *
     * @return bool
     */
    private function canUse()
    {
        $employee = $this->context->employee;
        if (!Validate::isLoadedObject($employee)) {
            return false;
        }
        if (!$this->access('view') || !$this->access('edit')) {
            return false;
        }
        $settings = EgeserBackupSettings::load();

        return !$settings['superadmin_only'] || $this->isSuperAdmin();
    }

    /**
     * @return bool
     */
    private function isSuperAdmin()
    {
        $employee = $this->context->employee;

        return Validate::isLoadedObject($employee) && (int) $employee->id_profile === (int) _PS_ADMIN_PROFILE_;
    }

    /**
     * @return bool
     */
    private function isValidToken()
    {
        $token = $this->stringParam('token');

        return $token !== '' && hash_equals(Tools::getAdminTokenLite('AdminEgeserBackup'), $token);
    }

    /**
     * Request parameter as string; arrays and other types become ''.
     *
     * @param string $name
     *
     * @return string
     */
    private function stringParam($name)
    {
        $value = Tools::getValue($name, '');

        return is_string($value) || is_int($value) ? (string) $value : '';
    }

    /**
     * @return bool
     */
    private function isApiPost()
    {
        return isset($_SERVER['REQUEST_METHOD'], $_SERVER['HTTP_X_EGESER_BACKUP'])
            && strtoupper($_SERVER['REQUEST_METHOD']) === 'POST'
            && $_SERVER['HTTP_X_EGESER_BACKUP'] === '1';
    }

    /**
     * @param string $op
     *
     * @return string
     */
    private function apiUrl($op = '')
    {
        $url = $this->context->link->getAdminLink('AdminEgeserBackup', false)
            . '&token=' . Tools::getAdminTokenLite('AdminEgeserBackup')
            . '&ajax=1&action=' . self::API_ACTION;
        if ($op !== '') {
            $url .= '&op=' . $op;
        }

        return $url;
    }

    /**
     * "egeserkonteyner" from www.egeserkonteyner.com
     *
     * @return string
     */
    private function shopSlug()
    {
        $domain = strtolower((string) Tools::getShopDomain(false));
        $domain = preg_replace('/^www\./', '', $domain);
        $domain = preg_replace('/:\d+$/', '', $domain);
        if (filter_var($domain, FILTER_VALIDATE_IP) !== false) {
            return 'prestashop';
        }
        $label = explode('.', $domain);
        $slug = preg_replace('/[^a-z0-9-]/', '', $label[0]);
        $slug = trim(substr($slug, 0, 40), '-');

        return $slug !== '' ? $slug : 'prestashop';
    }

    /**
     * @param Throwable $e
     *
     * @return string
     */
    private function publicMessage(Throwable $e)
    {
        if ($e instanceof EgeserBackupException) {
            return $e->getMessage();
        }
        if ($this->logger !== null) {
            $this->logger->error(get_class($e) . ': ' . $e->getMessage());
        }

        return $this->t('Beklenmeyen bir hata oluştu. Ayrıntılar modül log dosyasına yazıldı.');
    }

    /**
     * @param string $text
     *
     * @return string
     */
    private function t($text)
    {
        return html_entity_decode($this->module->l($text, 'adminegeserbackupcontroller'), ENT_QUOTES, 'UTF-8');
    }

    /**
     * @param bool $success
     * @param string $message
     * @param array $data
     * @param int $httpCode
     */
    private function jsonResponse($success, $message, array $data = array(), $httpCode = 200)
    {
        while (ob_get_level() > 0) {
            @ob_end_clean();
        }
        if (!headers_sent()) {
            http_response_code($httpCode);
            header('Content-Type: application/json; charset=utf-8');
            header('Cache-Control: no-store, no-cache, must-revalidate');
            header('X-Content-Type-Options: nosniff');
            header('X-LiteSpeed-Cache-Control: no-cache');
        }
        echo json_encode(
            array('success' => (bool) $success, 'message' => (string) $message, 'data' => (object) $data),
            EgeserBackupStorage::jsonFlags()
        );
        exit;
    }

    /**
     * @param int $code
     * @param string $message
     */
    private function plainResponse($code, $message)
    {
        while (ob_get_level() > 0) {
            @ob_end_clean();
        }
        http_response_code($code);
        header('Content-Type: text/plain; charset=utf-8');
        header('X-Content-Type-Options: nosniff');
        echo $message;
        exit;
    }
}
