-- ============================================================
-- Gün 7 — Fonksiyonlar
-- Onur: fn_yeni_siparis_olustur, fn_musteri_siparis_gecmisi
-- Alihamza: fn_siparise_urun_ekle, fn_kategori_bazli_satis
-- ============================================================


-- -----------------------------------------------------------
-- fn_siparise_urun_ekle
-- Mevcut bir siparişe ürün ekler (SIPARISDETAY INSERT).
-- Stok düşürme ve sipariş toplamı güncelleme trigger'a bırakıldı.
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
-- Her kategori için toplam satış tutarını döndürür.
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
