<?php echo $header; ?>
<?php echo $content_top; ?>

<style id="egeser-home-v17-3-mobile-final">
:root{
  --eh12-red:#d71920;
  --eh12-red-dark:#b91017;
  --eh12-ink:#171717;
  --eh12-text:#303033;
  --eh12-muted:#737377;
  --eh12-soft:#f6f6f3;
  --eh12-soft2:#efefeb;
  --eh12-line:#e6e6e2;
  --eh12-white:#fff;
  --eh12-green:#0e8f7e;
  --eh12-radius-xl:30px;
  --eh12-radius-lg:22px;
  --eh12-radius-md:15px;
  --eh12-shadow:0 24px 70px rgba(20,20,20,.08);

--eg-red:#F21B22;
--eg-red-hover:#D9151B;
--eg-orange:#F4A126;
--eg-orange-dark:#D98A14;
--eg-orange-soft:#FFF6EA;
--eg-dark:#121212;
--eg-dark-2:#2B2B2B;
--eg-bg:#F7F5F2;
--eg-border:#E8E3DD;
--eg-muted:#6B6B6B;
--eg-red-text:#c81420;
--eg-orange-text:#9c6300;
}
.eh12{font-family:Arial,Helvetica,sans-serif;color:var(--eh12-text);background:#fff;font-size:15px;line-height:1.65}
.eh12 *{box-sizing:border-box}
.eh12 a{text-decoration:none}
.eh12 .eh12-container{width:min(calc(100% - 42px),1240px);margin:0 auto}
.eh12 .eh12-label{display:inline-flex;align-items:center;gap:8px;color:var(--eh12-red);font-size:10px;font-weight:900;letter-spacing:.14em;text-transform:uppercase}
.eh12 .eh12-label:before{content:"";width:28px;height:2px;background:currentColor}
.eh12 .eh12-btn{display:inline-flex;align-items:center;justify-content:center;gap:8px;min-height:48px;padding:12px 18px;border-radius:11px;border:1px solid transparent;font-size:13px;font-weight:900;transition:.2s ease}
.eh12 .eh12-btn:hover{transform:translateY(-1px)}
.eh12 .eh12-btn--red{background:var(--eh12-red);color:#fff}
.eh12 .eh12-btn--red:hover{background:var(--eh12-red-dark);color:#fff}
.eh12 .eh12-btn--ghost{border-color:#d7d7d2;background:#fff;color:#242424}
.eh12 .eh12-btn--dark{background:#1d1d1d;color:#fff}
.eh12 .eh12-section{padding:78px 0}
.eh12 .eh12-section+.eh12-section{border-top:1px solid #f0f0ed}
.eh12 .eh12-heading{display:grid;grid-template-columns:minmax(0,.72fr) minmax(270px,.28fr);gap:40px;align-items:end;margin-bottom:30px}
.eh12 .eh12-heading h2{margin:8px 0 0;color:var(--eh12-ink);font-size:clamp(32px,3.3vw,48px);line-height:1.07;letter-spacing:-.04em}
.eh12 .eh12-heading p{margin:0;color:var(--eh12-muted);line-height:1.75}

/* HERO */
.eh12 .eh12-hero{padding:42px 0 58px;background:
 radial-gradient(circle at 80% 10%,rgba(215,25,32,.06),transparent 28%),
 linear-gradient(180deg,#fff,#fafaf8)}
.eh12 .eh12-hero__grid{display:grid;grid-template-columns:minmax(0,1.03fr) minmax(0,.97fr);gap:54px;align-items:center}
.eh12 .eh12-hero h1{margin:13px 0 20px;max-width:720px;color:var(--eh12-ink);font-size:clamp(46px,4vw,62px);line-height:1.01;letter-spacing:-.045em;font-weight:900}
.eh12 .eh12-hero h1 span{color:var(--eh12-red)}
.eh12 .eh12-hero__lead{max-width:610px;margin:0;color:#5d5e61;font-size:17px;line-height:1.8}
.eh12 .eh12-hero__actions{display:flex;flex-wrap:wrap;gap:10px;margin-top:26px}
.eh12 .eh12-hero__meta{display:flex;flex-wrap:wrap;gap:10px 18px;margin-top:22px;color:#696a6d;font-size:11px;font-weight:700}
.eh12 .eh12-hero__meta span{display:inline-flex;align-items:center;gap:6px}
.eh12 .eh12-hero__meta i{width:18px;height:18px;display:grid;place-items:center;border-radius:50%;background:#edf7f4;color:#0f8f7f;font-style:normal;font-size:10px}
.eh12 .eh12-hero-media{position:relative;overflow:hidden;min-height:520px;border-radius:28px;background:#efefec;box-shadow:0 28px 80px rgba(20,20,20,.10)}
.eh12 .eh12-hero-media img{position:absolute;inset:0;display:block;width:100%;height:100%;min-height:520px;object-fit:cover}
.eh12 .eh12-hero-media__placeholder{min-height:560px;display:grid;place-items:center;background:
 linear-gradient(135deg,rgba(255,255,255,.1),rgba(0,0,0,.04)),#ececea}
.eh12 .eh12-hero-media__placeholder div{text-align:center;color:#777}
.eh12 .eh12-hero-media__placeholder strong{display:block;font-size:24px;color:#444}
.eh12 .eh12-hero-media__badge{position:absolute;left:20px;top:20px;padding:9px 12px;border-radius:999px;background:rgba(255,255,255,.93);font-size:10px;font-weight:900;letter-spacing:.09em;text-transform:uppercase}
.eh12 .eh12-hero-card{position:absolute;right:16px;bottom:16px;width:min(272px,calc(100% - 32px));padding:14px;border-radius:15px;background:rgba(24,24,24,.90);backdrop-filter:blur(10px);color:#fff}
.eh12 .eh12-hero-card small{display:block;color:#ff7c80;font-size:9px;font-weight:900;letter-spacing:.12em;text-transform:uppercase}
.eh12 .eh12-hero-card strong{display:block;margin-top:4px;font-size:15px;line-height:1.22}
.eh12 .eh12-hero-card span{display:block;margin-top:4px;color:#c8c8c8;font-size:10px;line-height:1.45}
.eh12 .eh12-hero-card a{display:inline-flex;margin-top:9px;color:#fff;font-size:11px;font-weight:800}

/* TRUST STRIP */
.eh12 .eh12-trust{border-top:1px solid var(--eh12-line);border-bottom:1px solid var(--eh12-line);background:#fff}
.eh12 .eh12-trust__grid{display:grid;grid-template-columns:repeat(5,1fr)}
.eh12 .eh12-trust article{padding:22px 24px;text-align:center;border-right:1px solid var(--eh12-line)}
.eh12 .eh12-trust article:last-child{border-right:0}
.eh12 .eh12-trust strong{display:block;color:#222;font-size:13px}
.eh12 .eh12-trust span{display:block;margin-top:3px;color:var(--eg-muted);font-size:11px}

/* STATS COUNTER */
.eh12 .eh12-stats{padding:54px 0;background:var(--eh12-ink)}
.eh12 .eh12-stats__grid{display:grid;grid-template-columns:repeat(4,1fr);gap:0}
.eh12 .eh12-stats__item{padding:0 24px;text-align:center;border-right:1px solid rgba(255,255,255,.12)}
.eh12 .eh12-stats__item:last-child{border-right:0}
.eh12 .eh12-stats__num{display:block;color:#fff;font-size:clamp(32px,3.6vw,48px);font-weight:900;letter-spacing:-.03em;line-height:1}
.eh12 .eh12-stats__num span{color:var(--eh12-red)}
.eh12 .eh12-stats__label{display:block;margin-top:10px;color:rgba(255,255,255,.62);font-size:11.5px;font-weight:700;letter-spacing:.04em;line-height:1.4}
@media(max-width:767px){
  .eh12 .eh12-stats__grid{grid-template-columns:repeat(2,1fr);row-gap:30px}
  .eh12 .eh12-stats__item:nth-child(2){border-right:0}
  .eh12 .eh12-stats__item:nth-child(1),.eh12 .eh12-stats__item:nth-child(2){border-bottom:1px solid rgba(255,255,255,.12);padding-bottom:24px}
}

.eh12 .eh12-bestsellers{padding:34px 0;background:#fff;border-bottom:1px solid var(--eh12-line)}
.eh12 .eh12-bestsellers__head{margin-bottom:18px}
.eh12 .eh12-bestsellers__head .eh12-label{margin-bottom:0}
.eh12 .eh12-bestsellers__track-wrap{width:100%;overflow:hidden;-webkit-mask-image:linear-gradient(90deg,transparent,#000 3%,#000 97%,transparent);mask-image:linear-gradient(90deg,transparent,#000 3%,#000 97%,transparent)}
.eh12 .eh12-bestsellers__track{display:flex;gap:26px;width:max-content;animation:eh12-marquee 44s linear infinite}
.eh12 .eh12-bestsellers__track-wrap:hover .eh12-bestsellers__track{animation-play-state:paused}
.eh12 .eh12-bestsellers__item{position:relative;flex:0 0 auto;display:block;width:142px;height:178px;border-radius:14px;overflow:hidden;text-decoration:none;background:#eee;box-shadow:0 6px 18px rgba(20,20,20,.06)}
.eh12 .eh12-bestsellers__item img{width:100%;height:100%;object-fit:cover;display:block;transition:transform .4s ease}
.eh12 .eh12-bestsellers__item:hover img{transform:scale(1.04)}
.eh12 .eh12-bestsellers__cap{position:absolute;left:0;right:0;bottom:0;padding:22px 11px 9px;background:linear-gradient(transparent,rgba(10,10,10,.62));color:#fff}
.eh12 .eh12-bestsellers__cap b{display:block;font-size:11px;font-weight:700;line-height:1.3;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.eh12 .eh12-bestsellers__cap small{display:block;margin-top:1px;font-size:9.5px;font-weight:400;color:rgba(255,255,255,.82);overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
@keyframes eh12-marquee{from{transform:translateX(0)}to{transform:translateX(-50%)}}
@media (prefers-reduced-motion: reduce){.eh12 .eh12-bestsellers__track{animation:none}}
@media(max-width:640px){
  .eh12 .eh12-bestsellers__item{width:112px;height:144px}
  .eh12 .eh12-bestsellers__track{gap:16px}
}

/* AUDIENCE */
.eh12 .eh12-audience{display:grid;grid-template-columns:1fr 1fr;gap:18px}
.eh12 .eh12-audience-card{position:relative;overflow:hidden;min-height:370px;padding:32px;border-radius:26px;background:#f1f1ee;border:1px solid var(--eh12-line)}
.eh12 .eh12-audience-card--dark{background:#1d1d1d;color:#fff}
.eh12 .eh12-audience-card:before{content:"";position:absolute;right:-80px;top:-80px;width:260px;height:260px;border-radius:50%;background:rgba(215,25,32,.08)}
.eh12 .eh12-audience-card small{display:block;color:var(--eh12-red);font-size:10px;font-weight:900;letter-spacing:.12em;text-transform:uppercase}
.eh12 .eh12-audience-card h3{margin:9px 0 10px;font-size:34px;line-height:1.06;color:#202020}
.eh12 .eh12-audience-card--dark h3{color:#fff}
.eh12 .eh12-audience-card p{max-width:520px;margin:0;color:#666;line-height:1.75}
.eh12 .eh12-audience-card--dark p{color:#bbb}
.eh12 .eh12-audience-links{display:grid;grid-template-columns:1fr 1fr;gap:9px;margin-top:26px}
.eh12 .eh12-audience-links a{display:flex;justify-content:space-between;align-items:center;gap:15px;padding:14px 15px;border:1px solid #ddd;border-radius:12px;background:#fff;color:#222;font-size:12px;font-weight:800;transition:background .2s ease,border-color .2s ease,color .2s ease}
.eh12 .eh12-audience-links a b{transition:transform .2s ease}
.eh12 .eh12-audience-links a:hover{background:var(--eh12-red);border-color:var(--eh12-red);color:#fff}
.eh12 .eh12-audience-links a:hover b{transform:translateX(3px)}
.eh12 .eh12-audience-card--dark .eh12-audience-links a{border-color:#393939;background:#272727;color:#fff}
.eh12 .eh12-audience-card--dark .eh12-audience-links a:hover{background:var(--eh12-red);border-color:var(--eh12-red);color:#fff}

/* PRODUCT CARDS */
.eh12 .eh12-products{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:16px}
.eh12 .eh12-product{overflow:hidden;border:1px solid var(--eh12-line);border-radius:22px;background:#fff}
.eh12 .eh12-product__media{position:relative;overflow:hidden;background:#f1f1ee}
.eh12 .eh12-product__media img{display:block;width:100%;aspect-ratio:4/3;object-fit:cover;transition:transform .35s ease}
.eh12 .eh12-product:hover .eh12-product__media img{transform:scale(1.025)}
.eh12 .eh12-product__placeholder{display:grid;place-items:center;aspect-ratio:4/3;background:#efefec;color:#8a8a8a}
.eh12 .eh12-product__body{padding:20px}
.eh12 .eh12-product__body small{display:block;margin-bottom:6px;color:var(--eh12-red);font-size:9px;font-weight:900;letter-spacing:.1em;text-transform:uppercase}
.eh12 .eh12-product h3{margin:0 0 8px;color:#222;font-size:21px;line-height:1.25}
.eh12 .eh12-product p{margin:0;color:#777;font-size:12px;line-height:1.6}
.eh12 .eh12-product__meta{display:flex;flex-wrap:wrap;gap:6px;margin-top:13px}
.eh12 .eh12-product__meta span{display:inline-flex;align-items:center;min-height:26px;padding:5px 9px;border:1px solid #e4e4df;border-radius:999px;background:#fafaf8;color:#555;font-size:10px;font-weight:800}
.eh12 .eh12-product a{display:inline-flex;margin-top:15px;color:#222;font-size:12px;font-weight:900}
.eh12 .eh12-product a:hover{color:var(--eh12-red)}

/* CORPORATE SOLUTIONS */
.eh12 .eh12-corp-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:12px}
.eh12 .eh12-corp-card{position:relative;min-height:180px;padding:22px;border:1px solid var(--eh12-line);border-radius:19px;background:#fff;overflow:hidden}
.eh12 .eh12-corp-card:after{content:"";position:absolute;right:-35px;bottom:-35px;width:110px;height:110px;border-radius:50%;background:rgba(215,25,32,.05)}
.eh12 .eh12-corp-card span{display:inline-grid;width:34px;height:34px;place-items:center;border-radius:10px;background:#fcecee;color:var(--eh12-red);font-weight:900}
.eh12 .eh12-corp-card h3{margin:20px 0 6px;font-size:17px;color:#222}
.eh12 .eh12-corp-card p{margin:0;color:#7a7a7c;font-size:11px;line-height:1.55}
.eh12 .eh12-corp-card a{position:absolute;left:22px;bottom:18px;color:#222;font-size:11px;font-weight:900}

/* WHY */
.eh12 .eh12-why{padding:46px;border-radius:30px;background:
 radial-gradient(circle at 92% 8%,rgba(215,25,32,.2),transparent 24%),#1b1b1b;color:#fff}
.eh12 .eh12-why__grid{display:grid;grid-template-columns:.9fr 1.1fr;gap:52px;align-items:start}
.eh12 .eh12-why h2{margin:9px 0 13px;color:#fff;font-size:42px;line-height:1.06}
.eh12 .eh12-why p{margin:0;color:#bdbdbd;line-height:1.8}
.eh12 .eh12-why-list{display:grid;grid-template-columns:1fr 1fr;gap:10px}
.eh12 .eh12-why-list article{padding:20px;border:1px solid #373737;border-radius:16px;background:#242424}
.eh12 .eh12-why-list strong{display:block;color:#ff6469;font-size:11px}
.eh12 .eh12-why-list h3{margin:6px 0;font-size:16px;color:#fff}
.eh12 .eh12-why-list p{font-size:11px;line-height:1.55}

/* PROJECTS */
.eh12 .eh12-projects{display:grid;grid-template-columns:1.2fr .8fr .8fr;gap:14px}
.eh12 .eh12-project{position:relative;overflow:hidden;min-height:350px;border-radius:22px;background:#efefec}
.eh12 .eh12-project:first-child{min-height:470px}
.eh12 .eh12-project__placeholder{position:absolute;inset:0;display:grid;place-items:center;color:#8a8a8a;background:linear-gradient(135deg,#f3f3f0,#e9e9e5)}
.eh12 .eh12-project__body{position:absolute;left:16px;right:16px;bottom:16px;padding:17px;border-radius:15px;background:rgba(255,255,255,.94);backdrop-filter:blur(8px)}
.eh12 .eh12-project small{color:var(--eh12-red);font-size:9px;font-weight:900;letter-spacing:.1em;text-transform:uppercase}
.eh12 .eh12-project h3{margin:4px 0 3px;color:#222;font-size:18px}
.eh12 .eh12-project p{margin:0;color:#777;font-size:11px}

/* PROCESS */
.eh12 .eh12-process{display:grid;grid-template-columns:repeat(6,minmax(0,1fr));position:relative}
.eh12 .eh12-process:before{content:"";position:absolute;left:4%;right:4%;top:24px;height:2px;background:#e3e3df}
.eh12 .eh12-step{position:relative;padding:0 12px}
.eh12 .eh12-step span{position:relative;z-index:2;display:grid;place-items:center;width:48px;height:48px;margin-bottom:17px;border:2px solid var(--eh12-red);border-radius:50%;background:#fff;color:var(--eh12-red);font-size:12px;font-weight:900}
.eh12 .eh12-step h3{margin:0 0 6px;font-size:14px}
.eh12 .eh12-step p{margin:0;color:#777;font-size:11px;line-height:1.55}

/* REGIONAL / SEO */
.eh12 .eh12-region{display:grid;grid-template-columns:minmax(0,1.05fr) minmax(320px,.95fr);gap:46px;align-items:center;padding:36px;border-radius:26px;background:var(--eh12-soft)}
.eh12 .eh12-region h2{margin:9px 0 10px;font-size:36px;color:#222}
.eh12 .eh12-region p{margin:0;color:#68696c;line-height:1.8}
.eh12 .eh12-region-grid{display:grid;grid-template-columns:1fr 1fr;gap:10px}
.eh12 .eh12-region-grid article{padding:18px;border:1px solid var(--eh12-line);border-radius:14px;background:#fff}
.eh12 .eh12-region-grid strong{display:block;font-size:14px}
.eh12 .eh12-region-grid span{display:block;margin-top:3px;color:var(--eg-muted);font-size:10px}

/* FAQ */
.eh12 .eh12-faq{display:grid;gap:9px;max-width:980px}
.eh12 .eh12-faq details{overflow:hidden;border:1px solid var(--eh12-line);border-radius:15px;background:#fff}
.eh12 .eh12-faq summary{position:relative;padding:19px 52px 19px 20px;list-style:none;cursor:pointer;font-weight:800}
.eh12 .eh12-faq summary::-webkit-details-marker{display:none}
.eh12 .eh12-faq summary:after{content:"+";position:absolute;right:20px;top:50%;transform:translateY(-50%);font-size:23px;color:#888}
.eh12 .eh12-faq details[open] summary{background:var(--eh12-soft)}
.eh12 .eh12-faq details[open] summary:after{content:"−";color:var(--eh12-red)}
.eh12 .eh12-faq p{margin:0;padding:0 20px 20px;color:#666;line-height:1.75}

/* OFFER FORM */
.eh12 .eh12-offer{display:grid;grid-template-columns:minmax(280px,.38fr) minmax(0,.62fr);gap:44px;padding:42px;border-radius:30px;background:#1d1d1d;color:#fff}
.eh12 .eh12-offer h2{margin:8px 0 13px;color:#fff;font-size:38px;line-height:1.07}
.eh12 .eh12-offer p{margin:0;color:#c3c3c3;line-height:1.8}
.eh12 .eg-lead-box__intro h2{font-size:26px!important}
.eh12 .eg-form-grid{display:grid!important;grid-template-columns:repeat(2,minmax(0,1fr))!important;gap:14px!important}
.eh12 .eg-field--full{grid-column:1/-1!important}
.eh12 .eg-field label,.eh12 .eg-field__label{display:block;margin:0 0 6px;color:#eee;font-size:12px;font-weight:700}
.eh12 .eg-field input[type=text],.eh12 .eg-field input[type=tel],.eh12 .eg-field input[type=email],.eh12 .eg-field select,.eh12 .eg-field textarea{
 display:block;width:100%;min-height:46px;margin:0;padding:11px 12px;border:1px solid #4a4a4a;border-radius:10px;background:#fff;color:#222;font:inherit;outline:none
}
.eh12 .eg-field textarea{min-height:110px}
.eh12 .eg-choice-row{display:grid!important;grid-template-columns:1fr 1fr!important;gap:10px!important}
.eh12 .eg-choice{position:relative;display:block!important;margin:0;padding:13px 14px;border:1px solid #4a4a4a;border-radius:10px;background:#292929;cursor:pointer}
.eh12 .eg-choice input{position:absolute;opacity:0;pointer-events:none}
.eh12 .eg-choice span{display:block;color:#fff;font-weight:800}
.eh12 .eg-choice:has(input:checked){border-color:var(--eh12-red);background:#361d1f;box-shadow:0 0 0 1px var(--eh12-red) inset}
.eh12 .eg-corporate-field[hidden]{display:none!important}
.eh12 .eg-consent{display:flex!important;gap:9px;align-items:flex-start;color:#d1d1d1!important;font-size:11px!important;font-weight:400!important}
.eh12 .eg-consent input{width:auto!important;min-height:0!important;margin-top:3px}
.eh12 .eg-consent a{color:#f2b263!important;text-decoration:underline}
.eh12 .eg-form-actions{display:flex;align-items:center;gap:14px;margin-top:16px}
.eh12 .eg-form-actions .eg-btn{border:0;cursor:pointer}
.eh12 .eg-hp-field{position:absolute!important;left:-9999px!important;width:1px!important;height:1px!important;overflow:hidden!important}

/* CONTACT CARDS */
.eh12 .eh12-contact{display:grid;grid-template-columns:repeat(3,1fr);gap:12px}
.eh12 .eh12-contact article{padding:20px;border:1px solid var(--eh12-line);border-radius:16px;background:#fff}
.eh12 .eh12-contact strong{display:block;font-size:12px}
.eh12 .eh12-contact span{display:block;margin-top:3px;color:var(--eg-muted);font-size:11px}

.eh12 .eh12-project__media{position:relative;display:block;height:285px;overflow:hidden;background:linear-gradient(135deg,#efefeb,#f8f8f6)}
.eh12 .eh12-project__media img{width:100%;height:100%;object-fit:cover;display:block;transition:transform .45s ease}
.eh12 .eh12-project:hover .eh12-project__media img{transform:scale(1.025)}
.eh12 .eh12-project__badge{position:absolute;left:14px;top:14px;z-index:2;display:inline-flex;align-items:center;min-height:28px;padding:6px 9px;border-radius:999px;background:rgba(20,20,20,.88);color:#fff;font-size:9px;font-weight:900;letter-spacing:.08em;text-transform:uppercase}
.eh12 .eh12-project__meta{display:flex;flex-wrap:wrap;gap:6px;margin:10px 0 0}
.eh12 .eh12-project__meta span{display:inline-flex;padding:5px 8px;border:1px solid #e6e6e1;border-radius:999px;color:#666;background:#fafaf8;font-size:9px;font-weight:800}
.eh12 .eh12-project__link{display:inline-flex;align-items:center;gap:6px;margin-top:15px;color:#171717;font-size:11px;font-weight:900}
.eh12 .eh12-project__link:after{content:"→";transition:transform .2s}
.eh12 .eh12-project:hover .eh12-project__link:after{transform:translateX(3px)}



/* V14 PREMIUM UI POLISH */
.eh12 .eh14-editorial{display:grid;grid-template-columns:minmax(260px,.72fr) minmax(0,1.28fr);gap:56px;align-items:start}
.eh12 .eh14-editorial__lead{position:sticky;top:110px}
.eh12 .eh14-editorial__lead h2{margin:9px 0 14px;color:#1d1d1d;font-size:clamp(34px,3.4vw,50px);line-height:1.05;letter-spacing:-.045em}
.eh12 .eh14-editorial__lead p{margin:0;color:#747477;line-height:1.8}
.eh12 .eh14-feature-list{display:grid;grid-template-columns:1fr 1fr;border-top:1px solid var(--eh12-line)}
.eh12 .eh14-feature{display:grid;grid-template-columns:42px 1fr;gap:15px;padding:24px 20px 24px 0;border-bottom:1px solid var(--eh12-line)}
.eh12 .eh14-feature:nth-child(odd){padding-right:28px;border-right:1px solid var(--eh12-line)}
.eh12 .eh14-feature:nth-child(even){padding-left:28px}
.eh12 .eh14-feature b{display:grid;place-items:center;width:34px;height:34px;border-radius:50%;background:#fff1f1;color:var(--eh12-red);font-size:10px}
.eh12 .eh14-feature h3{margin:1px 0 6px;color:#222;font-size:16px}
.eh12 .eh14-feature p{margin:0;color:#79797d;font-size:12px;line-height:1.65}

.eh12 .eh14-corp-showcase{display:grid;grid-template-columns:minmax(280px,.72fr) minmax(0,1.28fr);gap:48px;align-items:start}
.eh12 .eh14-corp-intro{padding:36px;border-radius:26px;background:#1b1b1b;color:#fff}
.eh12 .eh14-corp-intro h2{margin:9px 0 14px;color:#fff;font-size:clamp(32px,3.2vw,46px);line-height:1.06;letter-spacing:-.04em}
.eh12 .eh14-corp-intro p{margin:0;color:#bdbdbd;line-height:1.75}
.eh12 .eh14-corp-intro .eh12-btn{margin-top:22px}
.eh12 .eh14-corp-list{border-top:1px solid var(--eh12-line)}
.eh12 .eh14-corp-row{display:grid;grid-template-columns:44px 1fr auto;gap:18px;align-items:center;padding:18px 8px;border-bottom:1px solid var(--eh12-line);color:#222;transition:.2s ease}
.eh12 .eh14-corp-row:hover{padding-left:14px;background:#fafaf8}
.eh12 .eh14-corp-row b{color:var(--eh12-red);font-size:10px}
.eh12 .eh14-corp-row strong{display:block;font-size:15px}
.eh12 .eh14-corp-row span{display:block;margin-top:3px;color:var(--eg-muted);font-size:10px}
.eh12 .eh14-corp-row i{font-style:normal;font-size:18px}

.eh12 .eh14-region{overflow:hidden;position:relative;display:grid;grid-template-columns:minmax(0,1.18fr) minmax(340px,.82fr);gap:50px;padding:46px;border-radius:30px;background:#f3f3f0}
.eh12 .eh14-region:after{content:"";position:absolute;right:-120px;bottom:-160px;width:360px;height:360px;border-radius:50%;background:rgba(215,25,32,.055)}
.eh12 .eh14-region-copy{position:relative;z-index:1}
.eh12 .eh14-region-copy h2{margin:9px 0 14px;color:#1d1d1d;font-size:clamp(34px,3.2vw,48px);line-height:1.06;letter-spacing:-.04em}
.eh12 .eh14-region-copy p{margin:0;color:#6f6f73;line-height:1.8}
.eh12 .eh14-region-points{position:relative;z-index:1;display:grid;grid-template-columns:1fr 1fr;gap:0;border-top:1px solid #ddd}
.eh12 .eh14-region-points article{padding:22px 18px;border-bottom:1px solid #ddd}
.eh12 .eh14-region-points article:nth-child(odd){border-right:1px solid #ddd}
.eh12 .eh14-region-points strong{display:block;color:#222;font-size:13px}
.eh12 .eh14-region-points span{display:block;margin-top:3px;color:var(--eg-muted);font-size:10px}

.eh12 .eh14-knowledge-strip{display:grid;grid-template-columns:1.15fr repeat(4,.7fr);gap:0;border-top:1px solid var(--eh12-line);border-bottom:1px solid var(--eh12-line)}
.eh12 .eh14-knowledge-intro{padding:26px 30px 26px 0}
.eh12 .eh14-knowledge-intro h2{margin:8px 0 0;font-size:30px;line-height:1.08;color:#222}
.eh12 .eh14-knowledge-link{display:flex;flex-direction:column;justify-content:space-between;min-height:170px;padding:24px;border-left:1px solid var(--eh12-line);color:#222}
.eh12 .eh14-knowledge-link small{color:var(--eh12-red);font-size:9px;font-weight:900;letter-spacing:.12em}
.eh12 .eh14-knowledge-link strong{display:block;margin-top:8px;font-size:15px}
.eh12 .eh14-knowledge-link span{display:block;margin-top:auto;padding-top:22px;color:#888;font-size:10px}
.eh12 .eh14-knowledge-link:hover{background:#fafaf8}

@media(max-width:1100px){
 .eh12 .eh14-editorial,.eh12 .eh14-corp-showcase,.eh12 .eh14-region{grid-template-columns:1fr}
 .eh12 .eh14-editorial__lead{position:static}
 .eh12 .eh14-knowledge-strip{grid-template-columns:1fr 1fr}
 .eh12 .eh14-knowledge-intro{grid-column:1/-1}
 .eh12 .eh14-knowledge-link{border-top:1px solid var(--eh12-line)}
}
@media(max-width:640px){
 .eh12 .eh14-feature-list{grid-template-columns:1fr}
 .eh12 .eh14-feature:nth-child(odd),.eh12 .eh14-feature:nth-child(even){padding:18px 0;border-right:0}
 .eh12 .eh14-corp-intro,.eh12 .eh14-region{padding:28px 22px}
 .eh12 .eh14-region-points{grid-template-columns:1fr}
 .eh12 .eh14-region-points article:nth-child(odd){border-right:0}
 .eh12 .eh14-knowledge-strip{grid-template-columns:1fr}
 .eh12 .eh14-knowledge-intro{grid-column:auto;padding-right:0}
 .eh12 .eh14-knowledge-link{border-left:0}
}

/* V13 SEO + PREMIUM HOME SECTIONS */
.eh12 .eh13-category-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:16px}
.eh12 .eh13-category-card{position:relative;overflow:hidden;min-height:250px;padding:28px;border:1px solid var(--eh12-line);border-radius:24px;background:linear-gradient(145deg,#fff,#f5f5f1);transition:transform .25s ease,box-shadow .25s ease}
.eh12 .eh13-category-card:hover{transform:translateY(-3px);box-shadow:var(--eh12-shadow)}
.eh12 .eh13-category-card:after{content:"";position:absolute;width:190px;height:190px;right:-70px;bottom:-85px;border-radius:50%;background:rgba(215,25,32,.075)}
.eh12 .eh13-category-card small{display:block;color:var(--eh12-red);font-size:10px;font-weight:900;letter-spacing:.12em;text-transform:uppercase}
.eh12 .eh13-category-card h3{position:relative;z-index:1;margin:13px 0 10px;color:#1d1d1d;font-size:25px;line-height:1.15}
.eh12 .eh13-category-card p{position:relative;z-index:1;margin:0;max-width:92%;color:#6e6e72;font-size:13px;line-height:1.7}
.eh12 .eh13-category-card a{position:absolute;z-index:5;inset:0;display:flex;align-items:flex-end;padding:0 28px 26px;color:#171717;font-size:12px;font-weight:900}
.eh12 .eh13-category-card a span{display:inline-flex;align-items:center;padding:10px 16px;border-radius:999px;background:#fff;border:1px solid var(--eg-border,#e6e1da);font-size:13px;font-weight:900;box-shadow:0 2px 10px rgba(18,18,18,.08);transition:background .2s ease,color .2s ease,border-color .2s ease}
.eh12 .eh13-category-card:hover a span{background:var(--eh12-red);color:#fff;border-color:var(--eh12-red)}
.eh12 .eh13-category-card--dark a span{background:rgba(255,255,255,.1);border-color:rgba(255,255,255,.25);color:#fff}
.eh12 .eh13-category-card--dark:hover a span{background:var(--eh12-red);border-color:var(--eh12-red)}
.eh12 .eh13-category-card--dark{background:#1c1c1c;border-color:#1c1c1c}
.eh12 .eh13-category-card--dark h3,.eh12 .eh13-category-card--dark a{color:#fff}
.eh12 .eh13-category-card--dark p{color:#bdbdbd}

.eh12 .eh13-benefits{display:grid;grid-template-columns:repeat(3,1fr);gap:12px}
.eh12 .eh13-benefit{padding:24px;border:1px solid var(--eh12-line);border-radius:18px;background:#fff}
.eh12 .eh13-benefit span{display:grid;place-items:center;width:34px;height:34px;margin-bottom:14px;border-radius:10px;background:#fff1f1;color:var(--eh12-red);font-size:12px;font-weight:900}
.eh12 .eh13-benefit h3{margin:0 0 7px;color:#222;font-size:16px}
.eh12 .eh13-benefit p{margin:0;color:#777;font-size:12px;line-height:1.65}

.eh12 .eh13-price{display:grid;grid-template-columns:minmax(0,.78fr) minmax(420px,1.22fr);gap:36px;align-items:center;padding:42px;border-radius:28px;background:#181818;color:#fff}
.eh12 .eh13-price h2{margin:8px 0 16px;color:#fff;font-size:clamp(32px,3.4vw,48px);line-height:1.08;letter-spacing:-.04em}
.eh12 .eh13-price>div>p{color:#bdbdbd;line-height:1.8}
.eh12 .eh13-price-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:10px}
.eh12 .eh13-price-grid article{padding:18px;border:1px solid #333;border-radius:14px;background:#202020}
.eh12 .eh13-price-grid strong{display:block;font-size:13px}
.eh12 .eh13-price-grid span{display:block;margin-top:4px;color:#999;font-size:10px}

.eh12 .eh13-knowledge{display:grid;grid-template-columns:repeat(4,1fr);gap:12px}
.eh12 .eh13-knowledge a{display:block;min-height:165px;padding:22px;border:1px solid var(--eh12-line);border-radius:18px;background:#fff;color:#222;transition:.2s ease}
.eh12 .eh13-knowledge a:hover{transform:translateY(-2px);box-shadow:0 16px 40px rgba(0,0,0,.06)}
.eh12 .eh13-knowledge small{display:block;color:var(--eh12-red);font-size:9px;font-weight:900;letter-spacing:.12em}
.eh12 .eh13-knowledge strong{display:block;margin-top:10px;font-size:17px}
.eh12 .eh13-knowledge span{display:block;margin-top:7px;color:#777;font-size:11px;line-height:1.65}

@media(max-width:1100px){
 .eh12 .eh13-category-grid{grid-template-columns:1fr 1fr}
 .eh12 .eh13-category-card:last-child{grid-column:1/-1}
 .eh12 .eh13-price{grid-template-columns:1fr}
 .eh12 .eh13-knowledge{grid-template-columns:1fr 1fr}
}
@media(max-width:640px){
 .eh12 .eh13-category-grid,.eh12 .eh13-benefits,.eh12 .eh13-price-grid,.eh12 .eh13-knowledge{grid-template-columns:1fr}
 .eh12 .eh13-category-card:last-child{grid-column:auto}
 .eh12 .eh13-price{padding:30px 22px}
}

@media(max-width:1100px){
 .eh12 .eh12-hero__grid{grid-template-columns:1fr}
 .eh12 .eh12-hero-media,.eh12 .eh12-hero-media img,.eh12 .eh12-hero-media__placeholder{min-height:470px}
 .eh12 .eh12-products{grid-template-columns:repeat(2,1fr)}
 .eh12 .eh12-corp-grid{grid-template-columns:repeat(2,1fr)}
 .eh12 .eh12-why__grid{grid-template-columns:1fr}
 .eh12 .eh12-projects{grid-template-columns:1fr 1fr}
 .eh12 .eh12-project:first-child{grid-column:1/-1}
 .eh12 .eh12-process{grid-template-columns:repeat(3,1fr);gap:28px 0}
 .eh12 .eh12-process:before{display:none}
}
@media(max-width:820px){
 .eh12 .eh12-container{width:min(calc(100% - 28px),1240px)}
 .eh12 .eh12-section{padding:56px 0}
 .eh12 .eh12-heading{grid-template-columns:1fr;gap:12px}
 .eh12 .eh12-audience{grid-template-columns:1fr}
 .eh12 .eh12-region{grid-template-columns:1fr}
 .eh12 .eh12-offer{grid-template-columns:1fr;padding:28px 22px}
 .eh12 .eh12-contact{grid-template-columns:1fr}
 .eh12 .eh12-trust__grid{grid-template-columns:1fr 1fr}
 .eh12 .eh12-trust article:nth-child(2){border-right:0}
 .eh12 .eh12-trust article:nth-child(-n+2){border-bottom:1px solid var(--eh12-line)}
}
@media(max-width:640px){
 .eh12 .eh12-hero{padding:28px 0 40px}
 .eh12 .eh12-hero h1{font-size:40px}
 .eh12 .eh12-hero__lead{font-size:15px}
 .eh12 .eh12-hero-media,.eh12 .eh12-hero-media img,.eh12 .eh12-hero-media__placeholder{min-height:350px}
 .eh12 .eh12-products,.eh12 .eh12-corp-grid,.eh12 .eh12-projects,.eh12 .eh12-project:first-child{grid-template-columns:1fr;grid-column:auto}
 .eh12 .eh12-audience-links{grid-template-columns:1fr}
 .eh12 .eh12-why{padding:30px 22px}
 .eh12 .eh12-why h2{font-size:34px}
 .eh12 .eh12-why-list{grid-template-columns:1fr}
 .eh12 .eh12-process{grid-template-columns:1fr}
 .eh12 .eh12-step{display:grid;grid-template-columns:48px 1fr;gap:14px}
 .eh12 .eh12-step span{grid-row:1/3}
 .eh12 .eh12-region-grid{grid-template-columns:1fr}
 .eh12 .eg-form-grid{grid-template-columns:1fr!important}
 .eh12 .eg-field--full{grid-column:auto!important}
}

/* =========================================================
   V15 EGESER 3-COLOR BRAND SYSTEM
   Red = primary action / leadership
   Orange = premium accent / warmth
   Dark = corporate structure / trust
   ========================================================= */

.eh12{
  --eh12-red:var(--eg-red);
  --eh12-ink:var(--eg-dark);
  --eh12-soft:var(--eg-bg);
  --eh12-line:var(--eg-border);
}

/* Background rhythm */
.eh12 .eh12-section:nth-of-type(even){background:linear-gradient(180deg,#fff 0%,#fff 100%)}
.eh12 .eh12-section[style*="background:var(--eh12-soft)"]{background:linear-gradient(135deg,#F8F6F2 0%,#FFF9F0 100%) !important}

/* Labels: red line + orange micro accent */
.eh12 .eh12-label{
  color:var(--eg-red-text);
}
.eh12 .eh12-label:before{
  background:linear-gradient(90deg,var(--eg-red),var(--eg-orange));
}
.eh12 .eh12-label:after{
  content:"";
  display:inline-block;
  width:5px;height:5px;
  margin-left:8px;
  border-radius:50%;
  background:var(--eg-orange);
  vertical-align:middle;
}

/* Hero */
.eh12 .eh12-hero{
  background:
    radial-gradient(circle at 85% 25%, rgba(244,161,38,.10), transparent 28%),
    radial-gradient(circle at 78% 72%, rgba(242,27,34,.07), transparent 26%),
    #fff;
}
.eh12 .eh12-hero h1 span{
  color:var(--eg-red);
  position:relative;
}
.eh12 .eh12-hero h1 span:after{
  content:"";
  position:absolute;
  left:2px;right:12%;bottom:-7px;
  height:5px;border-radius:5px;
  background:linear-gradient(90deg,var(--eg-red),var(--eg-orange));
  opacity:.9;
}
.eh12 .eh12-hero-media{
  border:1px solid rgba(244,161,38,.22);
  box-shadow:0 28px 80px rgba(18,18,18,.10),0 0 0 7px rgba(244,161,38,.035);
}
.eh12 .eh12-hero-media__badge{
  border:1px solid rgba(244,161,38,.35);
  box-shadow:0 8px 22px rgba(18,18,18,.08);
}
.eh12 .eh12-hero-media__badge:before{
  content:"";
  display:inline-block;width:7px;height:7px;border-radius:50%;
  background:var(--eg-orange);
  margin-right:7px;
}

/* Buttons */
.eh12 .eh12-btn--red{
  background:var(--eg-red);
  border-color:var(--eg-red);
  color:#fff;
  box-shadow:0 10px 24px rgba(242,27,34,.14);
}
.eh12 .eh12-btn--red:hover{
  background:var(--eg-red-hover);
  border-color:var(--eg-red-hover);
  transform:translateY(-1px);
  box-shadow:0 12px 26px rgba(242,27,34,.20);
}
.eh12 .eh12-btn--ghost{
  background:#fff;
  border-color:var(--eg-border);
  color:var(--eg-dark);
}
.eh12 .eh12-btn--ghost:hover{
  background:var(--eg-orange-soft);
  border-color:var(--eg-orange);
  color:var(--eg-dark);
}

/* Trust strip */
.eh12 .eh12-trust article{
  position:relative;
}
.eh12 .eh12-trust article:before{
  content:"";
  position:absolute;top:0;left:0;right:0;height:2px;
  background:linear-gradient(90deg,var(--eg-red),var(--eg-orange));
  opacity:.55;
}
.eh12 .eh12-trust article strong{
  color:var(--eg-dark);
}
.eh12 .eh12-trust article span{
  color:var(--eg-muted);
}

/* Model cards */
.eh12 .eh13-category-card{
  border-color:var(--eg-border);
}
.eh12 .eh13-category-card:hover{
  border-color:rgba(244,161,38,.75);
  box-shadow:0 20px 50px rgba(18,18,18,.08);
}
.eh12 .eh13-category-card small{color:var(--eg-red-text)}
.eh12 .eh13-category-card:after{
  background:linear-gradient(145deg,rgba(244,161,38,.13),rgba(242,27,34,.08));
}
.eh12 .eh13-category-card--dark{
  background:
    radial-gradient(circle at 100% 100%,rgba(244,161,38,.13),transparent 32%),
    linear-gradient(145deg,var(--eg-dark),#1d1d1d);
  border-color:var(--eg-dark);
}
.eh12 .eh13-category-card--dark small{color:var(--eg-orange)}
.eh12 .eh13-category-card--dark:after{background:rgba(242,27,34,.12)}

/* Editorial feature section */
.eh12 .eh14-feature b{
  background:var(--eg-orange-soft);
  color:var(--eg-red-text);
  border:1px solid rgba(244,161,38,.30);
}
.eh12 .eh14-feature:hover b{
  background:var(--eg-orange);
  color:var(--eg-dark);
}
.eh12 .eh14-feature h3{color:var(--eg-dark)}
.eh12 .eh14-feature-list{border-top-color:var(--eg-border)}
.eh12 .eh14-feature{border-bottom-color:var(--eg-border)}
.eh12 .eh14-feature:nth-child(odd){border-right-color:var(--eg-border)}

/* Bireysel/Kurumsal dual cards */
.eh12 .eh12-solution--personal{
  background:
    radial-gradient(circle at 100% 0%,rgba(244,161,38,.14),transparent 32%),
    #F7F5F2;
}
.eh12 .eh12-solution--business{
  background:
    radial-gradient(circle at 100% 0%,rgba(242,27,34,.13),transparent 35%),
    linear-gradient(145deg,var(--eg-dark),#202020);
}
.eh12 .eh12-solution--personal .eh12-label{color:var(--eg-red-text)}
.eh12 .eh12-solution--business .eh12-label{color:var(--eg-orange)}
.eh12 .eh12-solution__links a:hover{
  border-color:var(--eg-orange);
  background:var(--eg-orange-soft);
}
.eh12 .eh12-solution--business .eh12-solution__links a:hover{
  background:rgba(244,161,38,.12);
  border-color:var(--eg-orange);
  color:#fff;
}

/* Corporate showcase */
.eh12 .eh14-corp-intro{
  background:
    linear-gradient(135deg,rgba(242,27,34,.08),transparent 46%),
    radial-gradient(circle at 100% 100%,rgba(244,161,38,.12),transparent 30%),
    var(--eg-dark);
  border:1px solid rgba(244,161,38,.12);
}
.eh12 .eh14-corp-intro .eh12-label{color:var(--eg-orange)}
.eh12 .eh14-corp-row b{color:var(--eg-orange-text)}
.eh12 .eh14-corp-row:hover{
  background:var(--eg-orange-soft);
  box-shadow:inset 3px 0 0 var(--eg-red);
}
.eh12 .eh14-corp-row i{color:var(--eg-red-text)}

/* Why Egeser dark section */
.eh12 .eh12-why{
  background:
    radial-gradient(circle at 90% 10%,rgba(244,161,38,.10),transparent 25%),
    radial-gradient(circle at 100% 100%,rgba(242,27,34,.13),transparent 30%),
    var(--eg-dark);
}
.eh12 .eh12-why .eh12-label{color:var(--eg-orange)}
.eh12 .eh12-why-card{
  border-color:rgba(244,161,38,.14);
}
.eh12 .eh12-why-card b{
  color:var(--eg-orange);
}

/* Price section */
.eh12 .eh13-price{
  background:
    radial-gradient(circle at 100% 0%,rgba(244,161,38,.11),transparent 27%),
    linear-gradient(135deg,var(--eg-dark),#1A1A1A 70%);
  border:1px solid rgba(244,161,38,.14);
}
.eh12 .eh13-price .eh12-label{color:var(--eg-orange)}
.eh12 .eh13-price-grid article{
  border-color:rgba(244,161,38,.16);
}
.eh12 .eh13-price-grid article:hover{
  border-color:rgba(244,161,38,.55);
  background:#25211b;
}
.eh12 .eh13-price-grid strong:before{
  content:"";
  display:inline-block;width:7px;height:7px;border-radius:50%;
  margin-right:7px;background:var(--eg-orange);
}

/* Timeline */
.eh12 .eh12-steps article:before{
  background:linear-gradient(90deg,var(--eg-red),var(--eg-orange));
}
.eh12 .eh12-step__num{
  border-color:var(--eg-orange);
  color:var(--eg-red-text);
  background:#fff;
}
.eh12 .eh12-steps article:hover .eh12-step__num{
  background:var(--eg-orange);
  color:var(--eg-dark);
}

/* Region */
.eh12 .eh14-region{
  background:
    radial-gradient(circle at 100% 100%,rgba(244,161,38,.13),transparent 28%),
    linear-gradient(135deg,#F5F3EF,#FFF8ED);
  border:1px solid rgba(244,161,38,.18);
}
.eh12 .eh14-region:after{
  background:linear-gradient(145deg,rgba(244,161,38,.13),rgba(242,27,34,.08));
}
.eh12 .eh14-region-points strong:before{
  content:"";
  display:inline-block;width:6px;height:6px;margin-right:7px;
  border-radius:50%;background:var(--eg-orange);
}

/* Technical knowledge */
.eh12 .eh14-knowledge-strip{
  border-top-color:var(--eg-border);
  border-bottom-color:var(--eg-border);
}
.eh12 .eh14-knowledge-link{
  border-left-color:var(--eg-border);
}
.eh12 .eh14-knowledge-link:hover{
  background:var(--eg-orange-soft);
  box-shadow:inset 0 -3px 0 var(--eg-orange);
}
.eh12 .eh14-knowledge-link small{color:var(--eg-red-text)}
.eh12 .eh14-knowledge-link span{color:var(--eg-orange-text)}

/* FAQ */
.eh12 .eh12-faq details{
  border-color:var(--eg-border);
}
.eh12 .eh12-faq details:hover{
  border-color:rgba(244,161,38,.60);
}
.eh12 .eh12-faq summary:after{
  color:var(--eg-orange-text);
}
.eh12 .eh12-faq details[open]{
  background:linear-gradient(135deg,#fff,var(--eg-orange-soft));
  border-color:rgba(244,161,38,.55);
  box-shadow:inset 3px 0 0 var(--eg-red);
}

/* Lead section */
.eh12 #eg-lead,
.eh12 .eh12-offer{
  background:
    radial-gradient(circle at 0% 0%,rgba(242,27,34,.11),transparent 27%),
    radial-gradient(circle at 100% 100%,rgba(244,161,38,.11),transparent 25%),
    var(--eg-dark);
}
.eh12 #eg-lead .eh12-label,
.eh12 .eh12-offer .eh12-label{color:var(--eg-orange)}
.eh12 #eg-lead input:focus,
.eh12 #eg-lead select:focus,
.eh12 #eg-lead textarea:focus{
  border-color:var(--eg-orange)!important;
  box-shadow:0 0 0 3px rgba(244,161,38,.14)!important;
}

/* Small premium orange accents */
.eh12 a:focus-visible,
.eh12 button:focus-visible{
  outline:2px solid var(--eg-orange);
  outline-offset:3px;
}


/* =========================================================
   V16 FINAL POLISH — MODEL VISUALS + 390/430 MOBILE
   ========================================================= */
.eh12 .eh16-model-card{
  padding:0;
  min-height:390px;
  display:flex;
  flex-direction:column;
}
.eh12 .eh16-model-card:after{display:none}
.eh12 .eh16-model-card__visual{
  position:relative;
  min-height:172px;
  overflow:hidden;
  border-bottom:1px solid var(--eg-border);
  background:
    radial-gradient(circle at 82% 18%,rgba(244,161,38,.38),transparent 29%),
    radial-gradient(circle at 22% 84%,rgba(242,27,34,.22),transparent 34%),
    linear-gradient(135deg,#f4eee5,#fff9f1);
  background-size:cover;
  background-position:center;
}
.eh12 .eh16-model-card__visual--cift{
  background:
    radial-gradient(circle at 18% 18%,rgba(242,27,34,.24),transparent 30%),
    radial-gradient(circle at 82% 82%,rgba(244,161,38,.38),transparent 34%),
    linear-gradient(135deg,#fff8ee,#f2ece6);
  background-size:cover;
  background-position:center;
}
.eh12 .eh16-model-card__visual.has-image:after{
  content:"";
  position:absolute;inset:0;
  background:linear-gradient(180deg,rgba(18,18,18,.03),rgba(18,18,18,.18));
}
.eh12 .eh16-model-card__visual span{
  position:absolute;z-index:2;left:18px;bottom:16px;
  display:inline-flex;padding:7px 10px;border-radius:999px;
  background:rgba(255,255,255,.92);
  border:1px solid rgba(244,161,38,.35);
  color:var(--eg-dark);
  font-size:9px;font-weight:900;letter-spacing:.10em;
}
.eh12 .eh16-model-card__visual span:before{
  content:"";width:6px;height:6px;margin:2px 7px 0 0;border-radius:50%;
  background:var(--eg-orange);
}
.eh12 .eh16-model-card__body{
  position:relative;
  flex:1;
  padding:24px 26px 66px;
}
.eh12 .eh16-model-card:hover .eh16-model-card__visual{
  filter:saturate(1.03) contrast(1.02);
}

/* Hero final visual balance */
.eh12 .eh12-hero-media{
  background:#f5f2ed;
}
.eh12 .eh12-hero-media img{
  object-position:center 50%;
}
.eh12 .eh12-hero-card{
  backdrop-filter:blur(8px);
}

/* Tablet */
@media(max-width:920px){
  .eh12 .eh12-hero{padding-top:48px}
  .eh12 .eh12-hero__grid{grid-template-columns:1fr;gap:34px}
  .eh12 .eh12-hero-copy{max-width:760px}
  .eh12 .eh12-hero h1{max-width:780px;font-size:clamp(44px,7vw,60px)}
  .eh12 .eh12-hero-media{min-height:470px}
  .eh12 .eh12-hero-media img{min-height:470px}
}

/* 430px mobile */
@media(max-width:430px){
  .eh12 .eh12-container{width:min(calc(100% - 28px),1240px)}
  .eh12 .eh12-section{padding:54px 0}
  .eh12 .eh12-hero{padding:38px 0 30px}
  .eh12 .eh12-hero__grid{gap:26px}
  .eh12 .eh12-hero h1{
    margin:10px 0 16px;
    max-width:none;
    font-size:39px;
    line-height:1.00;
    letter-spacing:-.042em;
  }
  .eh12 .eh12-hero h1 span:after{height:3px;bottom:-4px;right:22%}
  .eh12 .eh12-hero__lead{font-size:14px;line-height:1.65}
  .eh12 .eh12-hero__actions{display:grid;grid-template-columns:1fr;gap:9px}
  .eh12 .eh12-btn{width:100%;min-height:48px}
  .eh12 .eh12-hero__checks{gap:9px 12px;font-size:10px}
  .eh12 .eh12-hero-media{min-height:360px;border-radius:22px}
  .eh12 .eh12-hero-media img{min-height:360px}
  .eh12 .eh12-hero-card{
    left:14px;right:14px;bottom:14px;
    width:auto;padding:13px;border-radius:14px;
  }
  .eh12 .eh12-hero-card h3{font-size:18px}
  .eh12 .eh12-hero-media__badge{top:14px;left:14px;font-size:9px}

  .eh12 .eh12-trust{grid-template-columns:1fr 1fr}
  .eh12 .eh12-trust article{padding:16px 12px;min-height:82px}
  .eh12 .eh12-trust article strong{font-size:11px}
  .eh12 .eh12-trust article span{font-size:9px}

  .eh12 .eh12-heading{
    grid-template-columns:1fr;
    gap:12px;
    margin-bottom:24px;
  }
  .eh12 .eh12-heading h2,
  .eh12 .eh14-editorial__lead h2,
  .eh12 .eh14-corp-intro h2,
  .eh12 .eh14-region-copy h2{
    font-size:32px;
    line-height:1.08;
  }
  .eh12 .eh12-heading>p{max-width:none}

  .eh12 .eh13-category-grid{grid-template-columns:1fr;gap:14px}
  .eh12 .eh13-category-card:last-child{grid-column:auto}
  .eh12 .eh16-model-card{min-height:370px}
  .eh12 .eh16-model-card__visual{min-height:165px}

  .eh12 .eh12-solutions{grid-template-columns:1fr;gap:14px}
  .eh12 .eh12-solution{padding:24px 20px}
  .eh12 .eh12-solution__links{grid-template-columns:1fr}

  .eh12 .eh14-corp-showcase{gap:18px}
  .eh12 .eh14-corp-intro{padding:28px 22px}
  .eh12 .eh14-corp-row{grid-template-columns:34px 1fr 18px;padding:15px 2px;gap:10px}

  .eh12 .eh12-why{padding:28px 20px}
  .eh12 .eh12-why__grid{grid-template-columns:1fr}
  .eh12 .eh12-why__cards{grid-template-columns:1fr}

  .eh12 .eh13-price{padding:28px 20px;border-radius:22px}
  .eh12 .eh13-price h2{font-size:32px}
  .eh12 .eh13-price-grid{grid-template-columns:1fr}

  .eh12 .eh12-steps{grid-template-columns:1fr 1fr;gap:20px 14px}
  .eh12 .eh12-steps article:before{display:none}

  .eh12 .eh14-region{padding:28px 20px;border-radius:22px}
  .eh12 .eh14-region-points{grid-template-columns:1fr 1fr}
  .eh12 .eh14-region-points article{padding:16px 10px}

  .eh12 .eh14-knowledge-strip{grid-template-columns:1fr}
  .eh12 .eh14-knowledge-intro{padding:24px 0}
  .eh12 .eh14-knowledge-link{
    min-height:auto;
    padding:18px 0;
    border-left:0;
    border-top:1px solid var(--eg-border);
  }
  .eh12 .eh14-knowledge-link span{padding-top:10px}

  .eh12 .eh12-faq details{border-radius:12px}
  .eh12 .eh12-faq summary{padding:16px 44px 16px 16px;font-size:13px}
  .eh12 .eh12-faq details p{padding:0 16px 16px;font-size:12px}

  .eh12 #eg-lead{padding-left:0;padding-right:0}
}

/* 390px compact mobile */
@media(max-width:390px){
  .eh12 .eh12-container{width:min(calc(100% - 24px),1240px)}
  .eh12 .eh12-hero h1{font-size:36px}
  .eh12 .eh12-hero__lead{font-size:13.5px}
  .eh12 .eh12-hero-media{min-height:335px}
  .eh12 .eh12-hero-media img{min-height:335px}
  .eh12 .eh12-hero-card{padding:15px}
  .eh12 .eh12-hero-card h3{font-size:17px}
  .eh12 .eh12-trust{grid-template-columns:1fr}
  .eh12 .eh12-trust article{min-height:auto}
  .eh12 .eh12-heading h2,
  .eh12 .eh14-editorial__lead h2,
  .eh12 .eh14-corp-intro h2,
  .eh12 .eh14-region-copy h2{font-size:29px}
  .eh12 .eh12-steps{grid-template-columns:1fr}
  .eh12 .eh14-region-points{grid-template-columns:1fr}
}


/* =========================================================
   V17 HOMEPAGE FINAL — LOCAL SEO + TRUST + CONVERSION
   ========================================================= */

/* Regional city SEO/service cards */
.eh12 .eh17-service-region{
  background:
    radial-gradient(circle at 12% 12%,rgba(244,161,38,.06),transparent 25%),
    #fff;
}
.eh12 .eh17-region-heading{margin-bottom:30px}
.eh12 .eh17-city-grid{
  display:grid;
  grid-template-columns:repeat(3,minmax(0,1fr));
  gap:14px;
}
.eh12 .eh17-city-card{
  position:relative;
  min-height:250px;
  display:flex;
  flex-direction:column;
  padding:27px 26px 24px;
  overflow:hidden;
  border:1px solid var(--eg-border);
  border-radius:22px;
  background:#fff;
  transition:transform .2s ease,border-color .2s ease,box-shadow .2s ease;
}
.eh12 .eh17-city-card:after{
  content:"";
  position:absolute;
  right:-44px;bottom:-62px;
  width:148px;height:148px;border-radius:50%;
  background:linear-gradient(145deg,rgba(244,161,38,.13),rgba(242,27,34,.08));
  pointer-events:none;
}
.eh12 .eh17-city-card:hover{
  transform:translateY(-3px);
  border-color:rgba(244,161,38,.55);
  box-shadow:0 20px 46px rgba(18,18,18,.07);
}
.eh12 .eh17-city-card--primary{
  background:
    radial-gradient(circle at 100% 100%,rgba(244,161,38,.12),transparent 36%),
    linear-gradient(145deg,#151515,#201b17);
  border-color:#1e1e1e;
  color:#fff;
}
.eh12 .eh17-city-card--primary:after{background:rgba(242,27,34,.13)}
.eh12 .eh17-city-card__top{
  position:relative;z-index:1;
  display:flex;align-items:center;gap:9px;
  margin-bottom:17px;
}
.eh12 .eh17-city-card__top span{
  display:inline-flex;align-items:center;justify-content:center;
  width:30px;height:30px;border-radius:50%;
  border:1px solid rgba(244,161,38,.48);
  color:var(--eg-red-text);font-size:10px;font-weight:900;
}
.eh12 .eh17-city-card__top small{
  color:var(--eg-orange-text);
  font-size:9px;font-weight:900;letter-spacing:.10em;
}
.eh12 .eh17-city-card--primary .eh17-city-card__top span{
  color:var(--eg-orange);border-color:rgba(244,161,38,.55);
}
.eh12 .eh17-city-card--primary .eh17-city-card__top small{color:var(--eg-orange)}
.eh12 .eh17-city-card h3{
  position:relative;z-index:1;
  margin:0 0 10px;
  color:var(--eg-dark);
  font-size:22px;line-height:1.14;letter-spacing:-.025em;
}
.eh12 .eh17-city-card--primary h3{color:#fff}
.eh12 .eh17-city-card p{
  position:relative;z-index:1;
  margin:0 0 24px;
  color:var(--eg-muted);
  font-size:12.5px;line-height:1.7;
}
.eh12 .eh17-city-card--primary p{color:rgba(255,255,255,.70)}
.eh12 .eh17-city-action{
  position:relative;z-index:2;
  margin-top:auto;padding:0;
  display:inline-flex;align-items:center;gap:8px;
  border:0;background:transparent;
  color:var(--eg-dark);
  font-size:11px;font-weight:900;
  text-align:left;cursor:pointer;
}
.eh12 .eh17-city-card--primary .eh17-city-action{color:#fff}
.eh12 .eh17-city-action b{
  color:var(--eg-orange-text);
  transition:transform .18s ease;
}
.eh12 .eh17-city-card--primary .eh17-city-action b{color:var(--eg-orange)}
.eh12 .eh17-city-action:hover b{transform:translateX(4px)}
.eh12 .eh17-region-note{
  margin-top:16px;
  display:flex;align-items:center;justify-content:space-between;gap:20px;
  padding:20px 22px;
  border:1px solid rgba(244,161,38,.20);
  border-radius:18px;
  background:linear-gradient(90deg,var(--eg-orange-soft),#fff);
}
.eh12 .eh17-region-note strong{display:block;color:var(--eg-dark);font-size:13px}
.eh12 .eh17-region-note span{display:block;margin-top:3px;color:var(--eg-muted);font-size:10.5px}
.eh12 .eh17-region-note a{
  white-space:nowrap;color:var(--eg-red-text);font-size:11px;font-weight:900;text-decoration:none;
}

/* Address + map */
.eh12 .eh17-location{
  display:grid;
  grid-template-columns:minmax(0,1fr) minmax(390px,.82fr);
  gap:26px;
  align-items:stretch;
}
.eh12 .eh17-location__content{
  padding:34px;
  border:1px solid var(--eg-border);
  border-radius:28px;
  background:#fff;
}
.eh12 .eh17-location__content h2{
  margin:9px 0 12px;color:var(--eg-dark);
  font-size:clamp(32px,3vw,46px);line-height:1.05;letter-spacing:-.04em;
}
.eh12 .eh17-location__content>p{
  max-width:670px;margin:0;color:var(--eg-muted);line-height:1.75;
}
.eh12 .eh17-location__details{
  display:grid;
  grid-template-columns:1.25fr .8fr .9fr .9fr;
  gap:0;
  margin-top:28px;
  border-top:1px solid var(--eg-border);
  border-bottom:1px solid var(--eg-border);
}
.eh12 .eh17-location__details article{
  min-width:0;padding:20px 18px;
  border-right:1px solid var(--eg-border);
}
.eh12 .eh17-location__details article:first-child{padding-left:0}
.eh12 .eh17-location__details article:last-child{border-right:0;padding-right:0}
.eh12 .eh17-location__details small{
  display:block;margin-bottom:7px;color:var(--eg-red-text);
  font-size:8px;font-weight:900;letter-spacing:.10em;
}
.eh12 .eh17-location__details strong{
  display:block;color:var(--eg-dark);font-size:13px;line-height:1.45;
}
.eh12 .eh17-location__details strong a{color:inherit;text-decoration:none}
.eh12 .eh17-location__details strong a:hover{color:var(--eg-red)}
.eh12 .eh17-location__details span{
  display:block;margin-top:4px;color:var(--eg-muted);font-size:9.5px;
}
.eh12 .eh17-location__actions{display:flex;gap:10px;margin-top:24px}
.eh12 .eh17-map{
  position:relative;
  min-height:410px;
  overflow:hidden;
  border:1px solid rgba(244,161,38,.24);
  border-radius:28px;
  background:#efece7;
  box-shadow:0 24px 58px rgba(18,18,18,.08);
}
.eh12 .eh17-map iframe{
  position:absolute;inset:0;
  width:100%;height:100%;
  filter:saturate(.78) contrast(.98);
}
.eh12 .eh17-map__caption{
  position:absolute;left:18px;bottom:18px;z-index:2;
  min-width:180px;padding:13px 15px;
  border:1px solid rgba(244,161,38,.24);
  border-radius:14px;
  background:rgba(18,18,18,.90);
  color:#fff;
  box-shadow:0 12px 34px rgba(0,0,0,.18);
}
.eh12 .eh17-map__caption span{
  display:block;color:var(--eg-orange);font-size:8px;font-weight:900;letter-spacing:.09em;
}
.eh12 .eh17-map__caption strong{display:block;margin-top:3px;font-size:12px}

/* Mobile */
@media(max-width:920px){
  .eh12 .eh17-city-grid{grid-template-columns:1fr 1fr}
  .eh12 .eh17-location{grid-template-columns:1fr}
  .eh12 .eh17-map{min-height:360px}
}
@media(max-width:600px){
  .eh12 .eh17-city-grid{grid-template-columns:1fr}
  .eh12 .eh17-city-card{min-height:auto;padding:23px 20px}
  .eh12 .eh17-region-note{align-items:flex-start;flex-direction:column}
  .eh12 .eh17-region-note a{white-space:normal}
  .eh12 .eh17-location__content{padding:26px 20px;border-radius:22px}
  .eh12 .eh17-location__details{grid-template-columns:1fr}
  .eh12 .eh17-location__details article{
    padding:15px 0;border-right:0;border-bottom:1px solid var(--eg-border);
  }
  .eh12 .eh17-location__details article:last-child{border-bottom:0}
  .eh12 .eh17-location__actions{display:grid;grid-template-columns:1fr}
  .eh12 .eh17-map{min-height:320px;border-radius:22px}
}


/* =========================================================
   V17.2 FINAL FIX — MAP/CONTACT OVERFLOW + FOOTER GAP
   ========================================================= */

/* Haritanın solundaki iletişim bilgilerinde taşmayı önle */
.eh12 .eh17-location{
  grid-template-columns:minmax(0,1.04fr) minmax(0,.96fr);
}
.eh12 .eh17-location__content,
.eh12 .eh17-map{
  min-width:0;
}
.eh12 .eh17-location__content{
  overflow:hidden;
}
.eh12 .eh17-location__details{
  grid-template-columns:repeat(2,minmax(0,1fr));
}
.eh12 .eh17-location__details article{
  min-width:0;
  padding:18px 20px;
  border-right:1px solid var(--eg-border);
  border-bottom:1px solid var(--eg-border);
}
.eh12 .eh17-location__details article:nth-child(2n){
  border-right:0;
}
.eh12 .eh17-location__details article:nth-last-child(-n+2){
  border-bottom:0;
}
.eh12 .eh17-location__details article:first-child{
  padding-left:0;
}
.eh12 .eh17-location__details article:nth-child(3){
  padding-left:0;
}
.eh12 .eh17-location__details strong,
.eh12 .eh17-location__details strong a,
.eh12 .eh17-location__details span{
  max-width:100%;
  overflow-wrap:anywhere;
  word-break:break-word;
}
.eh12 .eh17-location__details strong{
  font-size:12.5px;
}
.eh12 .eh17-map{
  overflow:hidden;
  isolation:isolate;
}
.eh12 .eh17-map iframe{
  display:block;
  width:100%!important;
  max-width:100%!important;
  height:100%!important;
  border:0!important;
}

/* Konum alanı ile footer arasındaki gereksiz boşluğu azalt */
.eh12 .eh17-location-section{
  padding-bottom:34px!important;
  margin-bottom:0!important;
}
.eh12 .eh17-location-section + *{
  margin-top:0!important;
}
body > footer,
footer{
  margin-top:0!important;
}

/* 920px altında güvenli kırılım */
@media(max-width:920px){
  .eh12 .eh17-location{
    grid-template-columns:1fr;
  }
  .eh12 .eh17-location__details{
    grid-template-columns:repeat(2,minmax(0,1fr));
  }
}

/* Mobilde tek kolon */
@media(max-width:600px){
  .eh12 .eh17-location__details{
    grid-template-columns:1fr;
  }
  .eh12 .eh17-location__details article,
  .eh12 .eh17-location__details article:nth-child(2n),
  .eh12 .eh17-location__details article:nth-last-child(-n+2){
    padding:15px 0;
    border-right:0;
    border-bottom:1px solid var(--eg-border);
  }
  .eh12 .eh17-location__details article:last-child{
    border-bottom:0;
  }
  .eh12 .eh17-location-section{
    padding-bottom:20px!important;
  }
}


/* =========================================================
   V17.3 MOBILE HARD FIX — 390 / 430 PX
   ========================================================= */
html,body{
  max-width:100%!important;
  overflow-x:hidden!important;
}
.eh12{
  width:100%!important;
  max-width:100%!important;
  overflow-x:hidden!important;
}
.eh12 main,
.eh12 section,
.eh12 .eh12-hero,
.eh12 .eh12-trust{
  max-width:100%!important;
}

@media(max-width:600px){
  .eh12 .eh12-container{
    width:auto!important;
    max-width:none!important;
    margin-left:16px!important;
    margin-right:16px!important;
  }

  .eh12 .eh12-hero{
    padding:30px 0 28px!important;
  }
  .eh12 .eh12-hero__grid{
    display:grid!important;
    grid-template-columns:minmax(0,1fr)!important;
    width:100%!important;
    max-width:100%!important;
    gap:24px!important;
  }
  .eh12 .eh12-hero-copy{
    width:100%!important;
    max-width:100%!important;
    min-width:0!important;
  }
  .eh12 .eh12-label{
    max-width:100%!important;
    white-space:normal!important;
    overflow-wrap:anywhere!important;
    line-height:1.45!important;
  }
  .eh12 .eh12-label:before{
    flex:0 0 24px!important;
  }
  .eh12 .eh12-hero h1{
    width:100%!important;
    max-width:100%!important;
    min-width:0!important;
    margin:10px 0 16px!important;
    font-size:34px!important;
    line-height:1.02!important;
    letter-spacing:-.035em!important;
    overflow-wrap:break-word!important;
    word-break:normal!important;
  }
  .eh12 .eh12-hero h1 span{
    display:inline!important;
    max-width:100%!important;
  }
  .eh12 .eh12-hero__lead{
    width:100%!important;
    max-width:100%!important;
    font-size:14px!important;
    line-height:1.62!important;
    overflow-wrap:break-word!important;
  }
  .eh12 .eh12-hero__actions{
    display:grid!important;
    grid-template-columns:minmax(0,1fr)!important;
    width:100%!important;
    gap:9px!important;
    margin-top:22px!important;
  }
  .eh12 .eh12-hero__actions .eh12-btn{
    width:100%!important;
    max-width:100%!important;
    min-width:0!important;
    padding-left:12px!important;
    padding-right:12px!important;
    white-space:normal!important;
    text-align:center!important;
    line-height:1.3!important;
  }
  .eh12 .eh12-hero__meta{
    display:grid!important;
    grid-template-columns:1fr 1fr!important;
    gap:9px 10px!important;
    width:100%!important;
  }
  .eh12 .eh12-hero__meta span{
    min-width:0!important;
    align-items:flex-start!important;
    overflow-wrap:anywhere!important;
  }
  .eh12 .eh12-hero-media{
    width:100%!important;
    max-width:100%!important;
    min-width:0!important;
    min-height:320px!important;
    border-radius:20px!important;
  }
  .eh12 .eh12-hero-media img{
    width:100%!important;
    max-width:100%!important;
    min-height:320px!important;
    object-fit:cover!important;
  }
  .eh12 .eh12-hero-card{
    left:12px!important;
    right:12px!important;
    bottom:12px!important;
    width:auto!important;
    max-width:calc(100% - 24px)!important;
  }

  /* Common grid safety */
  .eh12 .eh12-heading,
  .eh12 .eh13-category-grid,
  .eh12 .eh12-solutions,
  .eh12 .eh12-audience,
  .eh12 .eh12-products,
  .eh12 .eh12-corp-grid,
  .eh12 .eh14-corp-showcase,
  .eh12 .eh17-city-grid,
  .eh12 .eh17-location{
    width:100%!important;
    max-width:100%!important;
    grid-template-columns:minmax(0,1fr)!important;
  }
  .eh12 article,
  .eh12 .eh12-solution,
  .eh12 .eh16-model-card,
  .eh12 .eh17-city-card,
  .eh12 .eh17-location__content,
  .eh12 .eh17-map{
    min-width:0!important;
    max-width:100%!important;
  }
}

@media(max-width:390px){
  .eh12 .eh12-container{
    margin-left:14px!important;
    margin-right:14px!important;
  }
  .eh12 .eh12-hero h1{
    font-size:32px!important;
  }
  .eh12 .eh12-hero__lead{
    font-size:13.5px!important;
  }
  .eh12 .eh12-hero__meta{
    grid-template-columns:1fr!important;
  }
}

</style>

<main id="content" class="eh12">
<?php
$eh12_phone = !empty($telephone) ? trim($telephone) : '0531 886 60 90';
if (preg_replace('/\D+/', '', $eh12_phone) === '123456789') { $eh12_phone = '0531 886 60 90'; }
$eh12_phone_href = 'tel:' . preg_replace('/[^0-9+]/', '', $eh12_phone);

$eh12_hero_image = '';
$eh12_hero_href = '';
$eh12_hero_name = 'Prefabrik Yapı Çözümleri';
if (!empty($egeser_featured_products) && is_array($egeser_featured_products)) {
    foreach ($egeser_featured_products as $eh12_fp) {
        if (!empty($eh12_fp['image'])) {
            $eh12_hero_image = $eh12_fp['image'];
            $eh12_hero_href = !empty($eh12_fp['href']) ? $eh12_fp['href'] : '';
            $eh12_hero_name = !empty($eh12_fp['name']) ? $eh12_fp['name'] : $eh12_hero_name;
            break;
        }
    }
}

$eh13_url_prefabrik = '/prefabrik-yapilar';
$eh13_url_ev_modelleri = '/prefabrik-ev-modelleri';
$eh13_url_tek = '/tek-katli-prefabrik-evler';
$eh13_url_cift = '/cift-katli-prefabrik-evler';
$eh13_url_ofis = '/prefabrik-ofis-ve-yonetim-binalari';
$eh13_url_yatakhane = '/prefabrik-yatakhane-binalari';
$eh13_url_yemekhane = '/prefabrik-yemekhane-binalari';
$eh13_url_santiye = '/prefabrik-santiye-yapilari';
$eh13_url_sosyal = '/prefabrik-sosyal-tesis-yapilari';
$eh13_url_ozel = '/ozel-proje-prefabrik-yapilar';
$eh13_url_teknik = !empty($egeser_url_teknik) ? $egeser_url_teknik : 'teknik-bilgiler';
$eh13_url_projeler = !empty($egeser_url_referanslar) ? $egeser_url_referanslar : 'projelerimiz';

$eh17_email = 'web@egeserprefabrik.com.tr';
$eh17_email_href = 'mailto:' . $eh17_email;
$eh17_maps_href = 'https://www.google.com/maps?q=38.44988554328141,27.497831062110418';

$eh16_tek_placeholder  = 'image/catalog/egeser/home/tek-katli-placeholder.jpg';
$eh16_cift_placeholder = 'image/catalog/egeser/home/cift-katli-placeholder.jpg';
$eh16_tek_img  = !empty($egeser_home_tek_image)  ? $egeser_home_tek_image  : $eh16_tek_placeholder;
$eh16_cift_img = !empty($egeser_home_cift_image) ? $egeser_home_cift_image : $eh16_cift_placeholder;


$eh13_base = '';
if (defined('HTTPS_SERVER') && HTTPS_SERVER) {
    $eh13_base = HTTPS_SERVER;
} elseif (defined('HTTP_SERVER') && HTTP_SERVER) {
    $eh13_base = HTTP_SERVER;
} else {
    $eh13_base = '/';
}
$eh17_city_base = rtrim($eh13_base, '/') . '/';

$eh13_logo_url = defined('DIR_IMAGE') && is_file(DIR_IMAGE . 'catalog/logo/logo-copy.png')
    ? rtrim($eh13_base, '/') . '/image/catalog/logo/logo-copy.png'
    : '';
$eh13_showroom_url = defined('DIR_IMAGE') && is_file(DIR_IMAGE . 'catalog/egeser/hakkimizda/showroom.jpg')
    ? rtrim($eh13_base, '/') . '/image/catalog/egeser/hakkimizda/showroom.jpg'
    : '';

$eh13_same_as = array(
    'https://www.facebook.com/egeserprefabrik',
    'https://www.instagram.com/egeserprefabrik/',
    'https://tr.linkedin.com/company/egeser-konteyner-prefabrik-san-ve-tic-ltd-şti'
);

$eh13_schema = array(
    '@context' => 'https://schema.org',
    '@graph' => array(
        array(
            '@type' => 'Organization',
            '@id' => rtrim($eh13_base, '/') . '/#organization',
            'name' => 'Egeser Prefabrik',
            'legalName' => 'Egeser Konteyner Prefabrik San. Tic. Ltd. Şti',
            'url' => $eh13_base,
            'telephone' => $eh12_phone,
            'email' => 'web@egeserprefabrik.com.tr',
            'logo' => $eh13_logo_url,
            'image' => $eh13_logo_url,
            'sameAs' => $eh13_same_as,
            'address' => array(
                '@type' => 'PostalAddress',
                'streetAddress' => 'Çambel Mahallesi Ankara Caddesi 1558. Sokak No: 28 Daire: 1',
                'addressLocality' => 'Kemalpaşa',
                'addressRegion' => 'İzmir',
                'addressCountry' => 'TR'
            )
        ),
        array(
            '@type' => 'WebSite',
            '@id' => rtrim($eh13_base, '/') . '/#website',
            'url' => $eh13_base,
            'name' => 'Egeser Prefabrik',
            'publisher' => array('@id' => rtrim($eh13_base, '/') . '/#organization'),
            'inLanguage' => 'tr-TR'
        ),
        array(
            '@type' => 'LocalBusiness',
            '@id' => rtrim($eh13_base, '/') . '/#localbusiness',
            'name' => 'Egeser Prefabrik Showroom',
            'legalName' => 'Egeser Konteyner Prefabrik San. Tic. Ltd. Şti',
            'url' => $eh13_base,
            'telephone' => $eh12_phone,
            'email' => 'web@egeserprefabrik.com.tr',
            'priceRange' => '₺₺',
            'image' => !empty($eh13_showroom_url) ? $eh13_showroom_url : $eh13_logo_url,
            'sameAs' => $eh13_same_as,
            'address' => array(
                '@type' => 'PostalAddress',
                'streetAddress' => 'Irmak Depoları yanı, Çambel Ankara Caddesi 35. Km',
                'addressLocality' => 'Kemalpaşa',
                'addressRegion' => 'İzmir',
                'addressCountry' => 'TR'
            ),
            'geo' => array(
                '@type' => 'GeoCoordinates',
                'latitude' => 38.4498855,
                'longitude' => 27.4978310
            ),
            'hasMap' => $eh17_maps_href,
            'openingHoursSpecification' => array(
                array(
                    '@type' => 'OpeningHoursSpecification',
                    'dayOfWeek' => array(
                        'https://schema.org/Monday',
                        'https://schema.org/Tuesday',
                        'https://schema.org/Wednesday',
                        'https://schema.org/Thursday',
                        'https://schema.org/Friday',
                        'https://schema.org/Saturday'
                    ),
                    'opens' => '08:30',
                    'closes' => '17:30'
                )
            ),
            'areaServed' => array(
                array('@type' => 'City', 'name' => 'İzmir'),
                array('@type' => 'City', 'name' => 'Manisa'),
                array('@type' => 'City', 'name' => 'Aydın'),
                array('@type' => 'City', 'name' => 'Uşak'),
                array('@type' => 'City', 'name' => 'Balıkesir'),
                array('@type' => 'City', 'name' => 'Muğla')
            ),
            'parentOrganization' => array(
                '@id' => rtrim($eh13_base, '/') . '/#organization'
            )
        )
    )
);

foreach ($eh13_schema['@graph'] as &$eh13_graph_item) {
    foreach (array('logo', 'image') as $eh13_img_key) {
        if (isset($eh13_graph_item[$eh13_img_key]) && $eh13_graph_item[$eh13_img_key] === '') {
            unset($eh13_graph_item[$eh13_img_key]);
        }
    }
}
unset($eh13_graph_item);
?>
<script type="application/ld+json"><?php echo json_encode($eh13_schema, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES); ?></script>

<section class="eh12-hero">
  <div class="eh12-container eh12-hero__grid">
    <div>
      <span class="eh12-label">İZMİR MERKEZLİ PREFABRİK YAPI ÜRETİMİ</span>
      <h1>Prefabrik Ev ve Yapı Çözümleri <span>İzmir &amp; Ege Bölgesi.</span></h1>
      <p class="eh12-hero__lead">Tek katlı ve çift katlı prefabrik evlerden ofis, yatakhane, yemekhane, şantiye ve özel proje yapılarına kadar; projelendirme, üretim, sevkiyat ve montaj süreçlerini tek merkezden planlıyoruz.</p>

      <div class="eh12-hero__actions">
        <a class="eh12-btn eh12-btn--red" href="<?php echo htmlspecialchars($eh13_url_ev_modelleri, ENT_QUOTES, 'UTF-8'); ?>">Prefabrik Ev Modellerini İncele</a>
        <a class="eh12-btn eh12-btn--ghost" href="#eg-lead">Projem İçin Teklif Al</a>
      </div>

      <div class="eh12-hero__meta">
        <span><i>✓</i>Kendi üretim tesisimiz</span>
        <span><i>✓</i>Proje desteği</span>
        <span><i>✓</i>Profesyonel montaj</span>
        <span><i>✓</i>Satış sonrası iletişim</span>
      </div>
    </div>

    <div class="eh12-hero-media">
      <span class="eh12-hero-media__badge">PROJE / MODEL</span>
      <?php if ($eh12_hero_image) { ?>
        <img src="<?php echo htmlspecialchars($eh12_hero_image, ENT_QUOTES, 'UTF-8'); ?>" alt="<?php echo htmlspecialchars($eh12_hero_name, ENT_QUOTES, 'UTF-8'); ?>" width="780" height="585" fetchpriority="high" decoding="async">
      <?php } else { ?>
        <div class="eh12-hero-media__placeholder"><div><strong>Ana proje görseli</strong><span>Öne çıkan ürün görseli eklendiğinde otomatik kullanılır.</span></div></div>
      <?php } ?>

      <div class="eh12-hero-card">
        <small>PROJENİZİ BAŞLATALIM</small>
        <strong>İhtiyacınızı anlatın, doğru yapıyı birlikte planlayalım.</strong>
        <span>Bireysel ya da kurumsal kullanım için hızlı ön değerlendirme.</span>
        <a href="#eg-lead">Teklif formuna git →</a>
      </div>
    </div>
  </div>
</section>

<section class="eh12-trust">
  <div class="eh12-container eh12-trust__grid">
    <article><strong>Kendi Üretim Tesisimiz</strong><span>Kemalpaşa / İzmir üretim altyapısı</span></article>
    <article><strong>Bireysel &amp; Kurumsal Proje</strong><span>Farklı kullanım ihtiyaçlarına çözüm</span></article>
    <article><strong>Sevkiyat &amp; Montaj Planı</strong><span>Saha koşullarına göre organizasyon</span></article>
    <article><strong>Kredi Kartına 12 Taksit</strong><span>Tüm banka kartlarında geçerlidir</span></article>
    <article><strong>Satış Sonrası İletişim</strong><span>Teslim sonrası ulaşılabilir destek</span></article>
  </div>
</section>

<section class="eh12-stats">
  <div class="eh12-container eh12-stats__grid">
    <div class="eh12-stats__item"><span class="eh12-stats__num" data-eh12-count="8" data-eh12-suffix="+">0</span><span class="eh12-stats__label">Yıllık Tecrübe<br>(2018'den beri)</span></div>
    <div class="eh12-stats__item"><span class="eh12-stats__num" data-eh12-count="42" data-eh12-suffix=" M²">0</span><span class="eh12-stats__label">Ortalama Günlük<br>Modüler Yapı Üretimi</span></div>
    <div class="eh12-stats__item"><span class="eh12-stats__num" data-eh12-count="4" data-eh12-suffix="+">0</span><span class="eh12-stats__label">Aylık Prefabrik Ev<br>Kurulumu (min. 80 m²)</span></div>
    <div class="eh12-stats__item"><span class="eh12-stats__num" data-eh12-count="233" data-eh12-suffix="+">0</span><span class="eh12-stats__label">Google<br>Değerlendirmesi</span></div>
  </div>
</section>
<script>
(function(){
  'use strict';
  var nums = document.querySelectorAll('.eh12-stats__num[data-eh12-count]');
  if (!nums.length) { return; }
  var reduceMotion = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  function animate(el){
    var target = parseInt(el.getAttribute('data-eh12-count'), 10) || 0;
    var suffix = el.getAttribute('data-eh12-suffix') || '';
    if (reduceMotion) { el.textContent = target + suffix; return; }
    var duration = 1200;
    var start = null;
    function step(ts){
      if (start === null) { start = ts; }
      var progress = Math.min((ts - start) / duration, 1);
      var eased = 1 - Math.pow(1 - progress, 3);
      el.textContent = Math.round(eased * target) + suffix;
      if (progress < 1) { requestAnimationFrame(step); }
    }
    requestAnimationFrame(step);
  }

  if ('IntersectionObserver' in window) {
    var observer = new IntersectionObserver(function(entries){
      entries.forEach(function(entry){
        if (entry.isIntersecting) {
          animate(entry.target);
          observer.unobserve(entry.target);
        }
      });
    }, {threshold: 0.4});
    nums.forEach(function(el){ observer.observe(el); });
  } else {
    nums.forEach(function(el){ animate(el); });
  }
})();
</script>

<?php
// Bu şerit, denetleme bulgusuna göre orijinal boyuttaki görseli 150x190
// olarak göstermeden önce sunucu tarafında küçültüp önbelleğe alır.
// Bu dosya controller'sız doğrudan render edildiği için ($this burada
// Template nesnesine ait, Controller'a değil) model_tool_image->resize()
// çağrılamıyor; aynı mantık burada bağımsız bir fonksiyon olarak yeniden
// uygulanıyor.
if (!function_exists('eh12_bs_resize')) {
  function eh12_bs_resize($image_dir, $filename, $width, $height) {
    if (!is_file($image_dir . $filename)) { return $filename; }
    // model_tool_image->resize() ile aynı güvenlik kontrolü: dosya gerçekten
    // DIR_IMAGE altında mı (symlink/.. ile dışarı çıkılmış olabilir).
    $real = realpath($image_dir . $filename);
    if ($real === false || substr(str_replace('\\', '/', $real), 0, strlen($image_dir)) !== $image_dir) {
      return $filename;
    }
    $dot = mb_strrpos($filename, '.');
    if ($dot === false) { return $filename; }
    $extension = pathinfo($filename, PATHINFO_EXTENSION);
    $image_old = $filename;
    $image_new = 'cache/' . mb_substr($filename, 0, $dot) . '-' . (int)$width . 'x' . (int)$height . '.' . $extension;
    if (!is_file($image_dir . $image_new) || (filemtime($image_dir . $image_old) > filemtime($image_dir . $image_new))) {
      $info = @getimagesize($image_dir . $image_old);
      if (!$info || !in_array($info[2], array(IMAGETYPE_PNG, IMAGETYPE_JPEG, IMAGETYPE_GIF), true)) {
        return $image_old;
      }
      $path = '';
      foreach (explode('/', dirname($image_new)) as $directory) {
        $path .= '/' . $directory;
        if (!is_dir($image_dir . $path)) { @mkdir($image_dir . $path, 0777, true); }
      }
      if (class_exists('Image') && ($info[0] != $width || $info[1] != $height)) {
        $image = new Image($image_dir . $image_old);
        $image->resize($width, $height);
        $image->save($image_dir . $image_new);
      } else {
        @copy($image_dir . $image_old, $image_dir . $image_new);
      }
    }
    return str_replace(' ', '%20', $image_new);
  }
}

$eh12_bs_items = array();
if (defined('DB_HOSTNAME') && defined('DB_USERNAME') && defined('DB_PASSWORD') && defined('DB_DATABASE')) {
  $eh12_bs_conn = @mysqli_connect(DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE, defined('DB_PORT') ? (int)DB_PORT : 3306);
  if ($eh12_bs_conn) {
    @mysqli_set_charset($eh12_bs_conn, 'utf8');
    $eh12_bs_prefix = defined('DB_PREFIX') ? DB_PREFIX : 'oc_';
    $eh12_bs_res = @mysqli_query($eh12_bs_conn, "SELECT `setting` FROM `" . $eh12_bs_prefix . "module` WHERE `code` = 'egeser_references' ORDER BY `module_id` ASC LIMIT 1");
    if ($eh12_bs_res && mysqli_num_rows($eh12_bs_res)) {
      $eh12_bs_row = mysqli_fetch_assoc($eh12_bs_res);
      $eh12_bs_setting = json_decode($eh12_bs_row['setting'], true);
      if (is_array($eh12_bs_setting) && !empty($eh12_bs_setting['projects']) && is_array($eh12_bs_setting['projects'])) {
        foreach ($eh12_bs_setting['projects'] as $eh12_bs_p) {
          if (empty($eh12_bs_p['enabled']) || empty($eh12_bs_p['image'])) {
            continue;
          }
          if (!defined('DIR_IMAGE') || !is_file(DIR_IMAGE . $eh12_bs_p['image'])) {
            continue;
          }
          $eh12_bs_items[] = array(
            'image' => 'image/' . eh12_bs_resize(DIR_IMAGE, $eh12_bs_p['image'], 150, 190),
            'title' => isset($eh12_bs_p['title']) ? $eh12_bs_p['title'] : '',
            'type' => isset($eh12_bs_p['type']) ? $eh12_bs_p['type'] : (isset($eh12_bs_p['eyebrow']) ? $eh12_bs_p['eyebrow'] : ''),
            'location' => isset($eh12_bs_p['location']) ? $eh12_bs_p['location'] : '',
            'link' => !empty($eh12_bs_p['link']) ? $eh12_bs_p['link'] : '/projelerimiz'
          );
          if (count($eh12_bs_items) >= 16) {
            break;
          }
        }
      }
    }
    mysqli_close($eh12_bs_conn);
  }
}
?>
<?php if ($eh12_bs_items) { ?>
<section class="eh12-bestsellers">
  <div class="eh12-container">
    <div class="eh12-bestsellers__head">
      <span class="eh12-label">EN ÇOK TERCİH EDİLEN PROJELER</span>
    </div>
    <div class="eh12-bestsellers__track-wrap">
      <div class="eh12-bestsellers__track">
        <?php foreach (array_merge($eh12_bs_items, $eh12_bs_items) as $eh12_bs_item) { ?>
        <a class="eh12-bestsellers__item" href="<?php echo htmlspecialchars($eh12_bs_item['link'], ENT_QUOTES, 'UTF-8'); ?>">
          <img src="<?php echo htmlspecialchars($eh12_bs_item['image'], ENT_QUOTES, 'UTF-8'); ?>" alt="<?php echo htmlspecialchars($eh12_bs_item['title'], ENT_QUOTES, 'UTF-8'); ?>" width="150" height="190" loading="lazy" decoding="async">
          <?php if (!empty($eh12_bs_item['title']) || !empty($eh12_bs_item['location'])) { ?>
          <span class="eh12-bestsellers__cap">
            <?php if (!empty($eh12_bs_item['title'])) { ?><b><?php echo htmlspecialchars($eh12_bs_item['title'], ENT_QUOTES, 'UTF-8'); ?></b><?php } ?>
            <?php if (!empty($eh12_bs_item['location'])) { ?><small><?php echo htmlspecialchars($eh12_bs_item['location'], ENT_QUOTES, 'UTF-8'); ?></small><?php } ?>
          </span>
          <?php } ?>
        </a>
        <?php } ?>
      </div>
    </div>
  </div>
</section>
<?php } ?>

<section class="eh12-section" id="eh13-models">
  <div class="eh12-container">
    <div class="eh12-heading">
      <div><span class="eh12-label">PREFABRİK EV MODELLERİ</span><h2>Yaşam ihtiyacınıza göre doğru prefabrik ev tipini seçin.</h2></div>
      <p>Tek katlı ve çift katlı prefabrik ev seçeneklerini plan, kullanım şekli ve yaklaşık büyüklük ihtiyacınıza göre karşılaştırın.</p>
    </div>
    <div class="eh13-category-grid">
      <article class="eh13-category-card eh16-model-card">
        <div class="eh16-model-card__visual<?php echo $eh16_tek_img ? ' has-image' : ''; ?>"<?php if ($eh16_tek_img) { ?> style="background-image:url('<?php echo htmlspecialchars($eh16_tek_img, ENT_QUOTES, 'UTF-8'); ?>')"<?php } ?>>
          <span>TEK KATLI YAŞAM</span>
        </div>
        <div class="eh16-model-card__body">
          <small>BİREYSEL / TEK KAT</small>
          <h3>Tek Katlı Prefabrik Evler</h3>
          <p>Fonksiyonel planlama, farklı oda dağılımları ve tek katta yaşam konforu arayanlar için prefabrik ev çözümleri.</p>
        </div>
        <a href="<?php echo htmlspecialchars($eh13_url_tek, ENT_QUOTES, 'UTF-8'); ?>" aria-label="Tek katlı modelleri incele"><span>Tek katlı modelleri incele →</span></a>
      </article>
      <article class="eh13-category-card eh16-model-card">
        <div class="eh16-model-card__visual eh16-model-card__visual--cift<?php echo $eh16_cift_img ? ' has-image' : ''; ?>"<?php if ($eh16_cift_img) { ?> style="background-image:url('<?php echo htmlspecialchars($eh16_cift_img, ENT_QUOTES, 'UTF-8'); ?>')"<?php } ?>>
          <span>ÇİFT KATLI YAŞAM</span>
        </div>
        <div class="eh16-model-card__body">
          <small>BİREYSEL / DUBLEKS</small>
          <h3>Çift Katlı Prefabrik Evler</h3>
          <p>Daha geniş yaşam alanı ve katlara ayrılmış fonksiyon isteyen aileler için çift katlı prefabrik ev alternatifleri.</p>
        </div>
        <a href="<?php echo htmlspecialchars($eh13_url_cift, ENT_QUOTES, 'UTF-8'); ?>" aria-label="Çift katlı modelleri incele"><span>Çift katlı modelleri incele →</span></a>
      </article>
      <article class="eh13-category-card eh13-category-card--dark">
        <small>TÜM MODELLER</small>
        <h3>Prefabrik Ev ve Yapılar</h3>
        <p>Bireysel prefabrik evlerden kurumsal yapı çözümlerine kadar tüm ürün gruplarını tek sayfada inceleyin.</p>
        <a href="<?php echo htmlspecialchars($eh13_url_prefabrik, ENT_QUOTES, 'UTF-8'); ?>" aria-label="Tüm prefabrik yapıları gör"><span>Tüm prefabrik yapıları gör →</span></a>
      </article>
    </div>
  </div>
</section>

<section class="eh12-section" style="background:var(--eh12-soft)">
  <div class="eh12-container eh14-editorial">
    <div class="eh14-editorial__lead">
      <span class="eh12-label">NEDEN PREFABRİK?</span>
      <h2>Prefabrik ev neden tercih ediliyor?</h2>
      <p>Kontrollü üretim, planlanabilir uygulama ve farklı yaşam ihtiyaçlarına göre geliştirilebilen proje seçenekleri prefabrik yapı sisteminin temel avantajlarıdır.</p>
    </div>
    <div class="eh14-feature-list">
      <article class="eh14-feature"><b>01</b><div><h3>Kontrollü Üretim</h3><p>Yapı bileşenlerinin önemli bölümü üretim ortamında planlı şekilde hazırlanır.</p></div></article>
      <article class="eh14-feature"><b>02</b><div><h3>Planlanabilir Uygulama</h3><p>Üretim, sevkiyat ve montaj adımları proje kapsamına göre organize edilir.</p></div></article>
      <article class="eh14-feature"><b>03</b><div><h3>Farklı m² Seçenekleri</h3><p>Oda ihtiyacı, kullanım amacı ve arsa koşullarına göre farklı plan alternatifleri değerlendirilebilir.</p></div></article>
      <article class="eh14-feature"><b>04</b><div><h3>Tek / Çift Kat Alternatifi</h3><p>Tek ve çift katlı çözümler farklı aile yapıları ve kullanım senaryolarına cevap verir.</p></div></article>
      <article class="eh14-feature"><b>05</b><div><h3>Teknik Kapsam Seçenekleri</h3><p>Yalıtım, doğrama, iç donanım ve teknik detaylar proje kapsamına göre netleştirilir.</p></div></article>
      <article class="eh14-feature"><b>06</b><div><h3>Sahaya Göre Planlama</h3><p>Zemin, erişim, sevkiyat ve montaj koşulları proje başlangıcında birlikte değerlendirilir.</p></div></article>
    </div>
  </div>
</section>

<section class="eh12-section" id="eh12-solutions">
  <div class="eh12-container">
    <div class="eh12-heading">
      <div><span class="eh12-label">BİREYSEL &amp; KURUMSAL</span><h2>İki farklı ihtiyaç, tek üretim ve proje altyapısı.</h2></div>
      <p>Bireysel yaşam alanları ile kurumsal yapı projelerinin beklentileri farklıdır. Bu nedenle her iki alanı ayrı proje akışıyla ele alıyoruz.</p>
    </div>

    <div class="eh12-audience">
      <article class="eh12-audience-card">
        <small>BİREYSEL</small>
        <h3>Prefabrik Evler</h3>
        <p>Tek katlı ve çift katlı prefabrik ev modelleri; yaşam alışkanlıkları, oda ihtiyacı ve kurulum bölgesine göre değerlendirilir.</p>
        <div class="eh12-audience-links">
          <a href="<?php echo htmlspecialchars($eh13_url_tek, ENT_QUOTES, 'UTF-8'); ?>"><span>Tek Katlı Evler</span><b>→</b></a>
          <a href="<?php echo htmlspecialchars($eh13_url_cift, ENT_QUOTES, 'UTF-8'); ?>"><span>Çift Katlı Evler</span><b>→</b></a>
          <a href="<?php echo htmlspecialchars($eh13_url_ev_modelleri, ENT_QUOTES, 'UTF-8'); ?>"><span>Tüm Modeller</span><b>→</b></a>
          <a href="#eg-lead"><span>Ev İçin Teklif Al</span><b>→</b></a>
        </div>
      </article>

      <article class="eh12-audience-card eh12-audience-card--dark">
        <small>KURUMSAL</small>
        <h3>Kurumsal Prefabrik Yapılar</h3>
        <p>Ofis, yönetim binası, yatakhane, yemekhane, sosyal tesis, şantiye ve özel proje ihtiyaçları için ölçeklenebilir prefabrik çözümler.</p>
        <div class="eh12-audience-links">
          <a href="<?php echo htmlspecialchars($eh13_url_ofis, ENT_QUOTES, 'UTF-8'); ?>"><span>Ofis & Yönetim</span><b>→</b></a>
          <a href="<?php echo htmlspecialchars($eh13_url_yatakhane, ENT_QUOTES, 'UTF-8'); ?>"><span>Yatakhane</span><b>→</b></a>
          <a href="<?php echo htmlspecialchars($eh13_url_santiye, ENT_QUOTES, 'UTF-8'); ?>"><span>Şantiye Yapıları</span><b>→</b></a>
          <a href="<?php echo htmlspecialchars($eh13_url_ozel, ENT_QUOTES, 'UTF-8'); ?>"><span>Özel Proje</span><b>→</b></a>
        </div>
      </article>
    </div>
  </div>
</section>

<?php if (!empty($egeser_featured_products) && is_array($egeser_featured_products)) { ?>
<section class="eh12-section" style="background:var(--eh12-soft)">
  <div class="eh12-container">
    <div class="eh12-heading">
      <div><span class="eh12-label">ÖNE ÇIKAN MODELLER</span><h2>Prefabrik ev modellerini inceleyin.</h2></div>
      <p>Aktif prefabrik ev ürünleriniz arasından öne çıkan modeller otomatik olarak listelenir.</p>
    </div>

    <div class="eh12-products">
      <?php foreach (array_slice($egeser_featured_products, 0, 6) as $eg_product) { ?>
      <article class="eh12-product">
        <a class="eh12-product__media" href="<?php echo htmlspecialchars($eg_product['href'], ENT_QUOTES, 'UTF-8'); ?>" aria-label="<?php echo htmlspecialchars($eg_product['name'], ENT_QUOTES, 'UTF-8'); ?>">
          <?php if (!empty($eg_product['image'])) { ?>
            <img src="<?php echo htmlspecialchars($eg_product['image'], ENT_QUOTES, 'UTF-8'); ?>" alt="<?php echo htmlspecialchars($eg_product['name'], ENT_QUOTES, 'UTF-8'); ?>" width="480" height="360" loading="lazy" decoding="async">
          <?php } else { ?>
            <div class="eh12-product__placeholder">Ürün görseli hazırlanıyor</div>
          <?php } ?>
        </a>
        <div class="eh12-product__body">
          <small>PREFABRİK EV MODELİ</small>
          <h3><a href="<?php echo htmlspecialchars($eg_product['href'], ENT_QUOTES, 'UTF-8'); ?>" style="color:inherit"><?php echo htmlspecialchars($eg_product['name'], ENT_QUOTES, 'UTF-8'); ?></a></h3>
          <?php if (!empty($eg_product['area']) || !empty($eg_product['rooms']) || !empty($eg_product['floors'])) { ?>
          <div class="eh12-product__meta">
            <?php if (!empty($eg_product['area'])) { ?><span><?php echo htmlspecialchars($eg_product['area'], ENT_QUOTES, 'UTF-8'); ?></span><?php } ?>
            <?php if (!empty($eg_product['rooms'])) { ?><span><?php echo htmlspecialchars($eg_product['rooms'], ENT_QUOTES, 'UTF-8'); ?></span><?php } ?>
            <?php if (!empty($eg_product['floors'])) { ?><span><?php echo htmlspecialchars($eg_product['floors'], ENT_QUOTES, 'UTF-8'); ?></span><?php } ?>
          </div>
          <?php } ?>
          <a href="<?php echo htmlspecialchars($eg_product['href'], ENT_QUOTES, 'UTF-8'); ?>">Modeli İncele →</a>
        </div>
      </article>
      <?php } ?>
    </div>
  </div>
</section>
<?php } ?>

<section class="eh12-section">
  <div class="eh12-container eh14-corp-showcase">
    <div class="eh14-corp-intro">
      <span class="eh12-label">KURUMSAL ÇÖZÜMLER</span>
      <h2>İşletmeler ve projeler için ölçeklenebilir prefabrik yapılar.</h2>
      <p>Ofisten yatakhaneye, yemekhaneden şantiye ve sosyal tesis yapılarına kadar kapasite, saha koşulları ve teknik ihtiyaçlara göre proje geliştiriyoruz.</p>
      <a class="eh12-btn eh12-btn--red" href="#eg-lead">Kurumsal Proje Teklifi Al</a>
    </div>
    <div class="eh14-corp-list">
      <a class="eh14-corp-row" href="<?php echo htmlspecialchars($eh13_url_ofis, ENT_QUOTES, 'UTF-8'); ?>"><b>01</b><div><strong>Ofis &amp; Yönetim Binaları</strong><span>İdari, ticari ve operasyonel kullanım alanları</span></div><i>→</i></a>
      <a class="eh14-corp-row" href="<?php echo htmlspecialchars($eh13_url_yatakhane, ENT_QUOTES, 'UTF-8'); ?>"><b>02</b><div><strong>Yatakhane Binaları</strong><span>Personel konaklama ve kamp kullanım projeleri</span></div><i>→</i></a>
      <a class="eh14-corp-row" href="<?php echo htmlspecialchars($eh13_url_yemekhane, ENT_QUOTES, 'UTF-8'); ?>"><b>03</b><div><strong>Yemekhane Binaları</strong><span>Toplu kullanım ve servis alanları</span></div><i>→</i></a>
      <a class="eh14-corp-row" href="<?php echo htmlspecialchars($eh13_url_santiye, ENT_QUOTES, 'UTF-8'); ?>"><b>04</b><div><strong>Şantiye Yapıları</strong><span>Saha ofisi, yatakhane ve destek yapıları</span></div><i>→</i></a>
      <a class="eh14-corp-row" href="<?php echo htmlspecialchars($eh13_url_sosyal, ENT_QUOTES, 'UTF-8'); ?>"><b>05</b><div><strong>Sosyal Tesis Yapıları</strong><span>Çok amaçlı sosyal ve ortak kullanım alanları</span></div><i>→</i></a>
      <a class="eh14-corp-row" href="<?php echo htmlspecialchars($eh13_url_ozel, ENT_QUOTES, 'UTF-8'); ?>"><b>06</b><div><strong>Özel Proje Yapıları</strong><span>Standart dışı ihtiyaçlara göre özel projelendirme</span></div><i>→</i></a>
    </div>
  </div>
</section>

<section class="eh12-section">
  <div class="eh12-container">
    <div class="eh12-why">
      <div class="eh12-why__grid">
        <div>
          <span class="eh12-label">NEDEN EGESER?</span>
          <h2>Sadece yapıyı değil, tüm süreci yönetiyoruz.</h2>
          <p>Projelendirme, üretim, sevkiyat ve montajın farklı ekiplerde kopuk ilerlemesi yerine tek merkezden takip edilen daha kontrollü bir proje akışı hedefliyoruz.</p>
          <div style="margin-top:22px"><a class="eh12-btn eh12-btn--red" href="#eg-lead">Projenizi Konuşalım</a></div>
        </div>

        <div class="eh12-why-list">
          <article><strong>01</strong><h3>Üretim Kontrolü</h3><p>Malzeme ve imalat adımlarını üretim sürecinde takip ediyoruz.</p></article>
          <article><strong>02</strong><h3>Proje Desteği</h3><p>Kullanım amacı ve ihtiyaçlara göre plan değerlendirmesi yapıyoruz.</p></article>
          <article><strong>03</strong><h3>Planlı Montaj</h3><p>Sevkiyat ve saha uygulamasını proje koşullarına göre planlıyoruz.</p></article>
          <article><strong>04</strong><h3>Satış Sonrası İletişim</h3><p>Teslim sonrasında ihtiyaç duyulan konularda iletişimi sürdürüyoruz.</p></article>
        </div>
      </div>
    </div>
  </div>
</section>

<?php if (!empty($egeser_home_projects) && is_array($egeser_home_projects)) { ?>
<section class="eh12-section" style="background:var(--eh12-soft)">
  <div class="eh12-container">
    <div class="eh12-heading">
      <div>
        <span class="eh12-label">PROJELER / REFERANSLAR</span>
        <h2>Tamamlanan prefabrik yapı projelerimiz.</h2>
      </div>
      <p>Tamamlanan bireysel ve kurumsal prefabrik yapı uygulamalarından seçili referanslar.</p>
    </div>

    <div class="eh12-projects">
      <?php foreach (array_slice($egeser_home_projects, 0, 3) as $eg_project) { ?>
      <article class="eh12-project">
        <?php if (!empty($eg_project['link'])) { ?>
        <a class="eh12-project__media" href="<?php echo htmlspecialchars($eg_project['link'], ENT_QUOTES, 'UTF-8'); ?>" aria-label="<?php echo htmlspecialchars($eg_project['title'], ENT_QUOTES, 'UTF-8'); ?>">
        <?php } else { ?>
        <div class="eh12-project__media">
        <?php } ?>

          <?php if (!empty($eg_project['image'])) { ?>
            <img src="<?php echo htmlspecialchars($eg_project['image'], ENT_QUOTES, 'UTF-8'); ?>"
                 alt="<?php echo htmlspecialchars($eg_project['title'], ENT_QUOTES, 'UTF-8'); ?>"
                 width="560" height="420" loading="lazy" decoding="async">
          <?php } else { ?>
            <div class="eh12-project__placeholder">Proje görseli eklenecek</div>
          <?php } ?>

          <?php if (!empty($eg_project['type'])) { ?>
            <span class="eh12-project__badge"><?php echo htmlspecialchars($eg_project['type'], ENT_QUOTES, 'UTF-8'); ?></span>
          <?php } ?>

        <?php if (!empty($eg_project['link'])) { ?></a><?php } else { ?></div><?php } ?>

        <div class="eh12-project__body">
          <?php if (!empty($eg_project['eyebrow'])) { ?>
            <small><?php echo htmlspecialchars($eg_project['eyebrow'], ENT_QUOTES, 'UTF-8'); ?></small>
          <?php } ?>

          <h3>
            <?php if (!empty($eg_project['link'])) { ?><a href="<?php echo htmlspecialchars($eg_project['link'], ENT_QUOTES, 'UTF-8'); ?>" style="color:inherit"><?php } ?>
            <?php echo htmlspecialchars($eg_project['title'], ENT_QUOTES, 'UTF-8'); ?>
            <?php if (!empty($eg_project['link'])) { ?></a><?php } ?>
          </h3>

          <?php if (!empty($eg_project['description'])) { ?>
            <p><?php echo htmlspecialchars($eg_project['description'], ENT_QUOTES, 'UTF-8'); ?></p>
          <?php } ?>

          <?php if (!empty($eg_project['location']) || !empty($eg_project['size'])) { ?>
            <div class="eh12-project__meta">
              <?php if (!empty($eg_project['location'])) { ?><span><?php echo htmlspecialchars($eg_project['location'], ENT_QUOTES, 'UTF-8'); ?></span><?php } ?>
              <?php if (!empty($eg_project['size'])) { ?><span><?php echo htmlspecialchars($eg_project['size'], ENT_QUOTES, 'UTF-8'); ?></span><?php } ?>
            </div>
          <?php } ?>

          <?php if (!empty($eg_project['link'])) { ?>
            <a class="eh12-project__link" href="<?php echo htmlspecialchars($eg_project['link'], ENT_QUOTES, 'UTF-8'); ?>">Projeyi İncele</a>
          <?php } ?>
        </div>
      </article>
      <?php } ?>
    </div>

    <div style="margin-top:20px">
      <a class="eh12-btn eh12-btn--ghost" href="<?php echo !empty($egeser_url_referanslar) ? $egeser_url_referanslar : 'projelerimiz'; ?>">Tüm Projeleri İncele</a>
    </div>
  </div>
</section>
<?php } ?>

<section class="eh12-section">
  <div class="eh12-container">
    <div class="eh13-price">
      <div>
        <span class="eh12-label">PREFABRİK EV FİYATLARI</span>
        <h2>Prefabrik ev fiyatları neye göre belirlenir?</h2>
        <p>Prefabrik ev maliyeti yalnızca m² üzerinden değerlendirilmez. Kat sayısı, oda planı, yalıtım ve cephe sistemi, doğrama, iç donanım, sevkiyat mesafesi, saha koşulları ve montaj kapsamı toplam teklifi etkileyebilir.</p>
        <div style="margin-top:22px"><a class="eh12-btn eh12-btn--red" href="#eg-lead">Projeniz İçin Fiyat / Teklif Al</a></div>
      </div>
      <div class="eh13-price-grid">
        <article><strong>m² &amp; Plan</strong><span>Yapı büyüklüğü ve oda dağılımı</span></article>
        <article><strong>Kat Sayısı</strong><span>Tek kat veya çift kat proje</span></article>
        <article><strong>Yalıtım &amp; Cephe</strong><span>Teknik sistem ve malzeme kapsamı</span></article>
        <article><strong>İç Donanım</strong><span>Mutfak, banyo ve seçilen uygulamalar</span></article>
        <article><strong>Sevkiyat</strong><span>Kurulum bölgesi ve lojistik mesafesi</span></article>
        <article><strong>Saha &amp; Montaj</strong><span>Erişim, zemin ve uygulama koşulları</span></article>
      </div>
    </div>
  </div>
</section>

<section class="eh12-section">
  <div class="eh12-container">
    <div class="eh12-heading">
      <div><span class="eh12-label">PROJE SÜRECİ</span><h2>İhtiyaçtan teslime 6 net adım.</h2></div>
      <p>Teklif öncesi analizden başlayıp üretim, sevkiyat ve montajla tamamlanan şeffaf süreç.</p>
    </div>
    <div class="eh12-process">
      <article class="eh12-step"><span>01</span><div><h3>İhtiyaç Analizi</h3><p>Kullanım amacı, m² ve lokasyon belirlenir.</p></div></article>
      <article class="eh12-step"><span>02</span><div><h3>Plan</h3><p>Model ve kullanım planı değerlendirilir.</p></div></article>
      <article class="eh12-step"><span>03</span><div><h3>Teknik Kapsam</h3><p>Yapı, yalıtım ve tesisat detayları netleşir.</p></div></article>
      <article class="eh12-step"><span>04</span><div><h3>Teklif & Onay</h3><p>Proje kapsamına göre teklif hazırlanır.</p></div></article>
      <article class="eh12-step"><span>05</span><div><h3>Üretim & Sevkiyat</h3><p>Üretim tamamlanır ve saha sevki planlanır.</p></div></article>
      <article class="eh12-step"><span>06</span><div><h3>Montaj & Teslim</h3><p>Saha uygulaması ve teslim kontrolleri yapılır.</p></div></article>
    </div>
  </div>
</section>

<section class="eh12-section eh17-service-region" id="hizmet-bolgeleri">
  <div class="eh12-container">
    <div class="eh12-heading eh17-region-heading">
      <div>
        <span class="eh12-label">İZMİR MERKEZLİ EGE BÖLGESİ</span>
        <h2>Prefabrik yapı çözümlerinde hizmet bölgelerimiz.</h2>
      </div>
      <p>Kemalpaşa / İzmir merkezli üretim altyapımızla; proje kapsamı, saha erişimi, sevkiyat ve montaj koşullarını bölge bazında değerlendiriyoruz.</p>
    </div>

    <div class="eh17-city-grid" aria-label="Prefabrik yapı hizmet bölgeleri">
      <article class="eh17-city-card eh17-city-card--primary">
        <div class="eh17-city-card__top"><span>01</span><small>MERKEZ BÖLGE</small></div>
        <h3>İzmir Prefabrik Yapı Çözümleri</h3>
        <p>Prefabrik ev ve kurumsal yapı projelerinde saha erişimi, zemin hazırlığı, sevkiyat ve montaj planlamasını Kemalpaşa merkezli değerlendiriyoruz.</p>
        <a class="eh17-city-action" href="<?php echo htmlspecialchars($eh17_city_base . 'izmir-prefabrik-ev', ENT_QUOTES, 'UTF-8'); ?>">İzmir sayfasını incele <b>→</b></a>
      </article>

      <article class="eh17-city-card">
        <div class="eh17-city-card__top"><span>02</span><small>EGE BÖLGESİ</small></div>
        <h3>Manisa Prefabrik Yapı Çözümleri</h3>
        <p>Manisa ve ilçelerindeki projelerde yapı tipi, saha koşulları ve lojistik gereksinimler proje başlangıcında birlikte değerlendirilir.</p>
        <a class="eh17-city-action" href="<?php echo htmlspecialchars($eh17_city_base . 'manisa-prefabrik-ev', ENT_QUOTES, 'UTF-8'); ?>">Manisa sayfasını incele <b>→</b></a>
      </article>

      <article class="eh17-city-card">
        <div class="eh17-city-card__top"><span>03</span><small>EGE BÖLGESİ</small></div>
        <h3>Aydın Prefabrik Yapı Çözümleri</h3>
        <p>Aydın bölgesindeki bireysel ve kurumsal prefabrik projelerde sevkiyat, montaj alanı ve uygulama koşulları proje bazında planlanır.</p>
        <a class="eh17-city-action" href="<?php echo htmlspecialchars($eh17_city_base . 'aydin-prefabrik-ev', ENT_QUOTES, 'UTF-8'); ?>">Aydın sayfasını incele <b>→</b></a>
      </article>

      <article class="eh17-city-card">
        <div class="eh17-city-card__top"><span>04</span><small>EGE BÖLGESİ</small></div>
        <h3>Uşak Prefabrik Yapı Çözümleri</h3>
        <p>Uşak projelerinde yapı büyüklüğü, sevkiyat güzergâhı, saha erişimi ve montaj şartları teknik kapsamla birlikte ele alınır.</p>
        <a class="eh17-city-action" href="<?php echo htmlspecialchars($eh17_city_base . 'usak-prefabrik-ev', ENT_QUOTES, 'UTF-8'); ?>">Uşak sayfasını incele <b>→</b></a>
      </article>

      <article class="eh17-city-card">
        <div class="eh17-city-card__top"><span>05</span><small>EGE / MARMARA GEÇİŞİ</small></div>
        <h3>Balıkesir Prefabrik Yapı Çözümleri</h3>
        <p>Balıkesir bölgesindeki projelerde teslim kapsamı; proje türü, mesafe, saha şartları ve montaj organizasyonuna göre netleştirilir.</p>
        <a class="eh17-city-action" href="<?php echo htmlspecialchars($eh17_city_base . 'balikesir-prefabrik-ev', ENT_QUOTES, 'UTF-8'); ?>">Balıkesir sayfasını incele <b>→</b></a>
      </article>

      <article class="eh17-city-card">
        <div class="eh17-city-card__top"><span>06</span><small>GÜNEY EGE</small></div>
        <h3>Muğla Prefabrik Yapı Çözümleri</h3>
        <p>Muğla ve çevresindeki projelerde saha erişimi ve lojistik koşullar dikkate alınarak üretim, sevkiyat ve montaj kapsamı planlanır.</p>
        <a class="eh17-city-action" href="<?php echo htmlspecialchars($eh17_city_base . 'mugla-prefabrik-ev', ENT_QUOTES, 'UTF-8'); ?>">Muğla sayfasını incele <b>→</b></a>
      </article>
    </div>

    <div class="eh17-region-note">
      <div><strong>Kemalpaşa / İzmir merkezli üretim</strong><span>Projelendirme, üretim, sevkiyat ve montaj süreçleri tek akışta planlanır.</span></div>
      <a href="#eg-lead">Hizmet bölgeniz için teklif alın →</a>
    </div>
  </div>
</section>


<section class="eh12-section">
  <div class="eh12-container">
    <div class="eh14-knowledge-strip">
      <div class="eh14-knowledge-intro">
        <span class="eh12-label">TEKNİK BİLGİ MERKEZİ</span>
        <h2>Prefabrik yapı hakkında bilmeniz gerekenler.</h2>
      </div>
      <a class="eh14-knowledge-link" href="<?php echo htmlspecialchars($eh13_url_teknik, ENT_QUOTES, 'UTF-8'); ?>"><div><small>TEKNİK</small><strong>Duvar ve Çatı Sistemi</strong></div><span>Detayları incele →</span></a>
      <a class="eh14-knowledge-link" href="<?php echo htmlspecialchars($eh13_url_teknik, ENT_QUOTES, 'UTF-8'); ?>"><div><small>KONFOR</small><strong>Isı ve Ses Yalıtımı</strong></div><span>Detayları incele →</span></a>
      <a class="eh14-knowledge-link" href="<?php echo htmlspecialchars($eh13_url_teknik, ENT_QUOTES, 'UTF-8'); ?>"><div><small>SAHA</small><strong>Temel / Zemin Hazırlığı</strong></div><span>Detayları incele →</span></a>
      <a class="eh14-knowledge-link" href="<?php echo htmlspecialchars($eh13_url_teknik, ENT_QUOTES, 'UTF-8'); ?>"><div><small>UYGULAMA</small><strong>Montaj Süreci</strong></div><span>Detayları incele →</span></a>
    </div>
  </div>
</section>

<section class="eh12-section" style="background:var(--eh12-soft)">
  <div class="eh12-container">
    <div class="eh12-heading">
      <div><span class="eh12-label">SIK SORULANLAR</span><h2>Prefabrik yapılar hakkında merak edilenler.</h2></div>
      <p>Satın alma ve proje öncesinde en sık karşılaşılan temel sorular.</p>
    </div>
    <div class="eh12-faq">
      <details><summary>Prefabrik ev fiyatları nasıl hesaplanır?</summary><p>Fiyat; m², kat sayısı, plan, teknik özellikler, iç donanım, sevkiyat mesafesi, saha koşulları ve montaj kapsamına göre proje bazında belirlenir.</p></details>
      <details><summary>Prefabrik ev planında değişiklik yapılabilir mi?</summary><p>Plan değişikliği; taşıyıcı sistem, üretim ve tesisat koşulları birlikte değerlendirilerek proje aşamasında netleştirilebilir.</p></details>
      <details><summary>Prefabrik ev için ruhsat gerekir mi?</summary><p>Ruhsat ve imar gereklilikleri arsanın bulunduğu yere ve projenin niteliğine göre değişebilir. Uygulama öncesinde ilgili belediye ve yetkili kurumlarla güncel koşulların doğrulanması gerekir.</p></details>
      <details><summary>Prefabrik ev kurulumu ne kadar sürer?</summary><p>Süre; yapının büyüklüğü, proje kapsamı, üretim planı, saha hazırlığı ve montaj koşullarına göre değişir. Net süre teklif ve proje aşamasında belirlenir.</p></details>
      <details><summary>Prefabrik evde ısı ve ses yalıtımı nasıl planlanır?</summary><p>Yalıtım performansı; duvar ve çatı sistemi, kullanılan katmanlar, doğrama ve uygulama detaylarının birlikte değerlendirilmesiyle şekillenir.</p></details>
      <details><summary>Prefabrik yapı hangi zemine kurulur?</summary><p>Uygun temel ve zemin hazırlığı proje ve saha koşullarına göre belirlenir. Kurulum öncesinde erişim, kot, drenaj ve temel gereksinimleri değerlendirilmelidir.</p></details>
      <details><summary>Kurumsal projeler özel ölçüde hazırlanabilir mi?</summary><p>Ofis, yatakhane, yemekhane, şantiye ve sosyal tesis yapılarında kullanım amacı, kapasite ve saha ihtiyaçlarına göre özel proje çalışması yapılabilir.</p></details>
      <details><summary>Sevkiyat ve montaj hizmeti veriliyor mu?</summary><p>Projenin kapsamı ve kurulum bölgesine göre üretim, sevkiyat ve montaj süreçleri birlikte planlanabilir.</p></details>
    </div>
    <p style="margin:18px 0 0"><a href="/sss" style="font-weight:800;font-size:13px;color:#181818;text-decoration:none;border-bottom:2px solid var(--eh12-red);padding-bottom:2px">Tüm soruları görüntüleyin →</a></p>
  </div>
</section>


<script type="application/ld+json"><?php
echo json_encode(array(
  '@context' => 'https://schema.org',
  '@type' => 'FAQPage',
  'mainEntity' => array(
    array('@type'=>'Question','name'=>'Prefabrik ev fiyatları nasıl hesaplanır?','acceptedAnswer'=>array('@type'=>'Answer','text'=>'Fiyat; m², kat sayısı, plan, teknik özellikler, iç donanım, sevkiyat mesafesi, saha koşulları ve montaj kapsamına göre proje bazında belirlenir.')),
    array('@type'=>'Question','name'=>'Prefabrik ev planında değişiklik yapılabilir mi?','acceptedAnswer'=>array('@type'=>'Answer','text'=>'Plan değişikliği; taşıyıcı sistem, üretim ve tesisat koşulları birlikte değerlendirilerek proje aşamasında netleştirilebilir.')),
    array('@type'=>'Question','name'=>'Prefabrik ev için ruhsat gerekir mi?','acceptedAnswer'=>array('@type'=>'Answer','text'=>'Ruhsat ve imar gereklilikleri arsanın bulunduğu yere ve projenin niteliğine göre değişebilir. Uygulama öncesinde ilgili belediye ve yetkili kurumlarla güncel koşulların doğrulanması gerekir.')),
    array('@type'=>'Question','name'=>'Prefabrik ev kurulumu ne kadar sürer?','acceptedAnswer'=>array('@type'=>'Answer','text'=>'Süre; yapının büyüklüğü, proje kapsamı, üretim planı, saha hazırlığı ve montaj koşullarına göre değişir. Net süre teklif ve proje aşamasında belirlenir.'))
  )
), JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
?></script>

<section class="eh12-section" id="eg-lead">
  <div class="eh12-container">
    <div class="eh12-offer">
      <div>
        <span class="eh12-label">PROJE TEKLİFİ</span>
        <h2>Projenizi anlatın, size uygun prefabrik çözümü birlikte planlayalım.</h2>
        <p>Yapı türü, yaklaşık m² ve uygulama yerini paylaşın. Satış ekibimiz projenizin kapsamına göre ön değerlendirme yaparak sizinle iletişime geçsin.</p>
        <div style="margin-top:20px"><a class="eh12-btn eh12-btn--dark" href="<?php echo $eh12_phone_href; ?>">Telefonla Ara</a></div>
      </div>

      <div>
        <?php
        $eg_form_context = 'home-v17-final';
        $eg_form_title = 'Projeniz İçin Teklif Alın';
        $eg_form_product_id = 0;
        $eg_form_product_name = '';
        $eg_form_source = 'Ana Sayfa V17 Final';
        include(DIR_TEMPLATE . 'egeser/template/extension/module/egeser_lead_form.tpl');
        ?>
      </div>
    </div>
  </div>
</section>

<section class="eh12-section eh17-location-section" style="background:var(--eh12-soft)" id="konum">
  <div class="eh12-container">
    <div class="eh17-location">
      <div class="eh17-location__content">
        <span class="eh12-label">SHOWROOM &amp; ÜRETİM</span>
        <h2>Egeser Prefabrik'e ulaşın.</h2>
        <p>Projenizi yerinde görüşmek, ürün ve uygulama detaylarını değerlendirmek için bizimle iletişime geçebilirsiniz.</p>

        <div class="eh17-location__details">
          <article>
            <small>ADRES / ÜRETİM</small>
            <strong>Çambel Mevkii, Kemalpaşa / İzmir</strong>
            <span>Showroom ve üretim lokasyonu</span>
          </article>
          <article>
            <small>TELEFON</small>
            <strong><a href="<?php echo $eh12_phone_href; ?>"><?php echo htmlspecialchars($eh12_phone, ENT_QUOTES, 'UTF-8'); ?></a></strong>
            <span>Satış ve proje danışmanlığı</span>
          </article>
          <article>
            <small>WHATSAPP</small>
            <strong><a href="https://wa.me/<?php echo htmlspecialchars($egeser_whatsapp, ENT_QUOTES, 'UTF-8'); ?>?text=<?php echo rawurlencode('Merhaba, prefabrik yapı modelleriniz hakkında bilgi ve teklif almak istiyorum.'); ?>" target="_blank" rel="noopener">WhatsApp'tan yazın</a></strong>
            <span>Hızlı bilgi ve teklif talebi</span>
          </article>
          <article>
            <small>E-POSTA</small>
            <strong><a href="<?php echo htmlspecialchars($eh17_email_href, ENT_QUOTES, 'UTF-8'); ?>"><?php echo htmlspecialchars($eh17_email, ENT_QUOTES, 'UTF-8'); ?></a></strong>
            <span>Kurumsal iletişim ve doküman paylaşımı</span>
          </article>
        </div>

        <div class="eh17-location__actions">
          <a class="eh12-btn eh12-btn--red" href="#eg-lead">Teklif Al</a>
          <a class="eh12-btn eh12-btn--ghost" href="<?php echo $eh12_phone_href; ?>">Telefonla Ara</a>
          <a class="eh12-btn eh12-btn--ghost" href="<?php echo htmlspecialchars($eh17_maps_href, ENT_QUOTES, 'UTF-8'); ?>" target="_blank" rel="noopener" data-eg-track="map_click" data-placement="home">Haritada Aç</a>
        </div>
      </div>

      <div class="eh17-map" aria-label="Egeser Prefabrik Kemalpaşa İzmir haritası">
        <iframe
          title="Egeser Prefabrik - Kemalpaşa İzmir konumu"
          src="https://www.google.com/maps?q=38.44988554328141,27.497831062110418&amp;z=18&amp;output=embed"
          width="600"
          height="450"
          style="border:0"
          loading="lazy"
          referrerpolicy="no-referrer-when-downgrade"
          allowfullscreen></iframe>
        <div class="eh17-map__caption">
          <span>Kemalpaşa / İzmir</span>
          <strong>Showroom &amp; Üretim</strong>
        </div>
      </div>
    </div>
  </div>
</section>


</main>
<?php echo $footer; ?>
