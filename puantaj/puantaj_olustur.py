#!/usr/bin/env python3
"""
Yıllık Puantaj ve Mesai Takip Sistemi oluşturucu.

Kullanım:
    python puantaj_olustur.py                                  # içinde bulunulan yıl, örnek personel
    python puantaj_olustur.py --yil 2027 --ornek-veri-yok      # boş şablon
    python puantaj_olustur.py --aktar EYLUL_AYI_PUANTAJI.xlsx  # eski puantajı içe aktar

Oluşan çalışma kitabı:
    Yillik_Rapor      : Tüm ayları dinamik formüllerle toplayan icmal sayfası
    Aylik_Rapor       : Açılır listeden seçilen ayın personel özeti + 12 ay karşılaştırması
    Personel_Listesi  : Personel tek yerden girilir (işe giriş / ayrılış tarihleri dahil)
    Kodlar_Tatiller   : Puantaj kodlarının anlamı/değeri ve resmi tatil listesi (düzenlenebilir)
    Ocak ... Aralık   : Aylık puantaj ve mesai giriş sayfaları

Varsayılan puantaj kodları (Kodlar_Tatiller sayfasından değiştirilebilir):
    X  Geldi   |  YARIM / GY  Yarım gün  |  Y  Gelmedi  |  V  Vizite (rapor)
    İ  Yıllık izin  |  Ü  Ücretsiz izin  |  RT  Resmi tatil
"""

import argparse
import calendar
import datetime as dt
import random

from openpyxl import Workbook, load_workbook
from openpyxl.formatting.rule import FormulaRule
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side
from openpyxl.utils import get_column_letter
from openpyxl.workbook.defined_name import DefinedName
from openpyxl.worksheet.datavalidation import DataValidation

# --------------------------------------------------------------------------- #
# Ayarlar
# --------------------------------------------------------------------------- #
PERSONEL_KAPASITE = 25          # Her ay sayfasındaki personel satırı sayısı
KOD_KAPASITE = 20               # Kodlar tablosundaki satır sayısı
TATIL_KAPASITE = 40             # Tatil listesindeki satır sayısı
HAFTA_TATILI = 7                # 1=Pazartesi ... 7=Pazar (gölgelenecek gün)
VARSAYILAN_CIKTI = "Puantaj_Takip_Sistemi.xlsx"

AYLAR = ["Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran",
         "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"]

# Renk grupları: (dolgu, yazı rengi)
GRUPLAR = {
    "ÇALIŞTI": ("C6EFCE", "006100"),
    "YARIM": ("FFEB9C", "9C5700"),
    "DEVAMSIZ": ("FFC7CE", "9C0006"),
    "İZİN": ("BDD7EE", "1F4E78"),
    "TATİL": ("E4DFEC", "5B3A7A"),
}
BILINMEYEN_KOD = ("F4B183", "833C0B")

# Kod, Açıklama, Çalışılan gün, Devamsızlık, İzin/Rapor, Yemek, Renk grubu
VARSAYILAN_KODLAR = [
    ("X", "Geldi (tam gün)", 1, 0, 0, 1, "ÇALIŞTI"),
    ("YARIM", "Yarım gün çalıştı", 0.5, 0.5, 0, 1, "YARIM"),
    ("GY", "Yarım gün (GY)", 0.5, 0.5, 0, 1, "YARIM"),
    ("Y", "Gelmedi (yok)", 0, 1, 0, 0, "DEVAMSIZ"),
    ("V", "Vizite / sağlık raporu", 0, 0, 1, 0, "İZİN"),
    ("İ", "Yıllık ücretli izin", 0, 0, 1, 0, "İZİN"),
    ("Ü", "Ücretsiz izin", 0, 0, 1, 0, "İZİN"),
    ("RT", "Resmi tatil (çalışmadı)", 0, 0, 0, 0, "TATİL"),
]

SABIT_TATILLER = [
    (1, 1, "Yılbaşı"),
    (4, 23, "Ulusal Egemenlik ve Çocuk Bayramı"),
    (5, 1, "Emek ve Dayanışma Günü"),
    (5, 19, "Atatürk'ü Anma, Gençlik ve Spor Bayramı"),
    (7, 15, "Demokrasi ve Millî Birlik Günü"),
    (8, 30, "Zafer Bayramı"),
    (10, 29, "Cumhuriyet Bayramı"),
]
# Dini bayramlar her yıl değişir; bilinmeyen yıllar için Kodlar_Tatiller sayfasına elle eklenmelidir.
DINI_BAYRAMLAR = {
    2025: [("2025-03-30", "Ramazan Bayramı 1. gün"), ("2025-03-31", "Ramazan Bayramı 2. gün"),
           ("2025-04-01", "Ramazan Bayramı 3. gün"), ("2025-06-06", "Kurban Bayramı 1. gün"),
           ("2025-06-07", "Kurban Bayramı 2. gün"), ("2025-06-08", "Kurban Bayramı 3. gün"),
           ("2025-06-09", "Kurban Bayramı 4. gün")],
    2026: [("2026-03-20", "Ramazan Bayramı 1. gün"), ("2026-03-21", "Ramazan Bayramı 2. gün"),
           ("2026-03-22", "Ramazan Bayramı 3. gün"), ("2026-05-27", "Kurban Bayramı 1. gün"),
           ("2026-05-28", "Kurban Bayramı 2. gün"), ("2026-05-29", "Kurban Bayramı 3. gün"),
           ("2026-05-30", "Kurban Bayramı 4. gün")],
}

ORNEK_PERSONEL = [
    ("AHMET YILMAZ", "ŞANTİYE"),
    ("AYŞE DEMİR", "MUHASEBE"),
    ("MEHMET KAYA", "FABRİKA"),
    ("FATMA ŞAHİN", "OFİS"),
    ("MUSTAFA ÇELİK", "FABRİKA"),
    ("ZEYNEP ARSLAN", "ŞANTİYE"),
    ("EMRE ÖZTÜRK", "FABRİKA"),
]

# --------------------------------------------------------------------------- #
# Stil paleti
# --------------------------------------------------------------------------- #
FONT_ADI = "Calibri"

LACIVERT = "1F3864"
CELIK_MAVI = "2E75B6"
ACIK_MAVI = "DDEBF7"
ZEBRA = "F3F7FB"
KENAR_GRI = "A6B8D4"
BEYAZ = "FFFFFF"

F_BASLIK = Font(name=FONT_ADI, size=18, bold=True, color=BEYAZ)
F_ALT_BASLIK = Font(name=FONT_ADI, size=10, italic=True, color=LACIVERT)
F_TABLO_BASLIK = Font(name=FONT_ADI, size=10, bold=True, color=BEYAZ)
F_KUCUK_BASLIK = Font(name=FONT_ADI, size=7, bold=True, color=BEYAZ)
F_NORMAL = Font(name=FONT_ADI, size=11)
F_KOD = Font(name=FONT_ADI, size=10, bold=True)
F_AD = Font(name=FONT_ADI, size=12, bold=True, color=LACIVERT)
F_KALIN = Font(name=FONT_ADI, size=11, bold=True, color=LACIVERT)
F_OZET = Font(name=FONT_ADI, size=12, bold=True, color=LACIVERT)
F_KPI_DEGER = Font(name=FONT_ADI, size=18, bold=True, color=LACIVERT)
F_KPI_ETIKET = Font(name=FONT_ADI, size=9, bold=True, color=CELIK_MAVI)

