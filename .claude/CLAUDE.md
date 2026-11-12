# Site profili — Egeser Konteyner

- **Site:** https://www.egeserkonteyner.com
- **Altyapı:** PrestaShop
- **Konu:** Yalnızca konteyner yapılar
- **Konum:** İzmir — üretim; teslimat Türkiye geneli
- **Dönüşüm hedefi:** "Fiyat Teklifi Al" (WhatsApp), hızlı teklif aracı, telefon

Bu repoda sitenin kaynak kodu yok (yalnızca `egeserbackup` yedekleme modülü var).
SEO denetimleri canlı site adresi üzerinden yapılır; site dosyası gereken işler için
kullanıcıdan erişim iste.

Egeser'in iki ayrı sitesi vardır; kardeş site https://www.egeserprefabrik.com.tr (yalnızca prefabrik, OpenCart). Aşağıdaki
"Ortak kurallar" iki sitenin reposunda da aynıdır: birini değiştirirsen diğerini de
güncelle.

## Bu sitenin hedefi
Konteyner aramalarında (yaşam, ofis, şantiye, WC/duş, kabin, demonte) üretici
olarak görünür olmak.

## Hedef sayfa yapısı
- Ana sayfa → "İzmir konteyner üreticisi / konteyner fiyatları"
- Yaşam konteynerleri / konteyner ev / modüler ev
- Ofis ve şantiye konteynerleri
- WC / duş konteyneri, güvenlik kulübesi
- Demonte konteyner
- Referanslar, Blog, Kurumsal, İletişim

## Bu sitede YASAK
- "prefabrik ev / prefabrik yapı" kelimelerini hedefleyen yeni title, H1, meta,
  kategori, ürün veya blog.
- Yeni prefabrik ürünü ekleme.

## ÇAKIŞMA — ilk çözülecek iş
Site şu an prefabriği de hedefliyor ve egeserprefabrik.com.tr ile yarışıyor:

1. Ana sayfa title'ında "Prefabrik" geçiyor.
2. Ana sayfa H1'i "Konteyner & Prefabrik Yapılar" diyor.
3. Menüde "Prefabrik" kategorisi var (tek katlı ve dubleks prefabrik evler).
4. Öne çıkan modellerde 40, 64 ve 74 m² prefabrik evler var.
5. Meta keywords ve description'da prefabrik yapılar geçiyor.

İlk denetimde bunların tam listesini çıkar: prefabrik içerikli her URL, o URL'nin
Search Console'daki tıklama/gösterimi (veri varsa) ve egeserprefabrik.com.tr'deki
karşılığı. Sonra şu planı ONAYA sun, onay gelmeden uygulama:

- Title, H1, meta description ve keywords'ten "prefabrik" çıkarılır.
- Prefabrik kategori ve ürün sayfaları, prefabrik sitesindeki karşılık gelen
  sayfaya 301 ile yönlendirilir (karşılığı yoksa prefabrik ana kategorisine).
- Menüdeki "Prefabrik" öğesi, egeserprefabrik.com.tr'ye giden tek bir dış linke
  dönüşür.
- Ana sayfadaki prefabrik model kartları kaldırılır.

Not: Bu sayfalar şu an teklif getiriyor olabilir. Yönlendirmeden önce her
sayfanın trafik ve talep durumunu raporla.

## Denetim

    /seo audit https://www.egeserkonteyner.com

Öneri yazarken PrestaShop'ta nereden uygulanacağını da belirt (Back Office
ayarı, SEO & URL'ler, tema şablonu, modül).

---

# Ortak kurallar (iki site için aynı)

## Temel kural: iki site aynı aramada yarışmaz

Her arama niyeti tek bir siteye aittir. Bir sitede çalışırken diğer sitenin
kelimelerini hedefleyen title, H1, meta description, kategori, ürün, blog yazısı
veya şema ÖNERME ve YAZMA. Böyle bir fırsat görürsen "diğer siteye ait" diye
raporla, uygulama.

