# Egeser Prefabrik — Denetim "Bugün" Düzeltmeleri

`docs/egeser-prefabrik-denetim-raporu.md` raporundaki ilk aşama kod düzeltmeleri.
`files/` altındaki dosyalar sunucudaki `public_html/` ile aynı yol yapısındadır; değişiklikleri görmek için bu klasörün git geçmişine bakın (ilk commit orijinal yedek, sonraki commit düzeltmeler).

## Değişen dosyalar

| Dosya | Değişiklik |
|---|---|
| `catalog/view/theme/egeser/template/common/home.tpl` | Sayaçlar HTML'de `0` yerine gerçek değerle (8+, 42 M², 4+, 233+) geliyor; JS animasyonu aynen çalışır. Hero alanındaki "Ana proje görseli… otomatik kullanılır" taslak metni kaldırıldı. |
| `catalog/controller/product/product.php` | `og:image` / `twitter:image` artık logo değil ürün görseli (1200×630). |
| `catalog/controller/product/category.php` | Kategori görseli varsa `og:image` olarak kullanılır. Fiyat, oylama ve ürün kodu sıralama seçenekleri kaldırıldı (Varsayılan ve Ad A-Z / Z-A kaldı). |
| `catalog/view/theme/egeser/template/common/footer.tpl` | WhatsApp linkine hazır mesaj eklendi. |
| `catalog/view/theme/egeser/template/information/contact.tpl` | 4 WhatsApp linkine hazır mesaj eklendi. |

## Kurulum

1. Sunucuda bu 5 dosyanın yedeğini alın.
2. `files/` altındaki dosyaları aynı yollarla `public_html/` altına yükleyin.
3. Admin → Ana Sayfa'daki mavi dişli (Geliştirici Ayarları) → tema ve SASS önbelleğini temizleyin; Eklentiler → Modifikasyonlar → **Yenile**.
4. Kontrol: ana sayfa kaynak kodunda (Ctrl+U) `eh12-stats__num` değerleri gerçek rakamları göstermeli; bir ürün linkini https://developers.facebook.com/tools/debug/ ile test edin.

## Kod dışı (panel/sunucu) adımlar

- **`opcache-temizle.php` dosyasını sunucudan silin.**
- **DB şifresini değiştirin** (cPanel → MySQL Databases) ve `config.php` + `admin/config.php` dosyalarını güncelleyin.
- `(0)` sayıları: Admin → Sistem → Ayarlar → Mağaza → Seçenekler → **Kategori Ürün Sayısı = Hayır**.
- 158 m² prefabrik ofis ürününün fiyatını (2.370.000 TL) bilinçli değilse 0 yapın.