DOLGU_LACIVERT = PatternFill("solid", fgColor=LACIVERT)
DOLGU_CELIK = PatternFill("solid", fgColor=CELIK_MAVI)
DOLGU_ACIK_MAVI = PatternFill("solid", fgColor=ACIK_MAVI)
DOLGU_ZEBRA = PatternFill("solid", fgColor=ZEBRA)
DOLGU_BEYAZ = PatternFill("solid", fgColor=BEYAZ)
DOLGU_GIRIS = PatternFill("solid", fgColor="FFF2CC")

INCE = Side(style="thin", color=KENAR_GRI)
ORTA = Side(style="medium", color=LACIVERT)
KENAR = Border(left=INCE, right=INCE, top=INCE, bottom=INCE)
KENARSIZ = Border()

ORTALI = Alignment(horizontal="center", vertical="center", wrap_text=True)
DIKEY = Alignment(horizontal="center", vertical="center", text_rotation=90, wrap_text=True)
SOLA = Alignment(horizontal="left", vertical="center", indent=1)

# --------------------------------------------------------------------------- #
# Yerleşim sabitleri
# --------------------------------------------------------------------------- #
# Ay sayfası
AY_GUN_SATIR = 3             # Gün numarası
AY_TARIH_SATIR = 4           # Gün adı (dikey)
AY_ALT_BASLIK_SATIR = 5      # GÜN / MESAİ
AY_ILK_VERI = 6
AY_SON_VERI = AY_ILK_VERI + PERSONEL_KAPASITE - 1
AY_YEMEK_SATIR = AY_SON_VERI + 1
AY_MESAI_SATIR = AY_SON_VERI + 2

# Sol taraftaki özet sütunları (tüm aylarda aynı yerde -> raporlar sabit sütun okur)
SUTUN_SN, SUTUN_AD, SUTUN_BIRIM = 1, 2, 3
OZETLER = [  # (anahtar, başlık, kod tablosundaki değer sütunu adı, sayı biçimi)
    ("calisilan", "ÇALIŞILAN GÜN", "KOD_GUN", "0.0;-0.0;0"),
    ("devamsiz", "DEVAMSIZ GÜN", "KOD_DEVAMSIZ", "0.0;-0.0;0"),
    ("izin", "İZİN / RAPOR", "KOD_IZIN", "0.0;-0.0;0"),
    ("mesai", "MESAİ TOPLAM (SAAT)", None, "0.0;-0.0;0"),
]
OZET_SUTUN = {anahtar: 4 + i for i, (anahtar, *_rest) in enumerate(OZETLER)}
OZET_HARF = {k: get_column_letter(v) for k, v in OZET_SUTUN.items()}
ILK_GUN_SUTUN = 4 + len(OZETLER)     # H

# Personel_Listesi
PL_ILK_VERI = 5
PL_SON_VERI = PL_ILK_VERI + PERSONEL_KAPASITE - 1

# Kodlar_Tatiller
KT_SAYFA = "Kodlar_Tatiller"
KT_ILK = 5
KT_KOD_SON = KT_ILK + KOD_KAPASITE - 1
KT_TATIL_SON = KT_ILK + TATIL_KAPASITE - 1
KT_TATIL_SUTUN = 9           # I


def drm_sutun(gun):
    return ILK_GUN_SUTUN + 2 * (gun - 1)


def mesai_sutun(gun):
    return drm_sutun(gun) + 1


def tr_upper(metin):
    return metin.replace("i", "İ").replace("ı", "I").upper()


def hucre_stil(c, font=F_NORMAL, fill=None, align=ORTALI, border=KENAR, fmt=None):
    c.font = font
    c.alignment = align
    c.border = border
    if fill is not None:
        c.fill = fill
    if fmt:
        c.number_format = fmt


def birlestir(ws, r1, c1, r2, c2, deger=None, font=F_NORMAL, fill=None, align=ORTALI, border=KENAR, fmt=None):
    if (r1, c1) != (r2, c2):
        ws.merge_cells(start_row=r1, start_column=c1, end_row=r2, end_column=c2)
    for r in range(r1, r2 + 1):
        for c in range(c1, c2 + 1):
            hucre_stil(ws.cell(row=r, column=c), font, fill, align, border)
    hucre = ws.cell(row=r1, column=c1)
    if deger is not None:
        hucre.value = deger
    if fmt:
        hucre.number_format = fmt
    return hucre


def baslik_bandi(ws, satir, son_sutun, metin, yukseklik=34):
    birlestir(ws, satir, 1, satir, son_sutun, metin, F_BASLIK, DOLGU_LACIVERT, border=KENARSIZ)
    ws.row_dimensions[satir].height = yukseklik


def yazdirma_ayari(ws, yatay=True):
    ws.page_setup.orientation = "landscape" if yatay else "portrait"
    ws.page_setup.paperSize = ws.PAPERSIZE_A4
    ws.page_setup.fitToWidth = 1
    ws.page_setup.fitToHeight = 0
    ws.sheet_properties.pageSetUpPr.fitToPage = True
    ws.page_margins.left = ws.page_margins.right = 0.3
    ws.page_margins.top = ws.page_margins.bottom = 0.4


def isim_tanimla(wb, ad, ref):
    dn = DefinedName(ad, attr_text=ref)
    if hasattr(wb.defined_names, "add"):
        wb.defined_names.add(dn)
    else:  # openpyxl < 3.1
        wb.defined_names.append(dn)


# --------------------------------------------------------------------------- #
# Eski puantaj dosyasını içe aktarma
# --------------------------------------------------------------------------- #
def eski_puantaji_oku(yol):
    """Tarihleri üst satırda, her gün için GÜN/MESAİ sütun çifti olan eski puantajı okur.

    Dönüş: (yil, ay, [(ad, birim), ...], {personel_sira: {gun: (kod, mesai)}})
    """
    ws = load_workbook(yol).worksheets[0]
    gun_sutunlari, tarih_satiri = {}, None
    for r in range(1, 6):
        for c in range(1, ws.max_column + 1):
            v = ws.cell(row=r, column=c).value
            if isinstance(v, dt.datetime):
                gun_sutunlari[v.date()] = c
                tarih_satiri = r
        if gun_sutunlari:
            break
    if not gun_sutunlari:
        raise SystemExit(f"{yol}: tarih başlıkları bulunamadı.")
    yil, ay = min(gun_sutunlari).year, min(gun_sutunlari).month

    personel, veriler = [], {}
    for r in range(tarih_satiri + 1, ws.max_row + 1):
        sn, ad = ws.cell(row=r, column=1).value, ws.cell(row=r, column=2).value
        if not isinstance(sn, (int, float)) or not isinstance(ad, str) or not ad.strip():
            continue
        ad = tr_upper(" ".join(ad.split()))
        birim = ""
        if "-" in ad:                                   # "AHMET-FABRİKA" -> ad + birim
            ad, birim = (p.strip() for p in ad.rsplit("-", 1))
        sira = len(personel)
        personel.append((ad, birim))
        veriler[sira] = {}
        for tarih, c in gun_sutunlari.items():
            if tarih.month != ay:
                continue
            kod = ws.cell(row=r, column=c).value
            mesai = ws.cell(row=r, column=c + 1).value
            kod = tr_upper(str(kod).strip()) if kod not in (None, "") else None
            mesai = mesai if isinstance(mesai, (int, float)) and mesai else None
            if kod or mesai:
                veriler[sira][tarih.day] = (kod, mesai)
    return yil, ay, personel, veriler


