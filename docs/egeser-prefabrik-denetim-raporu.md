# Egeser Prefabrik — Bağımsız Denetim ve Rapor Doğrulama

**Tarih:** 30.10.2026
**Kapsam:** www.egeserprefabrik.com.tr (canlı site) + iletilen site yedeği (OpenCart 2.3.0.2, `egeser` teması)
**Yöntem:** Yedekteki kaynak kodun incelenmesi; canlı sitede 14 ana sayfa, 50 ürün sayfası ve sitemap'teki 91 URL'nin taranması; farklı bot kimlikleriyle erişim testleri; güvenlik uç nokta kontrolleri.

**Genel SEO Skoru: 74 / 100**
Teknik SEO temeli iyi: canonical, tekil H1, OG/Twitter etiketleri, JSON-LD, sitemap ve llms.txt mevcut. Puanı düşüren başlıca sorunlar güven sinyalleri, eksik sosyal ve ürün şemaları ile bazı arama motoru botlarına verilen 406 hatası.

---

## 1. İletilen Analiz Raporunun Doğrulaması

| # | Rapordaki iddia | Sonuç | Kanıt / Not |
|---|---|---|---|
| 1 | Sayaçlar `0+` görünüyor | ✅ **Doğru** | `common/home.tpl:1590-1593`: HTML'de sayaç değeri `0` yazıyor; gerçek değer yalnızca JS çalıştığında ve bölüm ekrana girdiğinde (IntersectionObserver) yazılıyor. Botlar, ekran görüntüsü araçları ve JS'siz ziyaretçiler `0` görüyor. **Not:** Rapordaki örnek rakamlar (`15+`, `50.000+`) yanlış. Sitedeki gerçek değerler **8+ yıl, 42 m²/gün, 4+ kurulum/ay, 233+ Google yorumu**. |
| 2 | "Ana proje görseli… otomatik kullanılır" taslak metni canlıda | ✅ **Doğru** | `common/home.tpl:1565`. Hero slider JS'i bu yer tutucuyu sonradan gizliyor, ancak metin canlı HTML'de duruyor (Google'ın okuduğu kaynak bu). |
| 3 | Kurumsal kategoriler `(0)` görünüyor | ✅ **Doğru** | `/prefabrik-yapilar` sayfasındaki alt kategori kartları: Yatakhane (0), Şantiye (0), Sosyal Tesis (0), Özel Proje (0). Bu 4 boş kategori **sitemap'te de yer alıyor** (rapor bunu atlamış; zayıf içerik riski). |
| 4 | "PROJE BAZLI" fiyat varken fiyata göre sıralama var | ✅ **Doğru, eksik** | `controller/product/category.php:310-318`. Bunlara ek olarak **"Yüksek/Düşük Oylama"** ve **"Ürün Kodu"** sıralamaları da anlamsız, çünkü sitede yorum yok. |
| 5 | Kat planı / kroki eksik | ❌ **Büyük ölçüde yanlış** | 50 ürün sayfasının **50'sinde** kat planı modülü (`egeser_floorplan`) ve plan görselleri var. Yalnızca `142-m2-prefabrik-ev` ve `237-m2-prefabrik-yemekhane` sayfalarında plan sayısı diğerlerine göre az (1 plan). Kategori kartlarında plan önizlemesi yok; bu bir **fırsat** olarak değerlendirilebilir. |
| 6 | Kurucu ortak hikayesi var | ✅ Doğru | Hakkımızda sayfasında var. |
| 7 | TSE/ISO vb. belge yok | ✅ **Doğru** | Hiçbir sayfada belge veya rozet bulunmuyor. |
| 8 | Harita butonu belirginleştirilmeli | ⚠️ **Kısmen** | İletişim sayfasında Google Maps embed ve koordinatlı link zaten var. Öneri yalnızca görünürlük açısından geçerli. |
| 9 | Honeypot (`Website`) alanı görünüyor olabilir | ✅ **Sorun yok** | `.egc-hp` / `.eg-hp-field` ekran dışına konumlanmış, `tabindex=-1` ve `autocomplete=off` ayarlı. Sunucu tarafı (`egeser_lead.php:53`) doluysa isteği reddediyor. Küçük bir öneri: `contact.tpl:238`'deki görünür `Website` etiketi bazı autofill araçlarını tetikleyebilir. Ad `hp_extra` gibi anlamsız bir şeyle değiştirilebilir. |
| 10 | **Googlebot'a 403 (WAF)**, sitemap erişilemiyor | ❌ **Yanlış (Google için)** / ⚠️ **Başka botlar için gerçek sorun var** | Googlebot (masaüstü/mobil), GPTBot, ClaudeBot, PerplexityBot ve facebookexternalhit için `/`, `/sitemap.xml`, `/projelerimiz`, `/blog` adreslerinin hepsi **200** döndü. Sitemap geçerli; 91 URL'nin tamamı 200. **Ancak Bingbot, YandexBot ve AhrefsBot kimliğine `406 Not Acceptable` dönüyor** (bkz. Bölüm 2). |
| 11 | Hizmet bölgesi metinleri kopya | ⚠️ **Kısmen doğru** | İzmir ve Manisa sayfaları karşılaştırıldığında, şehir adı çıkarıldıktan sonra cümlelerin **~%37'si birebir aynı**. Kabul edilebilir sınırda; özgün yerel içerik yine de artırılmalı. |
| 12 | Alt etiketleri eksik | ❌ **Yanlış** | İncelenen tüm sayfalarda `alt` niteliği eksik `<img>` yok. Her sayfada yalnızca 1 dekoratif boş `alt=""` var, bu doğru kullanım. **WebP kullanımı ise sıfır** (rapordaki bu kısım doğru). |
| 13 | WhatsApp hazır mesaj şablonu yok | ⚠️ **Kısmen** | Sabit header butonu, ana sayfa ve ürün sayfaları **zaten hazır mesajla** açılıyor. Hazır mesaj olmayanlar: `footer.tpl:125` ve `contact.tpl:25, 58, 137, 292`. |
| 14 | "EGE-101…EGE-200 serisi, ~50 model" | ✅ Doğru | 50 ürün; SKU'lar EGE-101…EGE-205 ve PRF-OFIS/YEMEKHANE-xxM2. |

**Sonuç:** Raporun "acil" bölümündeki 3 madde (sayaç, taslak metin, `(0)` kategoriler) doğru ve öncelikli. "Kritik" olarak işaretlenen 403/WAF bulgusu Google için **geçersiz**. Kat planı ve alt etiketi iddiaları da büyük ölçüde geçersiz. Raporun gözden kaçırdığı daha önemli sorunlar aşağıda listelenmiştir.

---

## 2. Raporun Kaçırdığı Bulgular

### 🔴 Kritik

1. **Yedek dosyada düz metin veritabanı şifresi.**
   `config.php` ve `admin/config.php` gerçek DB kullanıcı adı ve şifresini içeriyor; bu yedek şu an dosya olarak paylaşılmış durumda. Web üzerinden erişim `.htaccess` ile engellenmiş (403 doğrulandı), yani canlıda sızıntı yok. Ancak yedek ZIP'i alan herkes şifreyi görebilir.
   **Aksiyon:** cPanel → MySQL Databases bölümünden `egeserp1_egeserp` şifresini değiştirin ve iki config dosyasını güncelleyin. Yedekleri bundan sonra şifresiz paylaşın (config dosyalarını hariç tutun ya da maskeleyin). Aynı şifre başka bir yerde de kullanılıyorsa orada da değiştirin.

2. **`/opcache-temizle.php` herkese açık.**
   Herhangi biri bu adresi çağırarak sunucunun PHP önbelleğini sıfırlayabiliyor; tekrarlanırsa siteyi yavaşlatan basit bir saldırı vektörü olur. Dosyanın kendi içindeki notta da "işlem bitince SİL" yazıyor. (Bu denetimdeki test isteği önbelleği bir kez temizledi. Zararsız bir işlemdir, önbellek kendiliğinden yeniden dolar.)
   **Aksiyon:** Dosyayı sunucudan silin.

3. **Bingbot, YandexBot ve AhrefsBot kimliklerine `406 Not Acceptable`.**
   `/` ve `/sitemap.xml` 406 dönüyor, `robots.txt` ise 200. Hata sayfası hosting firmasının (Imunify360/ModSecurity tipi) WAF sayfası. Testler Microsoft veya Yandex IP'lerinden yapılmadığı için WAF yalnızca **sahte bot** kimliklerini engelliyor da olabilir. Yine de Googlebot kimliği aynı test ortamından geçerken Bing'in reddedilmesi, kuralın UA bazlı çalıştığına işaret ediyor. Bing; ChatGPT Search ve Copilot gibi yapay zekâ aramalarının da veri kaynağı.
   **Aksiyon:** Bing Webmaster Tools → *URL Inspection → Live URL* ile test edin. 406 alırsanız hosting desteğinden ModSecurity/Imunify "bad bot" kuralının doğrulanmış Bing ve Yandex IP'leri için devre dışı bırakılmasını isteyin.

### 🟠 Yüksek

4. **Ürün ve kategori sayfalarında `og:image` = logo.**
   50 ürün sayfasının tamamında WhatsApp, Facebook ve LinkedIn paylaşım önizlemesi ürün görseli yerine logoyu gösteriyor. Neden: `document->setImage()` yalnızca blogda çağrılıyor (`controller/common/header.php:99-100`). WhatsApp üzerinden satış yapan bir firma için bu doğrudan dönüşüm kaybı demek.

5. **Product şemasında `offers` / `aggregateRating` / `review` yok.**
   50 ürünün 49'unda Product JSON-LD var ama bu üç alanın hiçbiri yok. Google bu durumda *"Ürün snippet'leri: offers, review veya aggregateRating belirtilmeli"* hatası verir ve zengin sonuç göstermez.
   **Aksiyon:** Ya Product yerine `Service`/`Offer` içermeyen bir `Product` + `brand` + gerçek `aggregateRating` (Google'daki 233 yorum işletmeye ait olduğundan **LocalBusiness** üzerinde) kullanın, ya da "başlangıç fiyatı" belirleyip `offers.priceSpecification` / `AggregateOffer.lowPrice` ekleyin. Rapordaki "m² başlangıç fiyatı" önerisi uygulanırsa bu sorun da çözülür.

6. **Fiyat tutarsızlığı:** Yalnızca `158-m2-prefabrik-ofis` sayfasında **2.370.000,00 TL** fiyat görünüyor ve şemaya da yansıyor. Diğer 49 ürün "PROJE BAZLI". Bu fiyat bilinçli değilse admin panelinden 0 yapılmalı; bilinçliyse diğerleriyle tutarlı bir politika belirlenmeli.

7. **Başlık ve açıklama ile içerik çelişkisi.** Ofis ve yemekhane ürünlerinin title'larında "**Modelleri ve Fiyatları**", açıklamalarında ise "*uygun fiyatla hemen sipariş verin!*" ifadesi var, oysa sayfada fiyat yok. Ayrıca 17 ürün sayfasının title'ı 60 karakteri aşıyor (62-68). Örnek: `60-m2-prefabrik-yemekhane`, `147-m2-prefabrik-ofis`, `159-m2-prefabrik-yemekhane`.

8. **Yazılım ömrü:** OpenCart **2.3.0.2** (2016), `php.ini` notuna göre **PHP 7.2** ve **jQuery 2.1.1**. Üçü de güvenlik desteği bitmiş sürümler. Kısa vadede PHP 7.4/8.x uyumluluğu test edilmeli; orta vadede platform güncellemesi planlanmalı.

9. **Yönetim paneli varsayılan `/admin/` yolunda ve herkese açık.** Brute-force denemelerine karşı cPanel'den dizine IP kısıtı veya ek HTTP Basic Auth eklenmeli.

### 🟡 Orta

10. **Boş kategoriler sitemap'te.** 4 boş kurumsal kategori sitemap'te listeleniyor ve "Bu kategoride henüz yayınlanmış ürün bulunmuyor" metniyle indekslenebilir. Ürün eklenene kadar `noindex` verilmeli ya da sitemap'ten çıkarılmalı.
11. **H1 ve şemada kelime birleşmesi.** Görsel olarak satır kırılan başlıklarda boşluk eksik olduğu için metin bitişik okunuyor: "Hakkımızda**Egeser** Prefabrik", "Kurumsal Prefabrik**Yapı** Çözümleri". Product şeması açıklamasında da aynı durum var: "kullanım özeti**122** m²…". `<br>` / `<span>` öncesine boşluk eklenmeli; şema açıklaması oluşturulurken `strip_tags` öncesi blok etiketleri boşlukla değiştirilmeli.
12. **Ana sayfa meta description 181 karakter** (önerilen ≤160). 80 m² ve 122 m² gibi bazı ürün açıklamaları da 170-186 karakter.
13. **Görsel formatı ve boyutları.** WebP yok. Kategori sayfalarında 22 görselin 20'sinde `width/height` yok (CLS riski). 480×360 küçük görseller 40-55 KB JPEG; WebP ile ~%30-40 tasarruf mümkün.
14. **Render performansı.** Ana sayfa HTML'i 170 KB, bunun **~86 KB'ı inline CSS**. Ayrıca 9 ayrı CSS dosyası render-blocking yükleniyor (Bootstrap 3, Font Awesome 4, default + 6 tema dosyası). TTFB ~0,76 sn. Tema CSS'leri birleştirilmeli ve kritik CSS ayrılmalı. Font Awesome yalnızca birkaç ikon için kullanılıyorsa SVG'ye geçilmeli.
15. **Kullanılmayan e-ticaret sayfaları açık.** `account/register`, `checkout/cart` ve `product/search` 200 dönüyor; arama sayfasında `noindex` yok. Lead odaklı bir sitede bu sayfalar `noindex` yapılmalı, kayıt ve sepet ise kapatılmalı.
16. **`bakim.html` kökte duruyor.** `noindex` etiketi var, sorun değil; kullanılmıyorsa kaldırılabilir.
17. **Hakkımızda ve Kurumsal sayfalarında BreadcrumbList şeması yok** (diğer sayfalarda var).

### ✅ İyi Durumda Olanlar

- Tüm sayfalarda tekil ve anlamlı `<h1>`, doğru canonical, OG ve Twitter Card etiketleri var.
- Organization, LocalBusiness, WebSite, FAQPage, BreadcrumbList, ItemList, Blog ve CollectionPage şemaları var.
- Dinamik `sitemap.xml` (91 URL, `lastmod` dolu) ve `robots.txt` doğru; `llms.txt` var (yapay zekâ görünürlüğü için iyi).
- HTTPS + www yönlendirmesi, HSTS, X-Frame-Options, nosniff ve Referrer-Policy başlıkları aktif. `.sql`, `.zip`, config, log ve `.txt` dosyalarına erişim engelli (403 doğrulandı).
- Teklif formunda CSRF nonce, IP bazlı rate-limit (5 istek / 10 dk), honeypot ve SQL escape kullanılıyor. Cron uç noktası token korumalı.
- Çerez onayı olmadan Google Analytics yüklenmiyor (KVKK uyumlu yaklaşım).
- Ürün sayfalarında kat planı modülü ve oda bazlı m² dökümü var; bu, rakiplere göre güçlü bir yön.

---

## 3. Kod Düzeltme Reçeteleri

### 3.1 Sayaçlar — HTML'e gerçek değeri yaz (`common/home.tpl:1590-1593`)

`>0</span>` yerine gerçek değeri yazın:

```html
<span class="eh12-stats__num" data-eh12-count="8" data-eh12-suffix="+">8+</span>
<span class="eh12-stats__num" data-eh12-count="42" data-eh12-suffix=" M²">42 M²</span>
<span class="eh12-stats__num" data-eh12-count="4" data-eh12-suffix="+">4+</span>
<span class="eh12-stats__num" data-eh12-count="233" data-eh12-suffix="+">233+</span>
```

JS animasyonu sıfırdan başladığı için ek değişiklik gerekmez. Animasyon başlamadan önce gerçek değer görünür, sonra 0'dan sayarak tekrar gerçek değere ulaşır. Bu kısa sıfırlanmayı da önlemek için yalnızca IntersectionObserver tetiklendiğinde metni `0`'a çeken satırı ekleyebilirsiniz.

### 3.2 Taslak metni kaldır (`common/home.tpl:1565`)

```php
<div class="eh12-hero-media__placeholder" aria-hidden="true"></div>
```

Slider JS'i hedefi `.eh12-hero-media` sınıfıyla bulduğu için metin tabanlı fallback'e gerek yok (`egeser_hero_slider.tpl:35`).

### 3.3 `(0)` sayılarını kaldır

Admin → Sistem → Ayarlar → Seçenekler → **"Kategori Ürün Sayısı" = Hayır**. Kod değişikliği gerekmez; `config_product_count` ayarı `product/category.php:214` ve `module/category.php:45,58` dosyalarındaki sayıları kapatır. Boş kategorileri tamamen gizlemek için ilgili kategorileri pasife alın.

### 3.4 Sıralama seçenekleri (`controller/product/category.php` ~300-345)

`p.price`, `rating` ve `p.model` bloklarını kaldırın; yerine m² sıralaması (m² değeri ürün adında veya bir özellikte tutuluyorsa `p.length`/özel alan) ekleyin. En pratik yöntem: `sort_order` alanına m² değerini girip "Varsayılan" sıralamayı m²'ye göre yapmak.

### 3.5 Ürün sayfası `og:image` (`controller/product/product.php`)

`$data['popup']` atandıktan sonra (satır ~346):

```php
if ($product_info['image']) {
    $this->document->setImage($this->model_tool_image->resize($product_info['image'], 1200, 630));
}
```

Kategori sayfası (`product/category.php`) için de `$category_info['image']` ile aynısı yapılabilir.

### 3.6 WhatsApp hazır mesajı (`footer.tpl:125`, `contact.tpl:25,58,137,292`)

```php
href="https://wa.me/<?php echo htmlspecialchars($egeser_whatsapp, ENT_QUOTES, 'UTF-8'); ?>?text=<?php echo rawurlencode('Merhaba Egeser Prefabrik, arsam için prefabrik yapı modelleri ve fiyatları hakkında bilgi almak istiyorum.'); ?>"
```

### 3.7 Sunucu

- `opcache-temizle.php` → **silin**.
- DB şifresi → **değiştirin** (cPanel → MySQL Databases), ardından `config.php` ve `admin/config.php` dosyalarını güncelleyin.
- `/admin` → cPanel *Directory Privacy* ile şifre ya da IP kısıtı ekleyin.

---

## 4. Önceliklendirilmiş Aksiyon Planı

### Bugün (≤1 saat)
- [ ] DB şifresini değiştir; config dosyalarını güncelle
- [ ] `opcache-temizle.php` dosyasını sil
- [ ] Sayaç HTML değerlerini gerçek rakamlarla doldur (3.1)
- [ ] Taslak metni kaldır (3.2)
- [ ] "Kategori Ürün Sayısı" ayarını kapat (3.3)

### Bu hafta
- [ ] Bing Webmaster Tools'ta canlı URL testi; 406 alınırsa hosting firmasıyla WAF kuralını düzelt
- [ ] Ürün/kategori `og:image` düzeltmesi (3.5)
- [ ] 158 m² ofis fiyatını netleştir (0 yap veya fiyat politikası belirle)
- [ ] Fiyat/oylama/ürün kodu sıralamalarını kaldır (3.4)
- [ ] Boş 4 kategoriyi `noindex` yap / sitemap'ten çıkar ya da pasife al
- [ ] WhatsApp linklerine hazır mesaj (3.6)
- [ ] `/admin` dizinine ek koruma

### 2-4 hafta
- [ ] Product şeması stratejisi: başlangıç fiyatı + `AggregateOffer` veya LocalBusiness `aggregateRating` (233 Google yorumu)
- [ ] Ofis ve yemekhane title/description metinlerini "fiyat" vaadinden arındır; ≤60/≤160 karaktere indir
- [ ] H1 ve şemadaki bitişik kelime hatalarını düzelt
- [ ] Görselleri WebP'ye çevir ve kategori kartlarına `width/height` ekle
- [ ] CSS birleştirme ve kritik CSS ayrıştırma
- [ ] `account/register`, `checkout/cart`, `product/search` → `noindex` / kapat

### 1-3 ay (rapordaki içerik önerileriyle birlikte)
- [ ] Hakkımızda: kurucu portreleri, fabrika fotoğrafları, belge rozetleri (TSE/ISO/Sanayi Sicil)
- [ ] Teslim edilen projeler galerisi ve video referanslar
- [ ] Şehir sayfalarına özgün yerel içerik (ortak cümle oranını %37'den aşağı çek)
- [ ] Kategori kartlarına küçük kat planı önizlemesi
- [ ] PHP 8.x uyumluluk testi; OpenCart platform güncelleme yol haritası
