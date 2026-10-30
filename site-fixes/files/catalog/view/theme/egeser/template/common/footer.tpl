
<style id="egeser-shell-v1121-footer">
.eg112-footer--polished .eg112-footer__top{padding:64px 0 48px}
.eg112-footer--polished .eg112-footer__grid{grid-template-columns:1.25fr .82fr .98fr .95fr;gap:52px}
.eg112-footer--polished .eg112-footer__brand{font-size:29px;letter-spacing:.015em}
.eg112-footer--polished .eg112-footer__logo-wrap{display:flex;align-items:center;min-height:74px;margin-bottom:16px}
.eg112-footer--polished .eg112-footer__logo-img{display:block;width:205px;max-width:100%;height:auto;max-height:78px;object-fit:contain;object-position:left center}
.eg112-footer--polished .eg112-footer__brand.is-logo-ready{display:none}
@media(max-width:640px){
  .eg112-footer--polished .eg112-footer__logo-img{width:185px;max-height:70px}
}
.eg112-footer--polished .eg112-footer__about{font-size:13px;line-height:1.8;color:#b3b3b3}
.eg112-footer--polished h3{margin-bottom:16px;color:#f1f1f1;font-size:11px}
.eg112-footer--polished .eg112-footer__links{gap:10px}
.eg112-footer--polished .eg112-footer__links a{font-size:12.5px;line-height:1.45}
.eg112-footer--polished .eg112-footer__contact{gap:10px}
.eg112-footer--polished .eg112-footer__contact a,
.eg112-footer--polished .eg112-footer__contact span{font-size:12.5px}
.eg112-footer--polished .eg112-footer__cta{margin-top:20px;padding:18px;border-color:#373737;background:#212121}
.eg112-footer--polished .eg112-footer__cta strong{font-size:15px}
.eg112-footer--polished .eg112-footer__cta span{margin:5px 0 13px;font-size:11.5px;line-height:1.5}
.eg112-footer--polished .eg112-footer__cta a{padding:10px 13px}
.eg112-footer--polished .eg112-footer__bottom-inner{min-height:62px}
.eg112-footer--polished .eg112-footer__legal a,
.eg112-footer--polished .eg112-footer__legal span{color:#9a9a9a}
@media(max-width:920px){
  .eg112-footer--polished .eg112-footer__grid{grid-template-columns:1fr 1fr;gap:38px}
}
@media(max-width:640px){
  .eg112-footer--polished .eg112-footer__grid{grid-template-columns:1fr;gap:30px}
  .eg112-footer--polished .eg112-footer__top{padding:46px 0 34px}
}
</style>

<?php
$eg112_phone_footer = isset($eg112_phone) && $eg112_phone ? $eg112_phone : (!empty($telephone) ? $telephone : '0531 886 60 90');
$eg112_phone_href_footer = 'tel:' . preg_replace('/[^0-9+]/', '', $eg112_phone_footer);
$eg112_contact_footer = isset($eg112_contact) ? $eg112_contact : (!empty($egeser_url_iletisim) ? $egeser_url_iletisim : '/iletisim');
$eg112_instagram_footer = !empty($egeser_social_instagram) ? $egeser_social_instagram : 'https://www.instagram.com/egeserprefabrik/';
$eg112_facebook_footer = !empty($egeser_social_facebook) ? $egeser_social_facebook : 'https://www.facebook.com/egeserprefabrik';
$eg112_linkedin_footer = 'https://tr.linkedin.com/company/egeser-konteyner-prefabrik-san-ve-tic-ltd-şti';
?>
<footer class="eg112-footer eg112-footer--polished">
  <div class="eg-shell-container eg112-footer__top">
    <div class="eg112-footer__grid">
      <div>
        <div class="eg112-footer__logo-wrap" id="eg112-footer-logo" aria-label="Egeser Prefabrik"></div>
        <div class="eg112-footer__brand" id="eg112-footer-brand-fallback">EGESER <span>PREFABRİK</span></div>
        <p class="eg112-footer__about">Bireysel prefabrik ev ve kurumsal prefabrik yapı projelerinde; projelendirme, üretim, sevkiyat ve montaj süreçlerini bütüncül olarak ele alan yapı çözümleri.</p>
        <div class="eg112-footer__contact">
          <a href="<?php echo $eg112_phone_href_footer; ?>"><?php echo htmlspecialchars($eg112_phone_footer, ENT_QUOTES, 'UTF-8'); ?></a>
          <span>Kemalpaşa / İzmir</span>
          <a href="<?php echo $eg112_contact_footer; ?>">Showroom & İletişim</a>
        </div>
        <div class="eg112-footer__social" aria-label="Sosyal medya hesaplarımız">
          <a class="eg112-social-link eg112-social-link--instagram" href="<?php echo htmlspecialchars($eg112_instagram_footer, ENT_QUOTES, 'UTF-8'); ?>" target="_blank" rel="noopener noreferrer" aria-label="Egeser Prefabrik Instagram" title="Instagram">
            <i class="fa fa-instagram" aria-hidden="true"></i><span>Instagram</span>
          </a>
          <a class="eg112-social-link eg112-social-link--facebook" href="<?php echo htmlspecialchars($eg112_facebook_footer, ENT_QUOTES, 'UTF-8'); ?>" target="_blank" rel="noopener noreferrer" aria-label="Egeser Prefabrik Facebook" title="Facebook">
            <i class="fa fa-facebook" aria-hidden="true"></i><span>Facebook</span>
          </a>
          <a class="eg112-social-link eg112-social-link--linkedin" href="<?php echo htmlspecialchars($eg112_linkedin_footer, ENT_QUOTES, 'UTF-8'); ?>" target="_blank" rel="noopener noreferrer" aria-label="Egeser Prefabrik LinkedIn" title="LinkedIn">
            <i class="fa fa-linkedin" aria-hidden="true"></i><span>LinkedIn</span>
          </a>
        </div>
      </div>

      <div>
        <h3>Bireysel</h3>
        <div class="eg112-footer__links">
          <a href="<?php echo !empty($egeser_url_tek_katli) ? $egeser_url_tek_katli : '/tek-katli-prefabrik-evler'; ?>">Tek Katlı Prefabrik Evler</a>
          <a href="<?php echo !empty($egeser_url_cift_katli) ? $egeser_url_cift_katli : '/cift-katli-prefabrik-evler'; ?>">Çift Katlı Prefabrik Evler</a>
          <a href="<?php echo !empty($egeser_url_prefabrik_yapilar) ? $egeser_url_prefabrik_yapilar : '/prefabrik-yapilar'; ?>">Tüm Prefabrik Ev Modelleri</a>
        </div>
      </div>

      <div>
        <h3>Kurumsal Yapılar</h3>
        <div class="eg112-footer__links">
          <a href="<?php echo !empty($egeser_url_ofis_yonetim) ? $egeser_url_ofis_yonetim : '/prefabrik-ofis-ve-yonetim-binalari'; ?>">Ofis & Yönetim Binaları</a>
          <a href="<?php echo !empty($egeser_url_yatakhane) ? $egeser_url_yatakhane : '/prefabrik-yatakhane-binalari'; ?>">Yatakhane Binaları</a>
          <a href="<?php echo !empty($egeser_url_yemekhane) ? $egeser_url_yemekhane : '/prefabrik-yemekhane-binalari'; ?>">Yemekhane Binaları</a>
          <a href="<?php echo !empty($egeser_url_santiye) ? $egeser_url_santiye : '/prefabrik-santiye-yapilari'; ?>">Şantiye Yapıları</a>
          <a href="<?php echo !empty($egeser_url_sosyal_tesis) ? $egeser_url_sosyal_tesis : '/prefabrik-sosyal-tesis-yapilari'; ?>">Sosyal Tesis Yapıları</a>
          <a href="<?php echo !empty($egeser_url_ozel_proje) ? $egeser_url_ozel_proje : '/ozel-proje-prefabrik-yapilar'; ?>">Özel Proje Yapıları</a>
        </div>
      </div>

      <div>
        <h3>Kurumsal</h3>
        <div class="eg112-footer__links">
          <a href="<?php echo !empty($egeser_url_hakkimizda) ? $egeser_url_hakkimizda : '/hakkimizda'; ?>">Hakkımızda</a>
          <a href="<?php echo !empty($egeser_url_referanslar) ? $egeser_url_referanslar : '/projelerimiz'; ?>">Projelerimiz</a>
          <a href="<?php echo !empty($egeser_url_teknik) ? $egeser_url_teknik : '/teknik-bilgiler'; ?>">Teknik Bilgiler</a>
          <a href="<?php echo $eg112_contact_footer; ?>">İletişim</a>
          <a href="<?php echo !empty($egeser_url_blog) ? htmlspecialchars($egeser_url_blog, ENT_QUOTES, 'UTF-8') : '/blog'; ?>">Blog</a>
          <a href="<?php echo !empty($egeser_url_sss) ? $egeser_url_sss : '/sss'; ?>">Sık Sorulan Sorular</a>
        </div>

        <div class="eg112-footer__cta">
          <strong>Projeniz için teklif alın</strong>
          <span>Kurulum yeri ve ihtiyacınızı paylaşın.</span>
          <a href="<?php echo $eg112_contact_footer; ?>">Teklif Formu →</a>
        </div>
      </div>
    </div>
  </div>

  <div class="eg112-footer__bottom">
    <div class="eg-shell-container eg112-footer__bottom-inner">
      <span>© <?php echo date('Y'); ?> Egeser Prefabrik. Tüm hakları saklıdır.</span>
      <div class="eg112-footer__legal">
        <a href="<?php echo !empty($egeser_url_kvkk) ? $egeser_url_kvkk : '/kvkk-aydinlatma-metni'; ?>">KVKK</a>
        <a href="<?php echo !empty($egeser_url_gizlilik) ? $egeser_url_gizlilik : '/gizlilik-politikasi'; ?>">Gizlilik</a>
        <a href="<?php echo !empty($egeser_url_cerez) ? $egeser_url_cerez : '/cerez-politikasi'; ?>">Çerez Politikası</a>
        <a href="#" data-eg-consent-reopen>Çerez Tercihleri</a>
      </div>
    </div>
  </div>
</footer>

<div class="eg112-mobilebar">
  <a href="<?php echo $eg112_phone_href_footer; ?>">ARA</a>
  <?php if (!empty($egeser_whatsapp)) { ?>
    <a class="wa" href="https://wa.me/<?php echo htmlspecialchars($egeser_whatsapp, ENT_QUOTES, 'UTF-8'); ?>" target="_blank" rel="noopener noreferrer">WHATSAPP</a>
  <?php } else { ?>
    <a class="wa" href="<?php echo $eg112_contact_footer; ?>">İLETİŞİM</a>
  <?php } ?>
  <a class="quote" href="<?php echo $eg112_contact_footer; ?>">TEKLİF AL</a>
</div>

<script id="egeser-footer-logo-safe">
(function(){
  function mountFooterLogo(){
    var slot = document.getElementById('eg112-footer-logo');
    var fallback = document.getElementById('eg112-footer-brand-fallback');
    if(!slot || slot.getAttribute('data-mounted') === '1'){ return; }

    var headerLogo = document.querySelector('.eg112-brand img');
    if(!headerLogo || !headerLogo.getAttribute('src')){ return; }

    var img = document.createElement('img');
    img.className = 'eg112-footer__logo-img';
    img.src = headerLogo.getAttribute('src');
    img.alt = headerLogo.getAttribute('alt') || 'Egeser Prefabrik';
    img.loading = 'lazy';
    img.decoding = 'async';

    img.onload = function(){
      slot.setAttribute('data-mounted','1');
      slot.appendChild(img);
      if(fallback){ fallback.classList.add('is-logo-ready'); }
    };
  }

  if(document.readyState === 'loading'){
    document.addEventListener('DOMContentLoaded', mountFooterLogo);
  }else{
    mountFooterLogo();
  }
})();
</script>

<!-- V5 tek grid dosyasi sayfa ici stillerden sonra yuklenir. -->
<link href="catalog/view/theme/egeser/stylesheet/egeser-layout-v5.css?v=20260918-5" rel="stylesheet" />

<div id="eg-consent-banner" role="dialog" aria-label="Çerez tercihleri">
  <p>Sitemizde deneyimi iyileştirmek ve ziyaret istatistiklerini ölçmek için çerezler kullanıyoruz. Detaylar için <a href="<?php echo !empty($egeser_url_cerez) ? $egeser_url_cerez : '/cerez-politikasi'; ?>" target="_blank" rel="noopener noreferrer">Çerez Politikası</a> sayfamıza bakabilirsiniz.</p>
  <div id="eg-consent-banner__actions">
    <button type="button" id="eg-consent-reject">Sadece Zorunlu</button>
    <button type="button" id="eg-consent-accept">Kabul Et</button>
  </div>
</div>

</body>
</html>