# --------------------------------------------------------------------------- #
# Kodlar_Tatiller
# --------------------------------------------------------------------------- #
def kodlar_sayfasi(wb, yil):
    ws = wb.create_sheet(KT_SAYFA)
    ws.sheet_properties.tabColor = "7F7F7F"
    ws.sheet_view.showGridLines = False

    baslik_bandi(ws, 1, KT_TATIL_SUTUN + 1, "PUANTAJ KODLARI VE RESMİ TATİLLER")
    birlestir(ws, 2, 1, 2, KT_TATIL_SUTUN + 1,
              "Sarı alanlar düzenlenebilir. Kodun gün değerleri tüm ay sayfalarındaki toplamları belirler; "
              "renk grubu hücre rengini, tatil listesi ay sayfalarındaki gün gölgelendirmesini belirler.",
              F_ALT_BASLIK, align=Alignment(horizontal="left", vertical="center", wrap_text=True),
              border=KENARSIZ)
    ws.row_dimensions[2].height = 30

    kod_basliklari = ["Kod", "Açıklama", "Çalışılan\nGün", "Devamsızlık", "İzin /\nRapor", "Yemek\n(1/0)",
                      "Renk Grubu"]
    for i, b in enumerate(kod_basliklari, start=1):
        hucre_stil(ws.cell(row=KT_ILK - 1, column=i, value=b), F_TABLO_BASLIK, DOLGU_LACIVERT)
    for i, b in enumerate(["Tarih", "Tatil Açıklaması"]):
        hucre_stil(ws.cell(row=KT_ILK - 1, column=KT_TATIL_SUTUN + i, value=b), F_TABLO_BASLIK, DOLGU_LACIVERT)
    ws.row_dimensions[KT_ILK - 1].height = 30

    for i in range(KOD_KAPASITE):
        r = KT_ILK + i
        kayit = VARSAYILAN_KODLAR[i] if i < len(VARSAYILAN_KODLAR) else (None,) * 7
        for c, v in enumerate(kayit, start=1):
            hucre_stil(ws.cell(row=r, column=c, value=v), F_KOD if c == 1 else F_NORMAL, DOLGU_GIRIS,
                       SOLA if c == 2 else ORTALI, fmt="0.0#" if 3 <= c <= 5 else None)
        if kayit[6]:
            dolgu, yazi = GRUPLAR[kayit[6]]
            ws.cell(row=r, column=1).fill = PatternFill("solid", fgColor=dolgu)
            ws.cell(row=r, column=1).font = Font(name=FONT_ADI, size=11, bold=True, color=yazi)

    tatiller = [(dt.date(yil, a, g), ad) for a, g, ad in SABIT_TATILLER]
    tatiller += [(dt.date.fromisoformat(t), ad) for t, ad in DINI_BAYRAMLAR.get(yil, [])]
    tatiller.sort()
    for i in range(TATIL_KAPASITE):
        r = KT_ILK + i
        t, ad = tatiller[i] if i < len(tatiller) else (None, None)
        hucre_stil(ws.cell(row=r, column=KT_TATIL_SUTUN, value=t), fill=DOLGU_GIRIS, fmt="dd.mm.yyyy")
        hucre_stil(ws.cell(row=r, column=KT_TATIL_SUTUN + 1, value=ad), fill=DOLGU_GIRIS, align=SOLA)

    if yil not in DINI_BAYRAMLAR:
        not_hucre = ws.cell(row=KT_TATIL_SON + 2, column=KT_TATIL_SUTUN,
                            value=f"Not: {yil} yılı Ramazan ve Kurban Bayramı tarihlerini listeye ekleyin.")
        not_hucre.font = Font(name=FONT_ADI, size=10, bold=True, color="C00000")

    dv_grup = DataValidation(type="list", formula1='"' + ",".join(GRUPLAR) + '"', allow_blank=True)
    ws.add_data_validation(dv_grup)
    dv_grup.add(f"G{KT_ILK}:G{KT_KOD_SON}")

    # Grup açıklamaları
    r = KT_KOD_SON + 2
    hucre_stil(ws.cell(row=r, column=1, value="Renk grupları"), F_KALIN, border=KENARSIZ, align=SOLA)
    for i, (grup, (dolgu, yazi)) in enumerate(GRUPLAR.items()):
        hucre_stil(ws.cell(row=r + 1 + i, column=1, value=grup),
                   Font(name=FONT_ADI, size=10, bold=True, color=yazi), PatternFill("solid", fgColor=dolgu))
    dolgu, yazi = BILINMEYEN_KOD
    hucre_stil(ws.cell(row=r + 1 + len(GRUPLAR), column=1, value="TANIMSIZ"),
               Font(name=FONT_ADI, size=10, bold=True, color=yazi), PatternFill("solid", fgColor=dolgu))
    ws.cell(row=r + 1 + len(GRUPLAR), column=2, value="Listede olmayan kod girilirse").font = F_ALT_BASLIK

    for col, w in zip("ABCDEFGHIJ", [9, 28, 11, 12, 10, 9, 13, 3, 13, 38]):
        ws.column_dimensions[col].width = w
    ws.freeze_panes = f"A{KT_ILK}"

    sayfa = f"'{KT_SAYFA}'"
    for ad, sutun in [("KOD", "A"), ("KOD_GUN", "C"), ("KOD_DEVAMSIZ", "D"), ("KOD_IZIN", "E"),
                      ("KOD_YEMEK", "F"), ("KOD_GRUP", "G")]:
        isim_tanimla(wb, ad, f"{sayfa}!${sutun}${KT_ILK}:${sutun}${KT_KOD_SON}")
    tl = get_column_letter(KT_TATIL_SUTUN)
    isim_tanimla(wb, "TATIL", f"{sayfa}!${tl}${KT_ILK}:${tl}${KT_TATIL_SON}")


