-- ================================================
-- VIEW ve INDEX TANIMLARI
-- ================================================
-- Onur TOPBAS    : vw_urun_katalog, vw_stok_durumu,
--                  ix_urunler_kategori
-- Ali Hamza TEKINBAS : vw_siparis_ozet,
--                  ix_siparisler_musteri,
--                  ix_siparisdetay_siparis
-- ================================================


-- ------------------------------------------------
-- ONUR TOPBAS -- Gün 5
-- ------------------------------------------------

create view vw_urun_katalog as
select
    U.UrunID,
    U.UrunAdi,
    K.KategoriAdi,
    U.Marka,
    U.Renk,
    U.Fiyat,
    U.StokAdedi
    FROM URUNLER U
INNER JOIN KATEGORILER K ON U.KategoriID = K.KategoriID;


create view vw_stok_durumu as
select
    U.UrunID,
    U.UrunAdi,
    K.KategoriAdi,
    U.StokAdedi
from URUNLER U
inner join KATEGORILER K on U.KategoriID = K.KategoriID
where U.StokAdedi < 10;

CREATE INDEX ix_urunler_kategori ON URUNLER(KategoriID);


-- ------------------------------------------------
-- ALI HAMZA TEKINBAS -- Gün 5
-- ------------------------------------------------

-- ================================================
-- VIEW: vw_siparis_ozet
-- Amac: Siparis, musteri ve urun bilgilerini tek
-- sorguda birlestirerek okunabilir bir ozet sunar.
-- Rapor ekraninda ve sunumda kullanilacak.
-- ================================================
CREATE VIEW vw_siparis_ozet AS
SELECT
    s.SiparisID,
    m.AdSoyad           AS MusteriAdi,
    s.AliciAdSoyad,
    s.TeslimatAdresi,
    s.SiparisTarihi,
    s.ToplamTutar,
    s.Durum,
    COUNT(sd.SiparisDetayID) AS UrunCesidi,
    SUM(sd.Miktar)           AS ToplamAdet
FROM SIPARISLER s
JOIN MUSTERILER m
    ON s.MusteriID = m.MusteriID
LEFT JOIN SIPARISDETAY sd
    ON s.SiparisID = sd.SiparisID
GROUP BY
    s.SiparisID, m.AdSoyad, s.AliciAdSoyad,
    s.TeslimatAdresi, s.SiparisTarihi,
    s.ToplamTutar, s.Durum;


-- ================================================
-- INDEX 1: ix_siparisler_musteri
-- Amac: MusteriID uzerinde index — musteri bazli
-- siparis sorgularini hizlandirir.
-- ================================================
CREATE INDEX ix_siparisler_musteri
    ON SIPARISLER(MusteriID);


-- ================================================
-- INDEX 2: ix_siparisdetay_siparis
-- Amac: SiparisID uzerinde index — siparis detay
-- sorgularini hizlandirir.
-- ================================================
CREATE INDEX ix_siparisdetay_siparis
    ON SIPARISDETAY(SiparisID);
