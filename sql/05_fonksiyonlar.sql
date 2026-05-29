-- ============================================================
-- Gun 7: Fonksiyon Tanimlari
-- Onur: fn_yeni_siparis_olustur, fn_musteri_siparis_gecmisi
-- Ali: fn_siparise_urun_ekle, fn_kategori_bazli_satis
-- ============================================================



create or replace function fn_yeni_siparis_olustur(
    p_musteri_id INT,
    p_alici_ad VARCHAR,
    p_alici_tel VARCHAR,
    p_adres TEXT
)
returns INT as $$
declare
    yeni_id INT;
begin
    insert into SIPARISLER(MusteriID, AliciAdSoyad, AliciTelefon, TeslimatAdresi)
    values(p_musteri_id, p_alici_ad, p_alici_tel, p_adres)
    returning SiparisID into yeni_id;

    return yeni_id;
end;
$$ LANGUAGE plpgsql;


create or replace function fn_musteri_siparis_gecmisi(p_musteri_id INT)
returns table(siparis_id INT, tarih TIMESTAMP, durum VARCHAR, tutar NUMERIC) as $$
begin
    return query
    select S.SiparisID, S.SiparisTarihi, S.Durum, S.ToplamTutar
    from SIPARISLER S
    where S.MusteriID = p_musteri_id;
end;
$$ LANGUAGE plpgsql;


-- ============================================================
-- ALI HAMZA TEKINBAS -- Gun 7
-- ============================================================

-- -----------------------------------------------------------
-- fn_siparise_urun_ekle
-- Mevcut bir siparise urun ekler (SIPARISDETAY INSERT).
-- Stok dusurme ve siparis toplami guncelleme trigger'a birakildi.
-- -----------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_siparise_urun_ekle(
    p_siparis_id  INT,
    p_urun_id     INT,
    p_miktar      INT,
    p_birim_fiyat NUMERIC(10, 2)
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO SIPARISDETAY (SiparisID, UrunID, Miktar, BirimFiyat)
    VALUES (p_siparis_id, p_urun_id, p_miktar, p_birim_fiyat);
END;
$$ LANGUAGE plpgsql;


-- -----------------------------------------------------------
-- fn_kategori_bazli_satis
-- Her kategori icin toplam satis tutarini dondurur.
-- -----------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_kategori_bazli_satis()
RETURNS TABLE (
    KategoriAdi VARCHAR,
    ToplamSatis NUMERIC(12, 2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        k.KategoriAdi,
        SUM(sd.Miktar * sd.BirimFiyat)::NUMERIC(12, 2) AS ToplamSatis
    FROM SIPARISDETAY sd
    JOIN URUNLER     u ON sd.UrunID    = u.UrunID
    JOIN KATEGORILER k ON u.KategoriID = k.KategoriID
    GROUP BY k.KategoriAdi
    ORDER BY ToplamSatis DESC;
END;
$$ LANGUAGE plpgsql;