# --------------------------------------------------------------------------- #
# Personel_Listesi
# --------------------------------------------------------------------------- #
def personel_sayfasi(wb, yil, personel):
    ws = wb.create_sheet("Personel_Listesi")
    ws.sheet_properties.tabColor = CELIK_MAVI
    ws.sheet_view.showGridLines = False

    basliklar = ["S.N", "AD SOYAD", "BİRİM / GÖREV", "İŞE GİRİŞ", "AYRILIŞ", "NOT"]
    genislikler = [6, 32, 18, 13, 13, 30]
    baslik_bandi(ws, 1, len(basliklar), f"{yil} PERSONEL LİSTESİ")
    birlestir(ws, 2, 1, 2, len(basliklar),
              "Personeli yalnızca bu sayfaya girin; tüm ay sayfaları ve raporlar otomatik güncellenir. "
              "İşe giriş / ayrılış tarihi girilirse o tarihlerin dışındaki günler ay sayfalarında koyu gri görünür.",
              F_ALT_BASLIK, align=Alignment(horizontal="left", vertical="center", wrap_text=True),
              border=KENARSIZ)
    ws.row_dimensions[2].height = 32

    for i, (b, w) in enumerate(zip(basliklar, genislikler), start=1):
        hucre_stil(ws.cell(row=PL_ILK_VERI - 1, column=i, value=b), F_TABLO_BASLIK, DOLGU_LACIVERT)
        ws.column_dimensions[get_column_letter(i)].width = w
    ws.row_dimensions[PL_ILK_VERI - 1].height = 24

    for idx in range(PERSONEL_KAPASITE):
        r = PL_ILK_VERI + idx
        fill = DOLGU_ZEBRA if idx % 2 else DOLGU_BEYAZ
        ad, birim = personel[idx] if idx < len(personel) else (None, None)
        hucre_stil(ws.cell(row=r, column=1, value=f'=IF(B{r}="","",ROW()-{PL_ILK_VERI - 1})'), F_KALIN, fill)
        hucre_stil(ws.cell(row=r, column=2, value=ad), F_AD, fill, SOLA)
        hucre_stil(ws.cell(row=r, column=3, value=birim or None), fill=fill)
        hucre_stil(ws.cell(row=r, column=4), fill=fill, fmt="dd.mm.yyyy")
        hucre_stil(ws.cell(row=r, column=5), fill=fill, fmt="dd.mm.yyyy")
        hucre_stil(ws.cell(row=r, column=6), fill=fill, align=SOLA)
        ws.row_dimensions[r].height = 20

    dv_ad = DataValidation(type="custom", formula1=f"EXACT(B{PL_ILK_VERI},UPPER(B{PL_ILK_VERI}))",
                           allow_blank=True, showErrorMessage=True, errorTitle="Büyük Harf Gerekli",
                           error="Ad Soyad BÜYÜK HARF ile yazılmalıdır.")
    dv_tarih = DataValidation(type="date", operator="greaterThan", formula1="1", allow_blank=True,
                              showErrorMessage=True, errorTitle="Geçersiz Tarih",
                              error="Lütfen GG.AA.YYYY biçiminde bir tarih girin.")
    ws.add_data_validation(dv_ad)
    ws.add_data_validation(dv_tarih)
    dv_ad.add(f"B{PL_ILK_VERI}:B{PL_SON_VERI}")
    dv_tarih.add(f"D{PL_ILK_VERI}:E{PL_SON_VERI}")
    ws.freeze_panes = f"A{PL_ILK_VERI}"

    for ad, sutun in [("PL_GIRIS", "D"), ("PL_CIKIS", "E")]:
        isim_tanimla(wb, ad, f"Personel_Listesi!${sutun}${PL_ILK_VERI}:${sutun}${PL_SON_VERI}")


