{**
 * Egeser Full Backup
 *
 * @author    Egeser
 * @copyright Egeser
 * @license   Proprietary
 *}
<div id="egeser-backup-app" data-config="{$egb_config_json|escape:'html':'UTF-8'}">

  <div class="alert alert-info">
    <strong>{l s='Bu modül bir DOSYA SİSTEMİ yedeği (File System Backup) alır.' mod='egeserbackup'}</strong>
    {l s='Veritabanı dökümü dahil DEĞİLDİR. Siteyi tamamen geri yüklemek için bu dosya yedeği ile birlikte ayrı bir SQL veritabanı yedeği gerekir.' mod='egeserbackup'}
  </div>

  {* ---------------------------------------------------------------- checks *}
  <div class="panel">
    <div class="panel-heading"><i class="icon-check"></i> {l s='Sistem Kontrolleri' mod='egeserbackup'}</div>
    <table class="table egb-checks">
      <tbody>
      {foreach from=$egb_checks item=check}
        <tr>
          <td class="egb-check-icon">
            {if $check.status == 'ok'}
              <i class="icon-check text-success"></i>
            {elseif $check.status == 'warning'}
              <i class="icon-warning text-warning"></i>
            {else}
              <i class="icon-remove text-danger"></i>
            {/if}
          </td>
          <td><strong>{$check.label|escape:'html':'UTF-8'}</strong></td>
          <td class="{if $check.status == 'error'}text-danger{elseif $check.status == 'warning'}text-warning{/if}">{$check.value|escape:'html':'UTF-8'}</td>
        </tr>
      {/foreach}
      </tbody>
    </table>
    {if !$egb_ready}
      <div class="alert alert-danger">{l s='Kırmızı işaretli gereksinimler karşılanmadan yedekleme başlatılamaz.' mod='egeserbackup'}</div>
    {/if}
  </div>

  {* ---------------------------------------------------------------- job *}
  <div class="panel" id="egb-job-panel">
    <div class="panel-heading"><i class="icon-archive"></i> {l s='Backup Durumu' mod='egeserbackup'}</div>

    <div id="egb-message" class="alert" style="display:none"></div>

    <div id="egb-idle">
      <p>
        {l s='"Dosyaları Tara" yalnızca dosya sayısını ve toplam boyutu hesaplar. "Yedek Oluştur" önce tarar, disk alanını kontrol eder ve ardından ZIP dosyasını adım adım oluşturur.' mod='egeserbackup'}
      </p>
    </div>

    <div id="egb-status" style="display:none">
      <h4 id="egb-status-label" class="egb-status-label"></h4>

      <div class="progress egb-progress">
        <div id="egb-progress-bar" class="progress-bar progress-bar-striped" role="progressbar" style="width:0%">
          <span id="egb-progress-text">0%</span>
        </div>
      </div>

      <div class="row egb-stats">
        <div class="col-xs-6 col-sm-4 col-md-2"><div class="egb-stat"><span class="egb-stat-label">{l s='Toplam dosya' mod='egeserbackup'}</span><span class="egb-stat-value" id="egb-total-files">-</span></div></div>
        <div class="col-xs-6 col-sm-4 col-md-2"><div class="egb-stat"><span class="egb-stat-label">{l s='İşlenen' mod='egeserbackup'}</span><span class="egb-stat-value" id="egb-processed">-</span></div></div>
        <div class="col-xs-6 col-sm-4 col-md-2"><div class="egb-stat"><span class="egb-stat-label">{l s='İlerleme' mod='egeserbackup'}</span><span class="egb-stat-value" id="egb-percent">-</span></div></div>
        <div class="col-xs-6 col-sm-4 col-md-2"><div class="egb-stat"><span class="egb-stat-label">{l s='Kaynak boyut' mod='egeserbackup'}</span><span class="egb-stat-value" id="egb-total-size">-</span></div></div>
        <div class="col-xs-6 col-sm-4 col-md-2"><div class="egb-stat"><span class="egb-stat-label">{l s='ZIP boyutu' mod='egeserbackup'}</span><span class="egb-stat-value" id="egb-zip-size">-</span></div></div>
        <div class="col-xs-6 col-sm-4 col-md-2"><div class="egb-stat"><span class="egb-stat-label">{l s='Geçen süre' mod='egeserbackup'}</span><span class="egb-stat-value" id="egb-elapsed">00:00</span></div></div>
      </div>

      <div class="row egb-counters">
        <div class="col-xs-6 col-sm-3"><span class="label label-success">{l s='Başarılı' mod='egeserbackup'}</span> <strong id="egb-success">0</strong></div>
        <div class="col-xs-6 col-sm-3"><span class="label label-default">{l s='Atlanan' mod='egeserbackup'}</span> <strong id="egb-skipped">0</strong></div>
        <div class="col-xs-6 col-sm-3"><span class="label label-warning">{l s='Okunamayan' mod='egeserbackup'}</span> <strong id="egb-unreadable">0</strong></div>
        <div class="col-xs-6 col-sm-3"><span class="label label-danger">{l s='Hata' mod='egeserbackup'}</span> <strong id="egb-errors">0</strong></div>
      </div>

      <p class="egb-current"><strong>{l s='Mevcut dosya:' mod='egeserbackup'}</strong> <code id="egb-current-file">-</code></p>
      <p class="egb-meta text-muted">
        <span id="egb-scan-info"></span>
        <span id="egb-excluded-info"></span>
      </p>

      <div id="egb-space" class="alert" style="display:none"></div>
    </div>

    <div id="egb-completed" class="alert alert-success" style="display:none">
      <h4>{l s='Yedekleme tamamlandı ve doğrulandı.' mod='egeserbackup'}</h4>
      <div id="egb-completed-body"></div>
      <p><a href="#" id="egb-reload" class="btn btn-default"><i class="icon-refresh"></i> {l s='Yedek listesini yenile' mod='egeserbackup'}</a></p>
    </div>

    <div class="egb-actions">
      <button type="button" id="egb-scan" class="btn btn-default"{if !$egb_ready} disabled="disabled"{/if}>
        <i class="icon-search"></i> {l s='Dosyaları Tara' mod='egeserbackup'}
      </button>
      <button type="button" id="egb-start" class="btn btn-primary"{if !$egb_ready} disabled="disabled"{/if}>
        <i class="icon-archive"></i> {l s='Yedek Oluştur' mod='egeserbackup'}
      </button>
      <button type="button" id="egb-resume" class="btn btn-success" style="display:none">
        <i class="icon-play"></i> {l s='Devam Et' mod='egeserbackup'}
      </button>
      <button type="button" id="egb-cancel" class="btn btn-danger" style="display:none">
        <i class="icon-remove"></i> {l s='İşlemi İptal Et' mod='egeserbackup'}
      </button>
    </div>

    <div id="egb-issues-wrap" style="display:none">
      <h4>{l s='Atlanan / okunamayan / hatalı dosyalar (son 50)' mod='egeserbackup'}</h4>
      <div class="egb-issues-scroll">
        <table class="table table-condensed">
          <thead><tr><th>{l s='Tür' mod='egeserbackup'}</th><th>{l s='Dosya' mod='egeserbackup'}</th><th>{l s='Açıklama' mod='egeserbackup'}</th></tr></thead>
          <tbody id="egb-issues"></tbody>
        </table>
      </div>
      <p class="help-block">{l s='Tam liste, yedek tamamlandığında indirilebilir rapor dosyasına yazılır.' mod='egeserbackup'}</p>
    </div>
  </div>

  {* ---------------------------------------------------------------- settings *}
  {$egb_settings_form nofilter}

  {* ---------------------------------------------------------------- backups *}
  <div class="panel" id="egb-backups-panel">
    <div class="panel-heading">
      <i class="icon-folder-open"></i> {l s='Mevcut Yedekler' mod='egeserbackup'}
      <span class="badge">{$egb_backups|@count}</span>
    </div>
    <p class="text-muted">
      {l s='Sunucudaki konum (web erişimine kapalı):' mod='egeserbackup'} <code>{$egb_storage_path|escape:'html':'UTF-8'}</code>.
      {l s='İndirme yalnızca bu sayfa üzerinden, oturum ve token kontrolüyle yapılır.' mod='egeserbackup'}
    </p>
    {if $egb_backups|@count > 0}
      <div class="table-responsive">
        <table class="table egb-backups">
          <thead>
          <tr>
            <th>{l s='Dosya adı' mod='egeserbackup'}</th>
            <th>{l s='Tarih' mod='egeserbackup'}</th>
            <th>{l s='Boyut' mod='egeserbackup'}</th>
            <th>{l s='Durum' mod='egeserbackup'}</th>
            <th class="text-right">{l s='İşlemler' mod='egeserbackup'}</th>
          </tr>
          </thead>
          <tbody>
          {foreach from=$egb_backups item=backup}
            <tr>
              <td>
                {foreach from=$backup.parts item=part}
                  <div class="egb-part">
                    <strong>{$part.file|escape:'html':'UTF-8'}</strong>
                    <span class="text-muted">({$part.size_h|escape:'html':'UTF-8'}, {$part.entries|intval} {l s='kayıt' mod='egeserbackup'})</span>
                    <div class="egb-hash">SHA-256: <code>{$part.sha256|escape:'html':'UTF-8'}</code></div>
                  </div>
                {/foreach}
              </td>
              <td>{$backup.date|escape:'html':'UTF-8'}</td>
              <td>{$backup.size_h|escape:'html':'UTF-8'}<br><small class="text-muted">{$backup.files|intval} {l s='dosya' mod='egeserbackup'}</small></td>
              <td><span class="label label-{$backup.status_class|escape:'html':'UTF-8'}">{$backup.status_label|escape:'html':'UTF-8'}</span></td>
              <td class="text-right egb-row-actions">
                {foreach from=$backup.parts item=part}
                  {if $part.exists}
                    <a class="btn btn-default btn-sm" href="{$part.url|escape:'html':'UTF-8'}">
                      <i class="icon-download"></i> {l s='İndir' mod='egeserbackup'}{if $backup.parts|@count > 1} ({l s='Parça' mod='egeserbackup'} {$part.number|intval}){/if}
                    </a>
                  {/if}
                {/foreach}
                {if $backup.report_url}
                  <a class="btn btn-default btn-sm" href="{$backup.report_url|escape:'html':'UTF-8'}"><i class="icon-file-text"></i> {l s='Rapor' mod='egeserbackup'}</a>
                {/if}
                <button type="button" class="btn btn-danger btn-sm egb-delete" data-backup="{$backup.id|escape:'html':'UTF-8'}">
                  <i class="icon-trash"></i> {l s='Sil' mod='egeserbackup'}
                </button>
              </td>
            </tr>
          {/foreach}
          </tbody>
        </table>
      </div>
    {else}
      <p class="alert alert-warning">{l s='Henüz tamamlanmış bir yedek yok.' mod='egeserbackup'}</p>
    {/if}
    <div class="panel-footer">
      <button type="button" id="egb-cleanup" class="btn btn-default">
        <i class="icon-eraser"></i> {l s='Eski yedekleri temizle' mod='egeserbackup'} ({$egb_retention_days|intval} {l s='günden eski' mod='egeserbackup'})
      </button>
    </div>
  </div>

  {* ---------------------------------------------------------------- log *}
  <div class="panel">
    <div class="panel-heading"><i class="icon-list"></i> {l s='Modül Logu (son 100 satır)' mod='egeserbackup'}</div>
    <p class="text-muted">{l s='Log dosyası:' mod='egeserbackup'} <code>{$egb_log_path|escape:'html':'UTF-8'}</code></p>
    {if $egb_log_lines|@count > 0}
      <pre class="egb-log">{foreach from=$egb_log_lines item=line}{$line|escape:'html':'UTF-8'}
{/foreach}</pre>
    {else}
      <p class="text-muted">{l s='Log kaydı yok.' mod='egeserbackup'}</p>
    {/if}
  </div>
</div>
