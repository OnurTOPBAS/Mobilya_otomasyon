

-- KATEGORILER tablosu: Mobilya kategorilerini tutar
CREATE TABLE KATEGORILER (
    KategoriID    SERIAL          PRIMARY KEY,
    KategoriAdi   VARCHAR(100)    NOT NULL UNIQUE,
    Aciklama      TEXT
);

-- URUNLER tablosu: Mağazadaki tüm ürunleri tutar
CREATE TABLE URUNLER (
    UrunID         SERIAL          PRIMARY KEY,
    KategoriID     INT             NOT NULL REFERENCES KATEGORILER(KategoriID) ON DELETE RESTRICT,
    UrunAdi        VARCHAR(150)    NOT NULL,
    Aciklama       TEXT,
    Marka          VARCHAR(50),
    Renk           VARCHAR(40),
    RenkKodu       VARCHAR(7),
    Fiyat          NUMERIC(10,2)   NOT NULL CHECK (Fiyat > 0),
    StokAdedi      INT             NOT NULL DEFAULT 0 CHECK (StokAdedi >= 0),
    EklenmeTarihi  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- MUSTERILER tablosu: Mağazaya kayıtlı müşterileri tutar
CREATE TABLE MUSTERILER (
    MusteriID    SERIAL          PRIMARY KEY,
    AdSoyad      VARCHAR(100)    NOT NULL,
    Email        VARCHAR(100)    UNIQUE,
    Telefon      VARCHAR(20)     NOT NULL UNIQUE,
    KayitTarihi  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- SIPARISLER tablosu: Siparis bilgilerini tutar 
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

-- SIPARISDETAY tablosu: sipariş ile ürün arasindaki ara tabloyu ifade eder
CREATE TABLE SIPARISDETAY (
    SiparisDetayID  SERIAL          PRIMARY KEY,
    SiparisID       INT             NOT NULL REFERENCES SIPARISLER(SiparisID) ON DELETE CASCADE,
    UrunID          INT             NOT NULL REFERENCES URUNLER(UrunID) ON DELETE RESTRICT,
    Miktar          INT             NOT NULL CHECK (Miktar > 0),
    BirimFiyat      NUMERIC(10,2)   NOT NULL CHECK (BirimFiyat > 0)
);