# --------------------------------------------------------------------------- #
# Aylık puantaj sayfaları
# --------------------------------------------------------------------------- #
def ay_sayfasi(wb, yil, ay_no, veriler):
    ad = AYLAR[ay_no - 1]
    gun_sayisi = calendar.monthrange(yil, ay_no)[1]
    ws = wb.create_sheet(ad)
    ws.sheet_properties.tabColor = LACIVERT
    ws.sheet_view.showGridLines = False
    ws.sheet_view.zoomScale = 90

    son_sutun = mesai_sutun(gun_sayisi)
    ilk_harf = get_column_letter(ILK_GUN_SUTUN)
    son_harf = get_column_letter(son_sutun)

    # Başlık ve kod açıklaması
    baslik_bandi(ws, 1, son_sutun, f"{ad.upper()} {yil}  —  ÇALIŞILAN GÜN VE MESAİ ÇİZELGESİ", 36)
    birlestir(ws, 2, 1, 2, ILK_GUN_SUTUN - 1, "Kodlar  ▸", F_KALIN,
              align=Alignment(horizontal="right", vertical="center"), border=KENARSIZ)
    c = ILK_GUN_SUTUN
    for kod, aciklama, *_d, grup in VARSAYILAN_KODLAR:
        dolgu, yazi = GRUPLAR[grup]
        genislik = 6 if len(aciklama) > 14 else 4
        birlestir(ws, 2, c, 2, c + genislik - 1, f"{kod} = {aciklama}",
                  Font(name=FONT_ADI, size=9, bold=True, color=yazi), PatternFill("solid", fgColor=dolgu))
        c += genislik
    ws.row_dimensions[2].height = 20

    # Sol sabit başlıklar
    birlestir(ws, AY_GUN_SATIR, SUTUN_SN, AY_ALT_BASLIK_SATIR, SUTUN_SN, "S.N", F_TABLO_BASLIK, DOLGU_LACIVERT)
    birlestir(ws, AY_GUN_SATIR, SUTUN_AD, AY_ALT_BASLIK_SATIR, SUTUN_AD, "PERSONEL BİLGİLERİ",
              Font(name=FONT_ADI, size=13, bold=True, color=BEYAZ), DOLGU_LACIVERT)
    birlestir(ws, AY_GUN_SATIR, SUTUN_BIRIM, AY_ALT_BASLIK_SATIR, SUTUN_BIRIM, "BİRİM",
              F_TABLO_BASLIK, DOLGU_LACIVERT)
    for anahtar, baslik, *_r in OZETLER:
        birlestir(ws, AY_GUN_SATIR, OZET_SUTUN[anahtar], AY_ALT_BASLIK_SATIR, OZET_SUTUN[anahtar], baslik,
                  F_TABLO_BASLIK, DOLGU_CELIK, DIKEY)

    # Gün başlıkları (gerçek tarih değerleri; hafta tatili/resmi tatil koşullu biçimle boyanır)
    for gun in range(1, gun_sayisi + 1):
        d, m = drm_sutun(gun), mesai_sutun(gun)
        tarih = dt.date(yil, ay_no, gun)
        birlestir(ws, AY_GUN_SATIR, d, AY_GUN_SATIR, m, tarih,
                  Font(name=FONT_ADI, size=12, bold=True, color=BEYAZ), DOLGU_LACIVERT, fmt="d")
        birlestir(ws, AY_TARIH_SATIR, d, AY_TARIH_SATIR, m, tarih,
                  Font(name=FONT_ADI, size=10, bold=True, color=BEYAZ), DOLGU_LACIVERT, DIKEY,
                  fmt="[$-41F]dddd")
        hucre_stil(ws.cell(row=AY_ALT_BASLIK_SATIR, column=d, value="GÜN"), F_KUCUK_BASLIK, DOLGU_CELIK)
        hucre_stil(ws.cell(row=AY_ALT_BASLIK_SATIR, column=m, value="MESAİ"), F_KUCUK_BASLIK, DOLGU_CELIK)
        ws.column_dimensions[get_column_letter(d)].width = 5.0
        ws.column_dimensions[get_column_letter(m)].width = 5.0
    ws.row_dimensions[AY_GUN_SATIR].height = 22
    ws.row_dimensions[AY_TARIH_SATIR].height = 70
    ws.row_dimensions[AY_ALT_BASLIK_SATIR].height = 16

    # Personel satırları
    for idx in range(PERSONEL_KAPASITE):
        r = AY_ILK_VERI + idx
        pl = PL_ILK_VERI + idx
        zebra = DOLGU_ZEBRA if idx % 2 else DOLGU_BEYAZ
        hucre_stil(ws.cell(row=r, column=SUTUN_SN, value=f'=IF(Personel_Listesi!$B{pl}="","",Personel_Listesi!$A{pl})'),
                   F_KALIN, zebra)
        hucre_stil(ws.cell(row=r, column=SUTUN_AD, value=f'=IF(Personel_Listesi!$B{pl}="","",UPPER(Personel_Listesi!$B{pl}))'),
                   F_AD, zebra, SOLA)
        hucre_stil(ws.cell(row=r, column=SUTUN_BIRIM, value=f'=IF(Personel_Listesi!$B{pl}="","",Personel_Listesi!$C{pl}&"")'),
                   Font(name=FONT_ADI, size=9, color="595959"), zebra)

        gun_araligi = f"${ilk_harf}{r}:${son_harf}{r}"
        for anahtar, _b, isim, fmt in OZETLER:
            if isim:
                formul = f'=IF($B{r}="","",SUMPRODUCT(COUNTIF({gun_araligi},KOD)*{isim}))'
            else:
                hucreler = ",".join(f"{get_column_letter(mesai_sutun(g))}{r}" for g in range(1, gun_sayisi + 1))
                formul = f'=IF($B{r}="","",SUM({hucreler}))'
            hucre_stil(ws.cell(row=r, column=OZET_SUTUN[anahtar], value=formul), F_OZET, DOLGU_ACIK_MAVI, fmt=fmt)

        satir_verisi = veriler.get(idx, {})
        for gun in range(1, gun_sayisi + 1):
            kod, mesai = satir_verisi.get(gun, (None, None))
            hucre_stil(ws.cell(row=r, column=drm_sutun(gun), value=kod), F_KOD, zebra, fmt="@")
            hucre_stil(ws.cell(row=r, column=mesai_sutun(gun), value=mesai), F_NORMAL, zebra, fmt="0.##;-0.##;;@")
        ws.row_dimensions[r].height = 24

    # Alt satırlar: günlük yemek ve günlük mesai toplamları
    birlestir(ws, AY_YEMEK_SATIR, 1, AY_YEMEK_SATIR, 3, "GÜNLÜK YEMEK SAYISI", F_TABLO_BASLIK, DOLGU_LACIVERT,
              Alignment(horizontal="left", vertical="center", indent=1))
    birlestir(ws, AY_MESAI_SATIR, 1, AY_MESAI_SATIR, 3, "GÜNLÜK MESAİ TOPLAMI (SAAT)", F_TABLO_BASLIK,
              DOLGU_CELIK, Alignment(horizontal="left", vertical="center", indent=1))
    yemek_toplam = ",".join(f"{get_column_letter(drm_sutun(g))}{AY_YEMEK_SATIR}" for g in range(1, gun_sayisi + 1))
    birlestir(ws, AY_YEMEK_SATIR, 4, AY_YEMEK_SATIR, ILK_GUN_SUTUN - 1, f'="Ay toplamı: "&SUM({yemek_toplam})',
              F_TABLO_BASLIK, DOLGU_LACIVERT)
    birlestir(ws, AY_MESAI_SATIR, 4, AY_MESAI_SATIR, ILK_GUN_SUTUN - 1,
              f'="Ay toplamı: "&TEXT(SUM({OZET_HARF["mesai"]}{AY_ILK_VERI}:{OZET_HARF["mesai"]}{AY_SON_VERI}),"0.0")',
              F_TABLO_BASLIK, DOLGU_CELIK)
    for gun in range(1, gun_sayisi + 1):
        d, m = drm_sutun(gun), mesai_sutun(gun)
        dh, mh = get_column_letter(d), get_column_letter(m)
        birlestir(ws, AY_YEMEK_SATIR, d, AY_YEMEK_SATIR, m,
                  f"=SUMPRODUCT(COUNTIF({dh}{AY_ILK_VERI}:{dh}{AY_SON_VERI},KOD)*KOD_YEMEK)",
                  Font(name=FONT_ADI, size=12, bold=True, color=LACIVERT), DOLGU_ACIK_MAVI, fmt="0;-0;")
        birlestir(ws, AY_MESAI_SATIR, d, AY_MESAI_SATIR, m, f"=SUM({mh}{AY_ILK_VERI}:{mh}{AY_SON_VERI})",
                  F_KALIN, DOLGU_ZEBRA, fmt="0.#;-0.#;")
    ws.row_dimensions[AY_YEMEK_SATIR].height = 26
    ws.row_dimensions[AY_MESAI_SATIR].height = 22

    # Kalın ayraçlar: özet bloğu ve gün bloğu arası
    for r in range(AY_GUN_SATIR, AY_MESAI_SATIR + 1):
        hucre = ws.cell(row=r, column=ILK_GUN_SUTUN)
        hucre.border = Border(left=ORTA, right=hucre.border.right, top=hucre.border.top, bottom=hucre.border.bottom)
        hucre = ws.cell(row=r, column=4)
        hucre.border = Border(left=ORTA, right=hucre.border.right, top=hucre.border.top, bottom=hucre.border.bottom)

    # Veri doğrulama
    dv_kod = DataValidation(type="list", formula1="=KOD", allow_blank=True, showErrorMessage=False,
                            showInputMessage=False)
    dv_mesai = DataValidation(type="decimal", operator="between", formula1="0", formula2="24",
                              allow_blank=True, showErrorMessage=True, errorTitle="Geçersiz Mesai",
                              error="Mesai 0 ile 24 arasında bir sayı (saat) olmalıdır. Örn: 2,5")
    ws.add_data_validation(dv_kod)
    ws.add_data_validation(dv_mesai)
    for gun in range(1, gun_sayisi + 1):
        dh, mh = get_column_letter(drm_sutun(gun)), get_column_letter(mesai_sutun(gun))
        dv_kod.add(f"{dh}{AY_ILK_VERI}:{dh}{AY_SON_VERI}")
        dv_mesai.add(f"{mh}{AY_ILK_VERI}:{mh}{AY_SON_VERI}")

    # Koşullu biçimlendirme
    blok = f"{ilk_harf}{AY_ILK_VERI}:{son_harf}{AY_SON_VERI}"
    sol_ust = f"{ilk_harf}{AY_ILK_VERI}"
    tarih = f"(DATE({yil},{ay_no},1)+INT((COLUMN({sol_ust})-{ILK_GUN_SUTUN})/2))"
    sira = f"(ROW({sol_ust})-{AY_ILK_VERI - 1})"

    for grup, (dolgu, yazi) in GRUPLAR.items():                    # 1) Kod renkleri
        ws.conditional_formatting.add(blok, FormulaRule(
            formula=[f'AND(ISTEXT({sol_ust}),IFERROR(INDEX(KOD_GRUP,MATCH({sol_ust},KOD,0)),"")="{grup}")'],
            fill=PatternFill("solid", fgColor=dolgu, bgColor=dolgu), font=Font(bold=True, color=yazi),
            stopIfTrue=True))
    dolgu, yazi = BILINMEYEN_KOD                                   # 2) Tanımsız kod uyarısı
    ws.conditional_formatting.add(blok, FormulaRule(
        formula=[f"AND(ISTEXT({sol_ust}),ISNA(MATCH({sol_ust},KOD,0)))"],
        fill=PatternFill("solid", fgColor=dolgu, bgColor=dolgu), font=Font(bold=True, color=yazi),
        stopIfTrue=True))
    ws.conditional_formatting.add(blok, FormulaRule(                # 3) İşe giriş öncesi / ayrılış sonrası
        formula=[f'OR(AND(INDEX(PL_GIRIS,{sira})<>"",{tarih}<INDEX(PL_GIRIS,{sira})),'
                 f'AND(INDEX(PL_CIKIS,{sira})<>"",{tarih}>INDEX(PL_CIKIS,{sira})))'],
        fill=PatternFill("solid", fgColor="A6A6A6", bgColor="A6A6A6"), stopIfTrue=True))
    ws.conditional_formatting.add(blok, FormulaRule(                # 4) Hafta tatili ve resmi tatil sütunları
        formula=[f"OR(WEEKDAY({tarih},2)={HAFTA_TATILI},COUNTIF(TATIL,{tarih})>0)"],
        fill=PatternFill("solid", fgColor="E7E6E6", bgColor="E7E6E6")))
    gl = get_column_letter(ILK_GUN_SUTUN)
    ws.conditional_formatting.add(                                 # Başlıkta tatil günleri kırmızı
        f"{ilk_harf}{AY_GUN_SATIR}:{son_harf}{AY_TARIH_SATIR}",
        FormulaRule(formula=[f"AND(ISNUMBER({gl}${AY_GUN_SATIR}),"
                             f"OR(WEEKDAY({gl}${AY_GUN_SATIR},2)={HAFTA_TATILI},COUNTIF(TATIL,{gl}${AY_GUN_SATIR})>0))"],
                    fill=PatternFill("solid", fgColor="C00000", bgColor="C00000"),
                    font=Font(bold=True, color=BEYAZ)))

    ws.column_dimensions["A"].width = 5
    ws.column_dimensions["B"].width = 30
    ws.column_dimensions["C"].width = 11
    for anahtar in OZET_SUTUN:
        ws.column_dimensions[OZET_HARF[anahtar]].width = 7.5
    ws.freeze_panes = ws.cell(row=AY_ILK_VERI, column=ILK_GUN_SUTUN)

    yazdirma_ayari(ws)
    ws.print_title_cols = f"A:{get_column_letter(ILK_GUN_SUTUN - 1)}"
    ws.print_title_rows = f"{AY_GUN_SATIR}:{AY_ALT_BASLIK_SATIR}"
    ws.print_area = f"A1:{son_harf}{AY_MESAI_SATIR}"
    return gun_sayisi