## Kelime sınır haritası

### egeserprefabrik.com.tr'ye ait
- prefabrik ev, prefabrik yapı, prefabrik ev modelleri, prefabrik ev fiyatları
- tek katlı prefabrik ev, çift katlı / dubleks prefabrik ev
- prefabrik ofis, prefabrik yatakhane, prefabrik yemekhane, prefabrik şantiye yapısı
- çelik konstrüksiyon / hafif çelik ev (prefabrik bağlamında)
- Bölgesel: İzmir / Manisa / Aydın / Uşak / Balıkesir / Muğla + "prefabrik"

### egeserkonteyner.com'a ait
- konteyner, konteyner fiyatları, konteyner üreticisi, sandviç panel konteyner
- yaşam konteyneri, konteyner ev, ofis konteyneri, şantiye konteyneri
- WC / duş konteyneri, güvenlik kulübesi / kabin
- demonte konteyner
- ölçü bazlı aramalar (ör. 300x700, 21 m² konteyner)
- Bölgesel: İzmir ve diğer iller + "konteyner"

### Gri alan (karar: aşağıdaki gibi, değiştirmeden önce sor)
- "şantiye": yapı prefabrikse prefabrik sitesi, konteynerse konteyner sitesi.
  Tek başına "şantiye binası" → prefabrik; "şantiye konteyneri" → konteyner.
- "ofis": "prefabrik ofis" → prefabrik; "ofis konteyneri" → konteyner.
- "modüler ev / modüler yapı": konteyner sitesi.
- "tiny house": henüz atanmadı. Hedeflemeden önce kullanıcıya sor.

## Marka ve bölge kelimeleri
- "Egeser" marka aramaları iki sitede de geçebilir, ama her zaman ürün kelimesiyle
  birlikte: "Egeser Prefabrik" / "Egeser Konteyner". Tek başına "Egeser" ile
  başlayan title yazma.
- İkisi de İzmir merkezli olduğu için "İzmir" iki sitede de kullanılır; ayrımı
  yanındaki ürün kelimesi yapar. "İzmir prefabrik" konteyner sitesinde,
  "İzmir konteyner" prefabrik sitesinde hedeflenmez.

## Siteler arası bağlantı
- Her site diğerine yalnızca şu yerlerden link verir: footer'da "Diğer markamız"
  bağlantısı ve Hakkımızda sayfası.
- Ürün ya da kategori sayfalarından karşı siteye anahtar kelimeli toplu link verme.
- İçerik kopyalama yok: aynı metin, aynı SSS, aynı blog yazısı iki sitede yer almaz.
  Ortak konular (ör. zemin hazırlığı, ruhsat) her site için kendi ürünü açısından
  ayrı yazılır.

## Şema (schema.org)
- Her site kendi Organization/LocalBusiness kaydını kendi adı ve kendi URL'siyle
  kullanır. İki site aynı işletmeye aitse bunu `parentOrganization` / `sameAs`
  ile belirt; aynı LocalBusiness bloğunu iki siteye kopyalama.
- Adres, telefon, çalışma saatleri gibi bilgileri uydurma; sitede yazanı kullan,
  emin değilsen sor.

## Çalışma şekli
- Sitede değişiklik gerektiren her öneri "öneri" olarak raporlanır; canlı sitede
  kullanıcı onayı olmadan değişiklik yapılmaz.
- Yönlendirme (301), sayfa silme, URL değiştirme, robots/noindex gibi geri alması
  zor işlemler her zaman önce onaya sunulur.
- Rakam uydurma: trafik, sıralama, arama hacmi gibi veriler yalnızca gerçek bir
  kaynaktan (Search Console, ölçüm aracı) geliyorsa yazılır.
- Denetim raporlarını oturumda teslim et; kullanıcı istemedikçe repoya commit etme.
