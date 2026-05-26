-- ================================================
-- GUN 3: SIPARISLER ve SIPARISDETAY TABLOLARI
-- Yazan: Ali Hamza TEKINBAS
-- Aciklama: Projenin siparis yonetimi kismi bu iki
-- tablo uzerinden yurutulur. SIPARISLER musterinin
-- verdigi siparisin genel bilgilerini tutar.
-- SIPARISDETAY ise sipariste hangi urunden kac adet
-- oldugunu ve birim fiyatini tutar. Her iki tabloda
-- da Foreign Key ile referans butunlugu saglanmistir.
-- ================================================

-- SIPARISLER tablosu: Siparis bilgilerini tutar
-- MusteriID -> MUSTERILER tablosuna bagli (FK)
CREATE TABLE SIPARISLER (
    SiparisID       SERIAL          PRIMARY KEY,
    MusteriID       INT             NOT NULL REFERENCES MUSTERILER(MusteriID) ON DELETE RESTRICT,
    AliciAdSoyad    VARCHAR(100)    NOT NULL,
    AliciTelefon    VARCHAR(20)     NOT NULL,
    TeslimatAdresi  TEXT            NOT NULL,
    SiparisTarihi   TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Durum           VARCHAR(20)     NOT NULL DEFAULT 'Hazirlaniyor'
                                    CHECK (Durum IN ('Hazirlaniyor', 'Kargoda', 'Teslim Edildi', 'Iptal')),
    ToplamTutar     NUMERIC(12,2)   NOT NULL DEFAULT 0 CHECK (ToplamTutar >= 0)
);

-- SIPARISDETAY tablosu: Siparis ile Urun arasindaki ara tablo
-- SiparisID -> SIPARISLER tablosuna bagli (FK)
-- UrunID    -> URUNLER tablosuna bagli (FK)
CREATE TABLE SIPARISDETAY (
    SiparisDetayID  SERIAL          PRIMARY KEY,
    SiparisID       INT             NOT NULL REFERENCES SIPARISLER(SiparisID) ON DELETE CASCADE,
    UrunID          INT             NOT NULL REFERENCES URUNLER(UrunID) ON DELETE RESTRICT,
    Miktar          INT             NOT NULL CHECK (Miktar > 0),
    BirimFiyat      NUMERIC(10,2)   NOT NULL CHECK (BirimFiyat > 0)
);