# --------------------------------------------------------------------------- #
# Yıllık rapor
# --------------------------------------------------------------------------- #
def ozet_ref(ay, anahtar, satir):
    return f"'{ay}'!${OZET_HARF[anahtar]}${satir}"


def rapor_sayfasi(ws, yil):
    ws.title = "Yillik_Rapor"
    ws.sheet_properties.tabColor = "C00000"
    ws.sheet_view.showGridLines = False

    basliklar = ["S.N", "Ad Soyad", "Birim", "Ay", "Toplam Çalışılan Gün", "Toplam Devamsızlık",
                 "İzin / Rapor", "Toplam Mesai (Saat)"]
    genislikler = [7, 30, 16, 13, 16, 16, 14, 16]
    n = len(basliklar)

    baslik_bandi(ws, 1, n, f"{yil} YILI PERSONEL PUANTAJ VE MESAİ İCMAL RAPORU", 38)
    birlestir(ws, 2, 1, 2, n, "Bu sayfadaki tüm değerler aylık puantaj sayfalarına bağlı formüllerdir; elle değer "
              "girmeyiniz. Filtre oklarıyla personel, birim veya ay seçebilirsiniz.", F_ALT_BASLIK, border=KENARSIZ)

    ilk = 9
    son = ilk + PERSONEL_KAPASITE * 13 - 1
    yemek = "+".join(f"SUM('{ay}'!{get_column_letter(drm_sutun(1))}{AY_YEMEK_SATIR}:"
                     f"{get_column_letter(mesai_sutun(31))}{AY_YEMEK_SATIR})" for ay in AYLAR)
    kpi = [
        ((1, 2), "TOPLAM PERSONEL", f'=COUNTA(Personel_Listesi!B{PL_ILK_VERI}:B{PL_SON_VERI})', "0"),
        ((3, 4), "ÇALIŞILAN GÜN", f'=SUMIF($D${ilk}:$D${son},"YILLIK TOPLAM",$E${ilk}:$E${son})', "#,##0.0"),
        ((5, 5), "DEVAMSIZLIK", f'=SUMIF($D${ilk}:$D${son},"YILLIK TOPLAM",$F${ilk}:$F${son})', "#,##0.0"),
        ((6, 7), "MESAİ (SAAT)", f'=SUMIF($D${ilk}:$D${son},"YILLIK TOPLAM",$H${ilk}:$H${son})', "#,##0.0"),
        ((8, 8), "YEMEK SAYISI", f"={yemek}", "#,##0"),
    ]
    for (c1, c2), etiket, formul, fmt in kpi:
        birlestir(ws, 4, c1, 4, c2, etiket, F_KPI_ETIKET, DOLGU_ACIK_MAVI,
                  border=Border(top=ORTA, left=Side(style="thin", color=BEYAZ)))
        birlestir(ws, 5, c1, 5, c2, formul, F_KPI_DEGER, DOLGU_ACIK_MAVI,
                  border=Border(left=Side(style="thin", color=BEYAZ)), fmt=fmt)
    ws.row_dimensions[4].height = 20
    ws.row_dimensions[5].height = 34

    for i, (b, w) in enumerate(zip(basliklar, genislikler), start=1):
        hucre_stil(ws.cell(row=7, column=i, value=b), F_TABLO_BASLIK, DOLGU_LACIVERT)
        ws.column_dimensions[get_column_letter(i)].width = w
    ws.row_dimensions[7].height = 32
    ws.row_dimensions[8].height = 4

    r = ilk - 1
    anahtarlar = ["calisilan", "devamsiz", "izin", "mesai"]
    bicimler = [None, None, None, None, "0.0;-0.0;0", "0.0;-0.0;0", "0.0;-0.0;0", "0.0;-0.0;0"]
    for idx in range(PERSONEL_KAPASITE):
        ay_r = AY_ILK_VERI + idx
        blok_ilk = r + 1
        for ay_no, ay in enumerate(AYLAR, start=1):
            r += 1
            ref = f"'{ay}'!"
            zebra = DOLGU_ZEBRA if ay_no % 2 == 0 else DOLGU_BEYAZ
            degerler = [f"={ref}$A${ay_r}", f"={ref}$B${ay_r}", f"={ref}$C${ay_r}",
                        f'=IF({ref}$B${ay_r}="","","{ay}")']
            degerler += [f"={ozet_ref(ay, k, ay_r)}" for k in anahtarlar]
            for c, (v, fmt) in enumerate(zip(degerler, bicimler), start=1):
                hucre_stil(ws.cell(row=r, column=c, value=v), fill=zebra, align=SOLA if c == 2 else ORTALI, fmt=fmt)

        r += 1
        blok_son = r - 1
        b = f"$B${blok_ilk}"
        toplam = [f"=$A${blok_ilk}", f"={b}", f"=$C${blok_ilk}", f'=IF({b}="","","YILLIK TOPLAM")']
        toplam += [f'=IF({b}="","",SUM({h}{blok_ilk}:{h}{blok_son}))' for h in "EFGH"]
        for c, (v, fmt) in enumerate(zip(toplam, bicimler), start=1):
            hucre_stil(ws.cell(row=r, column=c, value=v), F_KALIN, DOLGU_ACIK_MAVI, align=SOLA if c == 2 else ORTALI,
                       border=Border(left=INCE, right=INCE, top=INCE, bottom=ORTA), fmt=fmt)
        ws.row_dimensions[r].height = 20

    ws.auto_filter.ref = f"A7:{get_column_letter(n)}{son}"
    ws.freeze_panes = "A8"
    yazdirma_ayari(ws, yatay=False)
    ws.print_title_rows = "7:7"


