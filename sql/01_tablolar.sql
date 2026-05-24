CREATE TABLE KATEGORILER (
    KategoriID   SERIAL PRIMARY KEY,
    KategoriAdi  VARCHAR(100) UNIQUE NOT NULL,
    Aciklama     TEXT
);

CREATE TABLE MUSTERILER (
    MusteriID   SERIAL PRIMARY KEY,
    Ad          VARCHAR(50) NOT NULL,
    Soyad       VARCHAR(50) NOT NULL,
    Email       VARCHAR(100) UNIQUE,
    Telefon     VARCHAR(20),
    Sehir       VARCHAR(50),
    KayitTarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE URUNLER (
    UrunID        SERIAL PRIMARY KEY,
    UrunAdi       VARCHAR(100) NOT NULL,
    KategoriID    INT NOT NULL REFERENCES KATEGORILER(KategoriID),
    Fiyat         NUMERIC(10,2) CHECK (Fiyat > 0),
    StokAdedi     INT DEFAULT 0 CHECK (StokAdedi >= 0),
    Malzeme       VARCHAR(50),
    EklenmeTarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE SIPARISLER (
    SiparisID     SERIAL PRIMARY KEY,
    MusteriID     INT NOT NULL REFERENCES MUSTERILER(MusteriID),
    SiparisTarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ToplamTutar   NUMERIC(12,2) DEFAULT 0,
    Durum         VARCHAR(20) DEFAULT 'Hazirlanıyor'
                  CHECK (Durum IN ('Hazirlanıyor','Kargoda','Teslim Edildi','Iptal'))
);

CREATE TABLE SIPARISDETAY (
    SiparisDetayID SERIAL PRIMARY KEY,
    SiparisID      INT NOT NULL REFERENCES SIPARISLER(SiparisID),
    UrunID         INT NOT NULL REFERENCES URUNLER(UrunID),
    Miktar         INT NOT NULL CHECK (Miktar > 0),
    BirimFiyat     NUMERIC(10,2) NOT NULL CHECK (BirimFiyat > 0)
);
