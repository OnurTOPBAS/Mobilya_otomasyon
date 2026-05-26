-- ================================================
-- GUN 5: VIEW ve INDEX
-- Yazan: Ali Hamza TEKINBAS
--
-- VIEW nedir: Kayitli bir SELECT sorgusudur. Veri
-- tutmaz, cagrildiginda sorguyu calistirir. Tablo
-- gibi kullanilir, karmasik JOIN'leri gizler.
--
-- INDEX nedir: Tablodaki belirli sutunlara gore
-- hizli arama yapilmasini saglar. Index olmadan
-- PostgreSQL tum satiri tararken (full scan),
-- index varsa dogrudan ilgili satirlara atlar.
-- ================================================


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
-- Amac: "Musteri X'in siparisleri" sorgusu sik
-- calisir. MusteriID uzerinde index olmadan tum
-- SIPARISLER tablosu taranir. Index ile yalnizca
-- o musterinin satirlarina atlanir.
-- ================================================
CREATE INDEX ix_siparisler_musteri
    ON SIPARISLER(MusteriID);


-- ================================================
-- INDEX 2: ix_siparisdetay_siparis
-- Amac: Bir siparise ait tum detaylari getirirken
-- SiparisID'ye gore filtreleme yapilir. Index bu
-- taramayi hizlandirir; ozellikle buyuk veri
-- setlerinde performans farki belirginlesir.
-- ================================================
CREATE INDEX ix_siparisdetay_siparis
    ON SIPARISDETAY(SiparisID);