# --------------------------------------------------------------------------- #
# Aylık rapor
# --------------------------------------------------------------------------- #
def aylik_rapor_sayfasi(wb, yil, gun_sayilari, varsayilan_ay):
    ws = wb.create_sheet("Aylik_Rapor", 1)
    ws.sheet_properties.tabColor = "C55A11"
    ws.sheet_view.showGridLines = False

    basliklar = ["S.N", "Ad Soyad", "Birim", "Çalışılan Gün", "Devamsız Gün", "İzin / Rapor",
                 "Mesai (Saat)", "Devam Oranı"]
    genislikler = [7, 30, 16, 14, 14, 14, 14, 13]
    n = len(basliklar)
    for i, w in enumerate(genislikler, start=1):
        ws.column_dimensions[get_column_letter(i)].width = w

    baslik_bandi(ws, 1, n, f"{yil} YILI AYLIK PERSONEL PUANTAJ VE MESAİ RAPORU", 38)

    birlestir(ws, 3, 1, 3, 2, "RAPOR AYI  ▸", F_TABLO_BASLIK, DOLGU_CELIK)
    secici = ws["C3"]
    secici.value = AYLAR[varsayilan_ay - 1]
    hucre_stil(secici, Font(name=FONT_ADI, size=13, bold=True, color="C00000"), DOLGU_GIRIS,
               border=Border(left=ORTA, right=ORTA, top=ORTA, bottom=ORTA))
    dv = DataValidation(type="list", formula1='"' + ",".join(AYLAR) + '"', allow_blank=False,
                        showErrorMessage=True, errorTitle="Geçersiz Ay", error="Listeden bir ay seçiniz.",
                        showInputMessage=True, promptTitle="Rapor Ayı", prompt="Raporlanacak ayı listeden seçin.")
    ws.add_data_validation(dv)
    dv.add("C3")
    ay_listesi = "{" + ",".join(f'"{a}"' for a in AYLAR) + "}"
    ay_idx = f"MATCH($C$3,{ay_listesi},0)"
    gunler = ",".join(str(gun_sayilari[a]) for a in AYLAR)
    birlestir(ws, 3, 4, 3, n, f'="Takvim gün sayısı: "&CHOOSE({ay_idx},{gunler})&"   |   Ayı sarı hücreden seçin."',
              F_ALT_BASLIK, align=SOLA, border=KENARSIZ)
    ws.row_dimensions[3].height = 26

    def secili(anahtar_veya_sutun, satir):
        harf = OZET_HARF.get(anahtar_veya_sutun, anahtar_veya_sutun)
        return f"CHOOSE({ay_idx},{','.join(f'{chr(39)}{a}{chr(39)}!${harf}${satir}' for a in AYLAR)})"

    bas = 5
    for i, b in enumerate(basliklar, start=1):
        hucre_stil(ws.cell(row=bas, column=i, value=b), F_TABLO_BASLIK, DOLGU_LACIVERT)
    ws.row_dimensions[bas].height = 30
    ilk = bas + 1
    for idx in range(PERSONEL_KAPASITE):
        r = ilk + idx
        ay_r = AY_ILK_VERI + idx
        pl = PL_ILK_VERI + idx
        zebra = DOLGU_ZEBRA if idx % 2 else DOLGU_BEYAZ
        b = f"$B{r}"
        formuller = [
            f'=IF({b}="","",Personel_Listesi!$A{pl})',
            f'=IF(Personel_Listesi!$B{pl}="","",UPPER(Personel_Listesi!$B{pl}))',
            f'=IF({b}="","",Personel_Listesi!$C{pl}&"")',
            f'=IF({b}="","",{secili("calisilan", ay_r)})',
            f'=IF({b}="","",{secili("devamsiz", ay_r)})',
            f'=IF({b}="","",{secili("izin", ay_r)})',
            f'=IF({b}="","",{secili("mesai", ay_r)})',
            f'=IF({b}="","",IF(D{r}+E{r}=0,"",D{r}/(D{r}+E{r})))',
        ]
        bicimler = [None, None, None, "0.0;-0.0;0", "0.0;-0.0;0", "0.0;-0.0;0", "0.0;-0.0;0", "0.0%"]
        for c, (f, fmt) in enumerate(zip(formuller, bicimler), start=1):
            hucre_stil(ws.cell(row=r, column=c, value=f), F_KALIN if c == 2 else F_NORMAL, zebra,
                       SOLA if c == 2 else ORTALI, fmt=fmt)
    son = ilk + PERSONEL_KAPASITE - 1
    t = son + 1
    birlestir(ws, t, 1, t, 3, "AY TOPLAMI", F_TABLO_BASLIK, DOLGU_CELIK)
    for c in range(4, 8):
        h = get_column_letter(c)
        hucre_stil(ws.cell(row=t, column=c, value=f"=SUM({h}{ilk}:{h}{son})"), F_TABLO_BASLIK, DOLGU_CELIK,
                   fmt="0.0;-0.0;0")
    hucre_stil(ws.cell(row=t, column=8, value=f'=IF(D{t}+E{t}=0,"",D{t}/(D{t}+E{t}))'),
               F_TABLO_BASLIK, DOLGU_CELIK, fmt="0.0%")
    ws.row_dimensions[t].height = 24

    # Aylara göre karşılaştırma (tüm personel)
    k = t + 3
    birlestir(ws, k, 1, k, n, "AYLARA GÖRE KARŞILAŞTIRMA (TÜM PERSONEL)", F_TABLO_BASLIK, DOLGU_LACIVERT)
    ws.row_dimensions[k].height = 24
    kb = ["Ay", None, "Takvim Günü", "Çalışılan Gün", "Devamsız Gün", "İzin / Rapor", "Mesai (Saat)", "Yemek Sayısı"]
    for i, b in enumerate(kb, start=1):
        hucre_stil(ws.cell(row=k + 1, column=i, value=b), F_TABLO_BASLIK, DOLGU_CELIK)
    ws.merge_cells(start_row=k + 1, start_column=1, end_row=k + 1, end_column=2)
    ws.row_dimensions[k + 1].height = 30
    for ay_no, ay in enumerate(AYLAR, start=1):
        r = k + 1 + ay_no
        zebra = DOLGU_ZEBRA if ay_no % 2 == 0 else DOLGU_BEYAZ
        birlestir(ws, r, 1, r, 2, ay, F_KALIN, zebra)
        hucre_stil(ws.cell(row=r, column=3, value=gun_sayilari[ay]), fill=zebra)
        for c, anahtar in zip(range(4, 8), ["calisilan", "devamsiz", "izin", "mesai"]):
            h = OZET_HARF[anahtar]
            hucre_stil(ws.cell(row=r, column=c, value=f"=SUM('{ay}'!{h}{AY_ILK_VERI}:{h}{AY_SON_VERI})"),
                       fill=zebra, fmt="0.0;-0.0;0")
        yemek = (f"=SUM('{ay}'!{get_column_letter(drm_sutun(1))}{AY_YEMEK_SATIR}:"
                 f"{get_column_letter(mesai_sutun(gun_sayilari[ay]))}{AY_YEMEK_SATIR})")
        hucre_stil(ws.cell(row=r, column=8, value=yemek), fill=zebra, fmt="#,##0")
    ws.conditional_formatting.add(f"A{k + 2}:H{k + 13}", FormulaRule(
        formula=[f"$A{k + 2}=$C$3"], fill=PatternFill("solid", fgColor="FFF2CC", bgColor="FFF2CC"),
        font=Font(bold=True, color="C00000")))
    yt = k + 14
    birlestir(ws, yt, 1, yt, 2, "YIL TOPLAMI", F_TABLO_BASLIK, DOLGU_LACIVERT)
    for c in range(3, 9):
        h = get_column_letter(c)
        hucre_stil(ws.cell(row=yt, column=c, value=f"=SUM({h}{k + 2}:{h}{k + 13})"), F_TABLO_BASLIK, DOLGU_LACIVERT,
                   fmt="#,##0" if c in (3, 8) else "#,##0.0")
    ws.row_dimensions[yt].height = 24

    ws.freeze_panes = f"A{ilk}"
    yazdirma_ayari(ws)


