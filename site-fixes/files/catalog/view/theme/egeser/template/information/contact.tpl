<?php echo $header; ?>
<link rel="stylesheet" href="catalog/view/theme/egeser/stylesheet/egeser-contact-v1-1.css">

<?php $egc_showroom_img = defined('DIR_IMAGE') && is_file(DIR_IMAGE . 'catalog/egeser/hakkimizda/showroom.jpg') ? 'image/catalog/egeser/hakkimizda/showroom.jpg' : ''; ?>

<div class="egc">
  <div class="container">
    <ul class="breadcrumb egc-breadcrumb">
      <?php foreach ($breadcrumbs as $breadcrumb) { ?>
      <li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
      <?php } ?>
    </ul>

    <section class="egc-hero">
      <div class="egc-hero__main">
        <div class="egc-kicker">EGESER PREFABRİK</div>
        <h1>İletişim</h1>
        <p class="egc-lead">
          Prefabrik ev veya kurumsal yapı projeniz için bizimle iletişime geçin.
          İhtiyacınızı birlikte değerlendirerek doğru çözüm için size yardımcı olalım.
        </p>

        <div class="egc-actions">
          <a class="egc-btn egc-btn--primary" href="tel:05318866090">0531 886 60 90</a>
          <a class="egc-btn egc-btn--whatsapp" href="https://wa.me/<?php echo htmlspecialchars($egeser_whatsapp, ENT_QUOTES, 'UTF-8'); ?>" target="_blank" rel="noopener">WhatsApp</a>
        </div>

        <div class="egc-trust">
          <span>✓ Bireysel Prefabrik Ev</span>
          <span>✓ Kurumsal Yapılar</span>
          <span>✓ Proje Desteği</span>
        </div>
      </div>

      <aside class="egc-hero__side">
        <?php if ($egc_showroom_img) { ?>
        <div class="egc-hero__side-photo" style="background-image:url('<?php echo htmlspecialchars($egc_showroom_img, ENT_QUOTES, 'UTF-8'); ?>')"></div>
        <?php } ?>
        <span class="egc-hero__badge">SHOWROOM & İLETİŞİM</span>
        <div class="egc-hero__floatcard">
          <h2>Kemalpaşa / İzmir</h2>
          <p>
            Projenizi yüz yüze değerlendirmek, ürünleri yakından incelemek ve teknik
            detaylar hakkında bilgi almak için bizimle iletişime geçebilirsiniz.
          </p>
        </div>
      </aside>
    </section>

    <section class="egc-section">
      <div class="egc-contactcards">
        <a class="egc-contactcard egc-contactcard--dark" href="tel:05318866090">
          <small>TELEFON</small>
          <h3>0531 886 60 90</h3>
          <p>Satış, proje ve genel bilgi için arayabilirsiniz.</p>
        </a>

        <a class="egc-contactcard" href="https://wa.me/<?php echo htmlspecialchars($egeser_whatsapp, ENT_QUOTES, 'UTF-8'); ?>" target="_blank" rel="noopener">
          <small>WHATSAPP</small>
          <h3>Hızlı İletişim</h3>
          <p>Proje bilgilerinizi ve görsellerinizi WhatsApp üzerinden paylaşabilirsiniz.</p>
        </a>

        <div class="egc-contactcard">
          <small>SHOWROOM / ÜRETİM</small>
          <h3>Kemalpaşa / İzmir</h3>
          <p>Proje görüşmeleri ve ürün incelemeleri için ziyaret öncesinde iletişime geçmenizi öneririz.</p>
        </div>

        <a class="egc-contactcard" href="mailto:<?php echo htmlspecialchars($email_store, ENT_QUOTES, 'UTF-8'); ?>">
          <small>E-POSTA</small>
          <h3><?php echo htmlspecialchars($email_store, ENT_QUOTES, 'UTF-8'); ?></h3>
          <p>Kurumsal taleplerinizi ve proje dokümanlarınızı e-posta ile iletebilirsiniz.</p>
        </a>
      </div>
    </section>

    <section class="egc-section">
      <div class="egc-section__head">
        <div>
          <div class="egc-kicker">PROJE TÜRÜ</div>
          <h2>Size hangi konuda yardımcı olabiliriz?</h2>
        </div>
        <p>
          Bireysel ve kurumsal projelerin ihtiyaçları farklıdır. Talep türünüzü
          belirtmeniz ekibimizin daha hızlı yönlendirme yapmasını sağlar.
        </p>
      </div>

      <div class="egc-dual">
        <div class="egc-type">
          <div class="egc-kicker">BİREYSEL</div>
          <h3>Prefabrik Ev Projesi</h3>
          <p>Tek katlı, çift katlı veya özel plan prefabrik ev ihtiyaçları için.</p>
          <ul>
            <li>Yaklaşık m²</li>
            <li>Oda ihtiyacı</li>
            <li>Uygulama bölgesi</li>
            <li>Varsa özel plan beklentisi</li>
          </ul>
        </div>

        <div class="egc-type egc-type--dark">
          <div class="egc-kicker egc-kicker--gold">KURUMSAL</div>
          <h3>Kurumsal Yapı Projesi</h3>
          <p>Ofis, yatakhane, yemekhane, şantiye, sosyal tesis ve özel projeler için.</p>
          <ul>
            <li>Firma / proje bilgisi</li>
            <li>Yaklaşık m² veya kapasite</li>
            <li>Proje lokasyonu</li>
            <li>Teknik kapsam</li>
          </ul>
        </div>
      </div>
    </section>

    <section class="egc-section egc-location-section" id="konum">
      <div class="egc-location">
        <div class="egc-location__content">
          <span class="egc-loc-label">KONUM &amp; SHOWROOM</span>
          <h2>Egeser Prefabrik'e ulaşın.</h2>
          <p>Egeser Prefabrik showroom ve üretim tesisimizi ziyaret etmek için randevu oluşturabilirsiniz.</p>

          <div class="egc-location__details">
            <article>
              <small>ADRES / ÜRETİM</small>
              <strong>Çambel Mevkii, Kemalpaşa / İzmir</strong>
              <span>Showroom ve üretim lokasyonu</span>
            </article>
            <article>
              <small>TELEFON</small>
              <strong><a href="tel:05318866090">0531 886 60 90</a></strong>
              <span>Satış ve proje danışmanlığı</span>
            </article>
            <article>
              <small>WHATSAPP</small>
              <strong><a href="https://wa.me/<?php echo htmlspecialchars($egeser_whatsapp, ENT_QUOTES, 'UTF-8'); ?>" target="_blank" rel="noopener">WhatsApp'tan yazın</a></strong>
              <span>Hızlı bilgi ve teklif talebi</span>
            </article>
            <article>
              <small>E-POSTA</small>
              <strong><a href="mailto:<?php echo htmlspecialchars($email_store, ENT_QUOTES, 'UTF-8'); ?>"><?php echo htmlspecialchars($email_store, ENT_QUOTES, 'UTF-8'); ?></a></strong>
              <span>Kurumsal iletişim ve doküman paylaşımı</span>
            </article>
          </div>

          <?php if (!empty($open)) { ?>
          <div class="egc-open">
            <small>ÇALIŞMA SAATLERİ</small>
            <div><?php echo $open; ?></div>
          </div>
          <?php } ?>

          <div class="egc-location__actions">
            <a class="egc-btn egc-btn--primary" href="/iletisim#iletisim-formu">Teklif Al</a>
            <a class="egc-btn egc-btn--ghost" href="tel:05318866090">Telefonla Ara</a>
            <a class="egc-btn egc-btn--ghost" href="https://www.google.com/maps?q=38.44988554328141,27.497831062110418" target="_blank" rel="noopener" data-eg-track="map_click" data-placement="contact">Haritada Aç</a>
          </div>
        </div>

        <div class="egc-map" aria-label="Egeser Prefabrik Kemalpaşa İzmir haritası">
          <iframe
            title="Egeser Prefabrik Showroom - Kemalpaşa/İzmir konumu"
            src="https://www.google.com/maps?q=38.44988554328141,27.497831062110418&amp;z=18&amp;output=embed"
            width="600"
            height="450"
            style="border:0"
            loading="lazy"
            referrerpolicy="no-referrer-when-downgrade"
            allowfullscreen></iframe>
          <div class="egc-map__caption">
            <span>Kemalpaşa / İzmir</span>
            <strong>Showroom &amp; Üretim</strong>
          </div>
        </div>
      </div>
    </section>

    <section class="egc-section" id="iletisim-formu">
      <div class="egc-formwrap">
        <div class="egc-formintro">
          <div class="egc-kicker">İLETİŞİM FORMU</div>
          <h2>Projenizi bize anlatın.</h2>
          <p>
            Yapı türünüzü, yaklaşık m² bilginizi ve uygulama bölgenizi mesajınıza
            eklerseniz ekibimiz talebinizi daha hızlı değerlendirebilir.
          </p>

          <div class="egc-tip">
            <small>HIZLI TEKLİF İÇİN</small>
            <strong>m² + yapı türü + proje yeri</strong>
            <span>bilgilerini paylaşmanız yeterli.</span>
          </div>
        </div>

        <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" class="egc-form">
          <input type="hidden" name="csrf_token" value="<?php echo htmlspecialchars($csrf_token, ENT_QUOTES, 'UTF-8'); ?>">
          <?php if ($error_csrf) { ?><span class="egc-error egc-error--block"><?php echo $error_csrf; ?></span><?php } ?>
          <?php if ($error_send) { ?><span class="egc-error egc-error--block"><?php echo $error_send; ?></span><?php } ?>
          <div class="egc-formgrid">
            <label>
              Ad Soyad *
              <input type="text" name="name" value="<?php echo htmlspecialchars($name, ENT_QUOTES, 'UTF-8'); ?>" required>
              <?php if ($error_name) { ?><span class="egc-error"><?php echo $error_name; ?></span><?php } ?>
            </label>

            <label>
              Telefon *
              <input type="tel" name="telephone" value="<?php echo htmlspecialchars($telephone, ENT_QUOTES, 'UTF-8'); ?>" required>
              <?php if ($error_telephone) { ?><span class="egc-error"><?php echo $error_telephone; ?></span><?php } ?>
            </label>

            <label>
              E-posta *
              <input type="email" name="email" value="<?php echo htmlspecialchars($email, ENT_QUOTES, 'UTF-8'); ?>" required>
              <?php if ($error_email) { ?><span class="egc-error"><?php echo $error_email; ?></span><?php } ?>
            </label>

            <label>
              Talep Türü
              <select name="project_type">
                <option value="">Seçiniz</option>
                <option value="Bireysel Prefabrik Ev" <?php echo ($project_type == 'Bireysel Prefabrik Ev') ? 'selected' : ''; ?>>Bireysel Prefabrik Ev</option>
                <option value="Kurumsal Prefabrik Yapı" <?php echo ($project_type == 'Kurumsal Prefabrik Yapı') ? 'selected' : ''; ?>>Kurumsal Prefabrik Yapı</option>
                <option value="Teknik Bilgi" <?php echo ($project_type == 'Teknik Bilgi') ? 'selected' : ''; ?>>Teknik Bilgi</option>
                <option value="Diğer" <?php echo ($project_type == 'Diğer') ? 'selected' : ''; ?>>Diğer</option>
              </select>
            </label>

            <label class="egc-span2">
              Mesajınız *
              <textarea name="enquiry" rows="7" required><?php echo htmlspecialchars($enquiry, ENT_QUOTES, 'UTF-8'); ?></textarea>
              <?php if ($error_enquiry) { ?><span class="egc-error"><?php echo $error_enquiry; ?></span><?php } ?>
            </label>
          </div>

          <div class="egc-hp" aria-hidden="true">
            <label>Website<input type="text" name="website" value="" tabindex="-1" autocomplete="off"></label>
          </div>

          <?php echo $captcha; ?>

          <label class="egc-check">
            <input type="checkbox" name="kvkk" value="1" <?php echo !empty($kvkk) ? 'checked' : ''; ?> required>
            <span>İletişim bilgilerimin talebimin yanıtlanması amacıyla işlenmesini <a href="/kvkk-aydinlatma-metni" target="_blank" rel="noopener">KVKK Aydınlatma Metni</a> kapsamında kabul ediyorum. *</span>
          </label>
          <?php if ($error_kvkk) { ?><span class="egc-error egc-error--block"><?php echo $error_kvkk; ?></span><?php } ?>

          <button type="submit" class="egc-btn egc-btn--primary egc-submit">Mesajımı Gönder</button>
        </form>
      </div>
    </section>

    <section class="egc-section">
      <div class="egc-section__head">
        <div>
          <div class="egc-kicker">SIK SORULAN SORULAR</div>
          <h2>İletişim öncesinde merak edilenler.</h2>
        </div>
        <p>Proje görüşmesini daha hızlı ilerletmek için temel bilgiler.</p>
      </div>

      <div class="egc-faq">
        <details>
          <summary>Teklif almak için hangi bilgileri paylaşmalıyım?</summary>
          <p>Yapı türü, yaklaşık m², uygulama bölgesi ve varsa oda/kapasite ihtiyacınızı paylaşmanız ilk değerlendirme için yeterlidir.</p>
        </details>
        <details>
          <summary>Showroom ziyareti için randevu gerekli mi?</summary>
          <p>Zorunlu olmamakla birlikte doğru ekip arkadaşımızın size zaman ayırabilmesi için ziyaret öncesi telefon veya WhatsApp üzerinden randevu oluşturmanızı öneririz.</p>
        </details>
        <details>
          <summary>Kurumsal projeler için teknik doküman gönderebilir miyim?</summary>
          <p>Evet. Proje planı, ihtiyaç listesi ve teknik dokümanlarınızı e-posta veya WhatsApp üzerinden paylaşabilirsiniz.</p>
        </details>
        <details>
          <summary>İzmir dışındaki projeler için iletişime geçebilir miyim?</summary>
          <p>Evet. Proje lokasyonu, sevkiyat ve montaj koşullarına göre Ege Bölgesi ve çevre illerde uygulama değerlendirilebilir.</p>
        </details>
      </div>
      <p style="margin:18px 0 0"><a href="/sss" style="font-weight:800;font-size:13px;color:#181818;text-decoration:none;border-bottom:2px solid #ef1f28;padding-bottom:2px">Tüm soruları görüntüleyin →</a></p>
    </section>

    <section class="egc-final">
      <div>
        <div class="egc-kicker egc-kicker--gold">EGESER PREFABRİK</div>
        <h2>Projeniz için ilk adımı bugün atın.</h2>
        <p>Telefon, WhatsApp veya iletişim formu üzerinden bize ulaşabilirsiniz.</p>
      </div>
      <div class="egc-final__actions">
        <a class="egc-btn egc-btn--primary" href="tel:05318866090">Hemen Ara</a>
        <a class="egc-btn egc-btn--light" href="https://wa.me/<?php echo htmlspecialchars($egeser_whatsapp, ENT_QUOTES, 'UTF-8'); ?>" target="_blank" rel="noopener">WhatsApp</a>
      </div>
    </section>
  </div>
