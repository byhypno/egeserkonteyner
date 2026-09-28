# Egeser Full Backup (`egeserbackup`)

PrestaShop Back Office üzerinden, **FTP / SFTP / cPanel erişimi olmadan**, sitenin
PHP tarafından okunabilen tüm dosyalarını güvenli biçimde ZIP olarak yedekleyip
indirmenizi sağlayan modül.

> ## ⚠️ Bu modül bir DOSYA SİSTEMİ yedeği (File System Backup) alır
>
> **Veritabanı dökümü (SQL) bu sürümde DAHİL DEĞİLDİR.**
> Bir PrestaShop sitesini tamamen geri yüklemek için **ikisi birlikte** gerekir:
>
> 1. Bu modülle alınan **dosya yedeği** (ZIP)
> 2. Ayrıca alınmış **SQL veritabanı yedeği**
>
> Yalnızca dosya yedeğiyle siparişler, ürünler, müşteriler, ayarlar geri gelmez.

---

## 1. Gereksinimler

| Gereksinim | Değer |
|---|---|
| PrestaShop | 1.7.x (1.7.8.8 hedeflenerek geliştirildi ve bu sürümün core kaynağına göre kontrol edildi) |
| PHP | 7.1 – 7.4 (PHP 7.4.33 ile test edildi). PHP 8'e özel sözdizimi kullanılmaz. |
| PHP eklentileri | **zip (ZipArchive)** zorunlu, `hash` (SHA-256) ve `json` (PHP'de standart) |
| Disk | Yedeklenecek dosyaların toplam boyutu + bir ZIP parçası kadar boş alan (aşağıya bakın) |
| Yazma izni | `var/` klasörü (PrestaShop zaten bunu gerektirir) |
| Web sunucusu | LiteSpeed, Apache, Nginx, IIS (güvenlik `.htaccess`'e bağımlı değildir) |

Yapılandırma sayfasındaki **Sistem Kontrolleri** paneli bunların hepsini kontrol
eder (ZipArchive, SHA-256, `is_readable`, `is_writable`, `disk_free_space`,
`max_execution_time`, `memory_limit`, `open_basedir`). ZipArchive yoksa
“Sunucuda PHP ZipArchive extension aktif değil.” hatası gösterilir ve yedekleme
butonları devre dışı kalır.

## 2. Kurulum

1. `egeserbackup.zip` dosyasını **açmadan** kullanın (içinde en üstte `egeserbackup/` klasörü vardır).
2. Back Office → **Modüller → Modül Yöneticisi → “Modül yükle”** → `egeserbackup.zip` seçin.
3. Kurulum bitince **Yapılandır**'a tıklayın.

Kurulum şunları yapar:

- `Gelişmiş Parametreler → Egeser Full Backup` menü girişini (tab: `AdminEgeserBackup`) oluşturur.
- Yapılandırma değerlerini (`EGESERBACKUP_*`) varsayılanlarıyla ekler.
- Core dosyalarına dokunmaz, override kullanmaz, veritabanında tablo oluşturmaz.

Not: PrestaShop 1.7'nin otomatik tab kaydedicisi, tab modül tarafından zaten
oluşturulduğu için PrestaShop loguna bir kez “Cannot register tab
AdminEgeserBackup because it already exists” bilgisini yazabilir. Bu zararsızdır.

## 3. Kullanım

**Modüller → Modül Yöneticisi → Egeser Full Backup → Yapılandır**
(veya **Gelişmiş Parametreler → Egeser Full Backup**)

1. **Dosyaları Tara**: Tüm kök dizini tarar; toplam dosya sayısını, toplam
   boyutu, boş disk alanını ve uyarıları gösterir. ZIP oluşturmaz.
2. **Yedek Oluştur**: Tarama yapılmadıysa önce tarar, disk alanını kontrol eder,
   sonra ZIP'i adım adım oluşturur. Ekranda şunlar canlı güncellenir:
   toplam dosya, işlenen, yüzde, ilerleme çubuğu, mevcut dosya, kaynak boyut,
   ZIP boyutu, geçen süre ve **başarılı / atlanan / okunamayan / hata** sayaçları.
   Sorunlu dosyaların son 50'si tabloda listelenir.
3. İşlem tamamlanınca ZIP doğrulanır (açılabilirlik + kayıt sayısı), **SHA-256**
   hesaplanır ve ancak ondan sonra “Yedekleme tamamlandı ve doğrulandı” gösterilir.
4. **Mevcut Yedekler** tablosundan **İndir**, **Rapor** (tam sorunlu dosya listesi)
   ve **Sil** işlemleri yapılır.
5. **İşlemi İptal Et**: yarım ZIP, manifest ve iş durumu silinir.
6. **Eski yedekleri temizle**: ayarlardaki gün sayısından (varsayılan 7) eski
   yedekleri siler. Otomatik/cron silme yoktur, yalnızca butonla çalışır.

### Yarıda kalan işlemler

Sayfayı kapatırsanız, internet koparsa veya bir istek zaman aşımına uğrarsa iş
**kaybolmaz**. Sayfayı yeniden açtığınızda “Yarım kalmış bir yedekleme işi var”
mesajı ve **Devam Et** butonu görünür; kaldığı yerden sürer. Ağ hatalarında
tarayıcı 5 kez otomatik olarak yeniden dener.

### Aynı anda tek yedek

Aynı anda yalnızca **bir** aktif yedekleme işi olabilir. İkinci bir başlatma
denemesinde “Devam eden bir backup işlemi var.” uyarısı gösterilir. Ayrıca her
adım bir dosya kilidi (`flock`) ile korunur; iki sekme veya çift tıklama aynı
batch'i iki kez işleyemez.

### Ayarlar

| Ayar | Varsayılan | Açıklama |
|---|---|---|
| Cache klasörlerini dahil et | Hayır | Kapalıyken `var/cache`, `var/sessions`, `cache/smarty/cache`, `cache/smarty/compile`, `cache/cachefs`, `cache/purifier`, `img/tmp` içeriği hariç tutulur; klasörün kendisi ve varsa içindeki koruma dosyaları (`index.php`, `.htaccess`) saklanır. |
| Log dosyalarını dahil et | Hayır | Kapalıyken `var/logs`, `log/`, `*.log`, `*.log.N`, `error_log` hariç tutulur (kural tüm ağaçta geçerlidir; ör. `vendor/` altındaki bir test `.log` dosyası da dışarıda kalır). |
| Batch boyutu | 250 | Bir AJAX isteğinde ZIP'e eklenecek en fazla dosya (10–2000). Ayrıca bir istek en fazla ~128 MB kaynak veri işler. |
| ZIP parça boyutu | 1024 MB | Arşiv bu boyuta ulaşınca yeni parça açılır (100–4096 MB, 0 = tek ZIP). |
| Ek hariç tutulacak yollar | boş | Her satıra köke göre göreli bir yol (ör. `modules/ornek/cache`). |
| Temizlik gün sayısı | 7 | “Eski yedekleri temizle” butonu için. |
| Yalnızca SuperAdmin | Evet | Yalnızca SuperAdmin tarafından değiştirilebilir. |

Ayarlar bir sonraki işte kullanılır; devam eden iş başladığı andaki ayarlarla biter.

## 4. Yedeğe neler dahil?

PrestaShop kök dizini (`_PS_ROOT_DIR_`) **recursive olarak** taranır; sabit bir
klasör listesi yoktur. `app`, `bin`, `classes`, `config`, `controllers`,
`download`, `img`, `js`, `mails`, `modules`, `override`, `pdf`, `src`, `themes`
(ör. `ulubey_webxm`), `tools`, `translations`, `upload`, `vendor`, `webservice`,
yeniden adlandırılmış admin klasörü, `index.php`, `.htaccess`, `robots.txt`,
`composer.*` ve kökteki diğer tüm gerçek dosyalar dahildir.

**Her zaman hariç** (hiçbir ayarla açılamaz): `var/egeserbackup/` — yani önceki
yedekler, oluşturulmakta olan ZIP, manifest, iş durumu ve modül logu. Yedek
asla kendini içeremez.

ZIP içindeki yollar köke göredir (`themes/ulubey_webxm/...`); ön ek klasör yoktur.
Unix dosya izinleri ZIP'e yazılır. Boş klasörler (ve hariç tutulan cache/log
klasörleri) boş klasör kaydı olarak saklanır.

### Sembolik bağlantılar (symlink)

- Klasöre işaret eden symlink'ler **asla takip edilmez** → sonsuz döngü imkânsızdır
  (“atlanan” olarak raporlanır). Ek güvenlik olarak 64 seviye derinlik sınırı vardır.
- Kök dizin içindeki normal bir dosyaya işaret eden symlink, hedef içeriğiyle
  normal dosya olarak eklenir.
- Kök dışını gösteren veya kırık bağlantılar atlanır ve raporlanır.

## 5. Batch mimarisi (neden böyle?)

Tüm siteyi tek istekte ZipArchive ile sıkıştırmak, 120 sn `max_execution_time`
ve paylaşımlı sunucu limitleri nedeniyle büyük sitelerde kesin olarak
başarısız olur. Bu yüzden iş üç aşamaya bölünmüştür ve **her aşama da batch
halinde** çalışır:

1. **Tarama (scan)** — Tarama da AJAX batch'lere bölündü, çünkü 100.000+ dosyalı
   bir sitede yalnızca `stat` çağrıları bile tek istekte zaman aşımına yol
   açabilir. Bekleyen klasörler bir yığında (`job.json`) tutulur; her istek
   `max_execution_time`'ın %30'u kadar (5–20 sn; 120 sn'de 20 sn) çalışır, her
   klasörü tamamen listeler ve manifest dosyasına satır ekler:
   `F<TAB>boyut<TAB>yol` / `D<TAB>0<TAB>boş/klasör`.
   Dosya metadata'sı PHP session'ına veya belleğe yığılmaz.
2. **Arşivleme (archive)** — Her istek manifest'te kaydedilmiş bayt
   konumuna (offset) `fseek` ile gider, en fazla *batch boyutu* kadar dosyayı
   `ZipArchive::addFile()` ile ekler ve `close()` eder. Dosya içerikleri PHP
   belleğine alınmaz (`file_get_contents` kullanılmaz); libzip diskten akıtır.
   Zaten sıkıştırılmış biçimler (jpg, png, webp, zip, mp4, woff2, pdf…)
   sıkıştırılmadan (STORE) eklenir, bu da büyük ölçüde hız kazandırır.
3. **Doğrulama (verify)** — Her parça için: dosya var mı, boyut > 0 mı,
   `ZipArchive::open(CHECKCONS)` ile açılıyor mu, `numFiles` beklenen kayıt
   sayısına eşit mi; ardından ayrı bir istekte SHA-256 hesaplanır. Sonra
   parçalar yedek klasörüne taşınır, meta dosyası ve rapor yazılır.

### Neden ZIP parçaları?

libzip (ZipArchive'in altındaki kütüphane) her `close()` çağrısında arşivin
**tamamını** geçici bir dosyaya yeniden yazar. Ölçüm: 300 MB'lık bir ZIP'e
tek küçük dosya eklemek ~2,3 sn sürdü. Tek dev bir ZIP'te her batch önceki
gigabaytları yeniden kopyalar (toplam iş karesel büyür, son batch'ler zaman
aşımına yaklaşır). Parçalara bölmek bu maliyeti parça boyutuyla sınırlar.

- Her parça **bağımsız, standart bir ZIP** dosyasıdır (bölünmüş/spanned arşiv değildir).
- Tek parçalı yedek: `egeserkonteyner-files-YYYY-MM-DD-HHMM.zip`
- Çok parçalı yedek: `egeserkonteyner-files-YYYY-MM-DD-HHMM.part1.zip`, `.part2.zip`, …
- Geri yüklerken tüm parçalar **aynı klasöre** açılır.
- Tek dosya isterseniz ayarlardan parça boyutunu `0` yapın (küçük/orta sitelerde sorun olmaz).

### Çökme / zaman aşımı güvenliği

- Manifest ve hata listesi yalnızca eklenen dosyalardır; “işlenmiş” boyutları
  `job.json` içinde saklanır. Her adım önce bu dosyaları kayıtlı boyuta
  kırpar, sonra yeni durumu tek bir atomik yazmayla (geçici dosya + `rename`)
  kaydeder. Yarıda öldürülen bir istek tutarsızlık bırakmaz.
- libzip ZIP'i geçici dosyaya yazıp yalnızca başarılıysa yerine koyar; başarısız
  bir `close()` önceki içeriği bozmaz.
- Bir batch ölürse (zaman aşımı vb.) aynı bölüm **dosya dosya** yeniden denenir;
  aynı dosya 3 kez isteği öldürürse o dosya “hata” olarak raporlanır ve atlanır.
- Doğrulamadaki kayıt sayısı, libzip'in kendi `numFiles` değerinden alınır.

## 6. Yedeklerin konumu

```
var/egeserbackup/                        .htaccess + web.config + index.php (erişim yasak)
var/egeserbackup/vault_<32 hex>/         rastgele, tahmin edilemez klasör adı
    backups/  <id>.zip | <id>.partN.zip, <id>.json (meta), <id>.report.txt
    work/     job.json, .lock, cancel.flag, <id>/ (manifest, yapılmakta olan parçalar)
    logs/     egeserbackup.log
```

Gerçek yol yapılandırma sayfasında “Mevcut Yedekler” ve “Modül Logu”
panellerinde gösterilir.

## 7. Log

- Modül logu: `var/egeserbackup/vault_<...>/logs/egeserbackup.log`
  (5 MB'ı geçince `.1` olarak döndürülür). Son 100 satırı modül sayfasında,
  **Modül Logu** panelinde görebilirsiniz (FTP gerekmez).
- Beklenmeyen PHP hataları kullanıcıya genel bir mesajla gösterilir; ayrıntı
  (sınıf, mesaj, dosya:satır) yalnızca bu loga yazılır. Stack trace ekrana
  basılmaz.
- Her yedeğin tam sorunlu dosya listesi **Rapor** butonuyla indirilebilir.
- PrestaShop'un kendi logları: `var/logs/` ve Back Office → Gelişmiş Parametreler → Günlükler.

## 8. Güvenlik

| Risk | Önlem |
|---|---|
| Yetkisiz erişim | Employee oturumu (PrestaShop), tab için **görüntüleme + düzenleme** yetkisi (Takım → Yetkiler) ve varsayılan olarak **yalnızca SuperAdmin**. Yedekler `config/` (veritabanı şifresi dahil) içerdiğinden bu ayarın açık kalması önerilir. |
| CSRF | Her istekte controller'ın admin token'ı `hash_equals` ile kontrol edilir (PrestaShop'ta “URL'de token” kapalı olsa bile). Durum değiştiren tüm işlemler ayrıca **POST + `X-Egeser-Backup` özel başlığı** ister; bu başlık siteler arası CORS olmadan gönderilemez. |
| Direct download / public erişim | ZIP'ler web'den erişilemeyen `var/egeserbackup/` altında, rastgele adlı bir klasörde durur; `.htaccess` (Apache 2.2/2.4 + LiteSpeed), `web.config` (IIS) ve `index.php` ile ayrıca kapatılır. İndirme **her zaman** PHP controller üzerinden, oturum + yetki + token kontrolüyle yapılır; `.htaccess`'e güvenilmez. |
| Path traversal / arbitrary file read | İstemci yalnızca **yedek kimliği** (`^[a-z0-9][a-z0-9-]{2,100}$`) ve **parça numarası** (rakam) gönderir; `$_GET['file']` gibi bir parametre yoktur. Dosya adı sunucudaki meta dosyasından alınır, tekrar regex ile doğrulanır ve `realpath()` ile yedek klasörünün **içinde** kaldığı kontrol edilir; symlink reddedilir. |
| Arbitrary file delete | Silme yalnızca kimlikle, meta dosyasında listelenen ve aynı doğrulamalardan geçen dosyalar üzerinde yapılır. Klasör silme fonksiyonu vault dışına asla çıkmaz ve symlink takip etmez. |
| IDOR | Kimlikler yalnızca meta dosyası olan yedeklere çözülür; yetki kontrolü her işlemde yapılır. |
| XSS | Smarty çıktıları `escape:'html':'UTF-8'`, JSON yapılandırma `JSON_HEX_TAG/AMP` ile, dinamik veriler JS'te yalnızca `jQuery.text()` ile eklenir. |
| Command injection | Hiçbir kabuk komutu çalıştırılmaz (`exec`, `system`, `shell_exec` yok). |
| SQL injection | Modül SQL sorgusu çalıştırmaz; yalnızca `Configuration` API'si kullanılır. |
| Direct PHP execution | Tüm PHP dosyaları `_PS_VERSION_` kontrolüyle başlar; tüm klasörlerde `index.php` vardır. |
| Girdi doğrulama | İşlem adı whitelist'ten, tüm parametreler string olarak (dizi reddedilir), ayarlar tip/aralık kontrolüyle doğrulanır; hariç tutma yollarında `..`, joker ve özel karakter yasaktır. |
| Bilgi sızıntısı | Mesajlarda yalnızca köke göre göreli yollar gösterilir. |

## 9. Kaldırma / yeniden kurma

`uninstall()` yalnızca menü girişini ve `EGESERBACKUP_*` ayarlarını siler.
**Yedek dosyaları bilinçli olarak silinmez**: kullanıcının tek yedeğini
yanlışlıkla kaybetmesini önlemek için `var/egeserbackup/` yerinde kalır ve modül
yeniden kurulduğunda yedekler tekrar listelenir. Gerekmiyorsa kaldırmadan
önce modül sayfasından silin.

Önbellek: Kurulum sonrası PrestaShop önbelleğini temizlemek **gerekmez**
(modül override veya Symfony servisi eklemez). Menü girişi görünmezse
Gelişmiş Parametreler → Performans → “Önbelleği temizle” yeterlidir.

## 10. Geri yükleme mantığı

1. Hedef sunucuda boş bir web kök dizini hazırlayın.
2. ZIP'i (çok parçalıysa **tüm parçaları aynı klasöre**) açın. Örnek:
   `unzip egeserkonteyner-files-...part1.zip -d public_html` ,
   `unzip egeserkonteyner-files-...part2.zip -d public_html` …
3. İndirilen dosyaların bütünlüğünü SHA-256 ile doğrulayın:
   Linux/macOS `sha256sum dosya.zip`, Windows `certutil -hashfile dosya.zip SHA256`
   — değer modül ekranındaki/rapordaki değerle aynı olmalıdır.
4. SQL veritabanı yedeğini ayrıca içe aktarın.
5. Veritabanı bilgileri değiştiyse `app/config/parameters.php` dosyasını güncelleyin.
6. Alan adı değiştiyse `ps_shop_url` / `ps_configuration` (PS_SHOP_DOMAIN,
   PS_SHOP_DOMAIN_SSL) değerlerini güncelleyin.
7. `var/cache/` klasörünü boşaltın; klasör izinlerini (`var/`, `img/`, `upload/`,
   `download/`, `cache/`, `config/`, `translations/`, `mails/`, `modules/`,
   `themes/`) yazılabilir yapın.

## 11. Bilinen sınırlamalar

- **Veritabanı dahil değildir** (bkz. en üst).
- Yalnızca PHP kullanıcısının okuyabildiği dosyalar yedeklenebilir; okunamayanlar raporlanır.
- Kök dizin **dışındaki** dosyalar (ör. `public_html` dışı) yedeklenmez.
- Klasör symlink'leri takip edilmez (yalnızca raporlanır).
- Adında kontrol karakteri (satır sonu vb.) olan dosyalar atlanır ve raporlanır.
- Tarama ile arşivleme arasında silinen/değişen dosyalar “okunamayan” olarak raporlanır;
  canlı sitede yedek anındaki yazmalar (ör. yeni yüklenen görsel) tutarlılık açısından
  bir “anlık görüntü” garantisi vermez. Yoğun olmayan bir saatte yedek alın.
- ZIP sıkıştırma oranı önceden kesin bilinemez; disk kontrolü tahmine dayanır.
  Arşivleme sırasında alan biterse işlem **duraklatılır** (veri bozulmaz), alan
  açıp “Devam Et” ile sürdürülebilir.
- `disk_free_space()` barındırıcı tarafından kapatılmışsa boş alan bilinemez;
  kullanıcıdan onay istenir.
- Tek bir çok büyük dosya (ör. birkaç GB video) tek istekte sıkıştırılır;
  `max_execution_time` ve LiteSpeed istek süresi sınırlarını aşarsa 3 denemeden sonra
  atlanır ve raporlanır.
- İndirmeler PHP üzerinden akıtılır (1 MB parçalar, `Range` desteği ile devam
  ettirilebilir). Çok büyük tek dosyalar için parça boyutunu küçük tutmak daha güvenlidir.

## 12. Büyük sitelerde dikkat edilecekler (50.000 – 100.000+ dosya)

- Parça boyutunu 512–1024 MB arasında tutun; `0` (tek ZIP) çok büyük sitelerde yavaşlar.
- Zaman aşımı görürseniz batch boyutunu düşürün (ör. 100); hızlı sunucuda yükseltebilirsiniz (500+).
- Boş alan en az: kaynak boyut + 1 parça boyutu + ~100 MB olmalı.
- Yedek bitince indirip sunucudan **silin**; sunucuda duran yedek hem disk kaplar hem risktir.
- Gereksiz büyük klasörleri (eski 1-Click Upgrade yedekleri vb.) “Ek hariç tutulacak yollar”a ekleyin.
- İşlem sırasında sekme açık kalmalıdır; kapanırsa “Devam Et” ile sürer.

## 13. Geliştirici notları: veritabanı dökümü eklemek

Mimari aşamalıdır (`EgeserBackupPhaseInterface`). İş durumu `phases` listesi
taşır (şu an `['archive', 'verify']`). Bir “Include database dump” özelliği için:

1. `EgeserBackupDatabaseDumper implements EgeserBackupPhaseInterface` yazın;
   tabloları sayfa sayfa (LIMIT/OFFSET) okuyup iş klasörüne `database.sql`
   olarak ekleyin, ilerlemeyi `job->data['dbdump']` içinde tutun.
2. `EgeserBackupJob::create()` içinde ayar açıksa `phases` başına `'dbdump'` ekleyin.
3. `EgeserBackupManager::phase()` içine `'dbdump'` durumunu kaydedin.
4. Arşivleyicide SQL dosyasını ZIP'e `__database__/database.sql` olarak ekleyin.

Diğer sınıflar (tarama, doğrulama, depolama, indirme) değişmeden kalır.

## 14. Dosya yapısı

```
egeserbackup/
├── egeserbackup.php                     Modül sınıfı: install/uninstall, tab, getContent → controller
├── config.xml
├── logo.png
├── README.md
├── classes/
│   ├── EgeserBackupException.php        Kullanıcıya gösterilebilir hata
│   ├── EgeserBackupStorage.php          Yollar, koruma dosyaları, atomik JSON, realpath kontrolleri
│   ├── EgeserBackupSettings.php         Ayarlar + doğrulama
│   ├── EgeserBackupExclusions.php       Hariç tutma kuralları
│   ├── EgeserBackupJob.php              Dosya tabanlı iş durumu (job.json), hata listesi
│   ├── EgeserBackupLock.php             flock tabanlı kilit
│   ├── EgeserBackupPhaseInterface.php   Aşama arayüzü
│   ├── EgeserBackupScanner.php          1) Batch tarama → manifest
│   ├── EgeserBackupArchiver.php         2) Batch ZIP (addFile), parçalama, çökme koruması
│   ├── EgeserBackupVerifier.php         3) CHECKCONS + numFiles + SHA-256, sonlandırma
│   ├── EgeserBackupRepository.php       Tamamlanan yedekler: listele/indir/sil/temizle
│   ├── EgeserBackupManager.php          İş orkestrasyonu (başlat/adım/iptal/durum)
│   └── EgeserBackupLogger.php           Modül logu
├── controllers/admin/AdminEgeserBackupController.php   Sayfa + JSON API + güvenli indirme
├── views/templates/admin/page.tpl
├── views/js/admin.js
├── views/css/admin.css
└── translations/
```

## 15. AJAX API

Tek uç nokta, işlem whitelist'i ile:
`index.php?controller=AdminEgeserBackup&token=…&ajax=1&action=backupApi&op=<işlem>`

| `op` | Yöntem | Açıklama |
|---|---|---|
| `status` | POST | Aktif iş durumu |
| `scan` | POST | Yalnızca tarama başlatır |
| `startBackup` | POST | Tarama + yedek başlatır; taranmış işte arşivlemeyi başlatır (`confirm=1` disk uyarısını onaylar) |
| `processBatch` | POST | Bir adım (tarama/arşiv/doğrulama) çalıştırır |
| `cancel` | POST | İptal |
| `deleteBackup` | POST | `backup=<id>` siler |
| `cleanup` | POST | Eski yedekleri ve sahipsiz iş klasörlerini temizler |
| `download` | GET | `backup=<id>&part=<n>` veya `backup=<id>&report=1` |

Yanıt biçimi her zaman: `{"success": true|false, "message": "", "data": {}}`