# --------------------------------------------------------------------------- #
def ornek_puantaj(yil, ay_no, kisi_sayisi):
    rng = random.Random(yil * 100 + ay_no)
    veriler = {}
    for idx in range(kisi_sayisi):
        veriler[idx] = {}
        for gun in range(1, calendar.monthrange(yil, ay_no)[1] + 1):
            tarih = dt.date(yil, ay_no, gun)
            if tarih.isoweekday() == HAFTA_TATILI or (tarih.month, tarih.day) in {(a, g) for a, g, _ in SABIT_TATILLER}:
                continue
            kod = rng.choices(["X", "YARIM", "Y", "V"], weights=[88, 5, 5, 2])[0]
            mesai = rng.choice([2, 2.5, 3, 3.5, 4, 5.5]) if kod == "X" and rng.random() < 0.25 else None
            veriler[idx][gun] = (kod, mesai)
    return veriler


def olustur(yil, cikti, ornek_veri=True, aktar=None):
    personel = ORNEK_PERSONEL
    ay_verileri = {}
    if aktar:
        a_yil, a_ay, personel, veriler = eski_puantaji_oku(aktar)
        if a_yil != yil:
            raise SystemExit(f"İçe aktarılan dosya {a_yil} yılına ait; --yil {a_yil} ile çalıştırın.")
        ay_verileri[a_ay] = veriler
        print(f"  {aktar}: {len(personel)} personel, {AYLAR[a_ay - 1]} {a_yil} verisi içe aktarıldı.")
    elif ornek_veri:
        ay_verileri[1] = ornek_puantaj(yil, 1, len(personel))
    else:
        personel = []
    if len(personel) > PERSONEL_KAPASITE:
        raise SystemExit(f"Personel sayısı ({len(personel)}) kapasiteyi aşıyor; PERSONEL_KAPASITE değerini artırın.")

    wb = Workbook()
    rapor_ws = wb.active                     # İlk sayfa: Yillik_Rapor
    personel_sayfasi(wb, yil, personel)
    kodlar_sayfasi(wb, yil)
    gun_sayilari = {}
    for ay_no in range(1, 13):
        gun_sayilari[AYLAR[ay_no - 1]] = ay_sayfasi(wb, yil, ay_no, ay_verileri.get(ay_no, {}))
    rapor_sayfasi(rapor_ws, yil)
    bugun = dt.date.today()
    varsayilan_ay = max(ay_verileri) if ay_verileri else (bugun.month if bugun.year == yil else 1)
    aylik_rapor_sayfasi(wb, yil, gun_sayilari, varsayilan_ay)
    wb.active = 0
    wb.save(cikti)
    return cikti


def main():
    p = argparse.ArgumentParser(description="Yıllık Excel puantaj ve mesai takip sistemi oluşturur.")
    p.add_argument("--yil", type=int, default=None, help="Puantaj yılı (varsayılan: bu yıl / içe aktarılan dosyanın yılı)")
    p.add_argument("--cikti", default=VARSAYILAN_CIKTI, help=f"Çıktı dosyası (varsayılan: {VARSAYILAN_CIKTI})")
    p.add_argument("--aktar", metavar="XLSX", help="Eski aylık puantaj dosyasından personel ve ay verisini içe aktar")
    p.add_argument("--ornek-veri-yok", action="store_true", help="Örnek personel ve puantaj verisi eklenmesin")
    args = p.parse_args()
    yil = args.yil
    if yil is None:
        yil = eski_puantaji_oku(args.aktar)[0] if args.aktar else dt.date.today().year
    yol = olustur(yil, args.cikti, ornek_veri=not args.ornek_veri_yok, aktar=args.aktar)
    print(f"✔ {yol} oluşturuldu ({yil}).")


if __name__ == "__main__":
    main()