</div>



<?php
$eg_contact_url = html_entity_decode($action, ENT_QUOTES, 'UTF-8');
$eg_contact_base = preg_replace('#/iletisim(?:\\?.*)?$#', '', $eg_contact_url);
$eg_contact_description = 'İzmir Kemalpaşa’daki Egeser Prefabrik ile prefabrik ev, kurumsal yapı, proje, üretim, sevkiyat ve montaj talepleriniz için iletişime geçin.';
?>
<script type="application/ld+json"><?php
$eg_contact_schema = array(
  '@context' => 'https://schema.org',
  '@type' => 'ContactPage',
  'name' => 'İletişim | Egeser Prefabrik İzmir',
  'url' => $eg_contact_url,
  'description' => $eg_contact_description,
  'about' => array('@id' => rtrim($eg_contact_base, '/') . '/#organization')
);
echo json_encode($eg_contact_schema, JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES|JSON_HEX_TAG|JSON_HEX_AMP|JSON_HEX_APOS|JSON_HEX_QUOT);
?></script>
<script type="application/ld+json"><?php
$eg_contact_bc = array(); $eg_contact_pos = 1;
foreach ($breadcrumbs as $eg_bc) {
  $eg_bc_url = html_entity_decode($eg_bc['href'], ENT_QUOTES, 'UTF-8');
  if ($eg_bc_url === '/') {
    $eg_bc_url = rtrim($eg_contact_base, '/') . '/';
  } elseif (strpos($eg_bc_url, '/') === 0) {
    $eg_bc_url = rtrim($eg_contact_base, '/') . $eg_bc_url;
  }
  $eg_contact_bc[] = array('@type'=>'ListItem','position'=>$eg_contact_pos++,'name'=>trim(strip_tags($eg_bc['text'])),'item'=>$eg_bc_url);
}
echo json_encode(array('@context'=>'https://schema.org','@type'=>'BreadcrumbList','itemListElement'=>$eg_contact_bc), JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES|JSON_HEX_TAG|JSON_HEX_AMP|JSON_HEX_APOS|JSON_HEX_QUOT);
?></script>
<script type="application/ld+json"><?php
$eg_contact_faq = array(
 array('@type'=>'Question','name'=>'Teklif almak için hangi bilgileri paylaşmalıyım?','acceptedAnswer'=>array('@type'=>'Answer','text'=>'Yapı türü, yaklaşık m², uygulama bölgesi ve varsa oda veya kapasite ihtiyacınızı paylaşmanız ilk değerlendirme için yeterlidir.')),
 array('@type'=>'Question','name'=>'Showroom ziyareti için randevu gerekli mi?','acceptedAnswer'=>array('@type'=>'Answer','text'=>'Zorunlu olmamakla birlikte doğru ekip arkadaşımızın size zaman ayırabilmesi için ziyaret öncesi telefon veya WhatsApp üzerinden randevu oluşturmanız önerilir.')),
 array('@type'=>'Question','name'=>'Kurumsal projeler için teknik doküman gönderebilir miyim?','acceptedAnswer'=>array('@type'=>'Answer','text'=>'Evet. Proje planı, ihtiyaç listesi ve teknik dokümanlar e-posta veya WhatsApp üzerinden paylaşılabilir.')),
 array('@type'=>'Question','name'=>'İzmir dışındaki projeler için iletişime geçebilir miyim?','acceptedAnswer'=>array('@type'=>'Answer','text'=>'Evet. Proje lokasyonu, sevkiyat ve montaj koşullarına göre Ege Bölgesi ve çevre illerde uygulama değerlendirilebilir.'))
);
echo json_encode(array('@context'=>'https://schema.org','@type'=>'FAQPage','mainEntity'=>$eg_contact_faq), JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES|JSON_HEX_TAG|JSON_HEX_AMP|JSON_HEX_APOS|JSON_HEX_QUOT);
?></script>

<?php echo $footer; ?>
