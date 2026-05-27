-- ================================================
-- GUN 6: TRIGGERLAR
-- Yazan: Ali Hamza TEKINBAS
--
-- TRIGGER nedir:
--   Belirli bir olay (INSERT, UPDATE, DELETE)
--   gerceklestiginde PostgreSQL'in otomatik
--   olarak calistirdigi fonksiyondur.
--   Trigger = olay + fonksiyon ikilisidir.
--
-- Bu dosyada 2 trigger yazilmistir:
--   1) trg_siparis_toplam_guncelle
--      -> SIPARISDETAY degisince ToplamTutar
--         otomatik hesaplanir.
--   2) trg_siparis_durum_log
--      -> SIPARISLER'de Durum degisince
--         SIPARIS_LOG tablosuna kayit duser.
-- ================================================


-- ================================================
-- ADIM 1: LOG tablosu olustur
-- Durum degisikliklerini buraya kayit edecegiz.
-- ================================================
CREATE TABLE IF NOT EXISTS SIPARIS_LOG (
    LogID           SERIAL          PRIMARY KEY,
    SiparisID       INT             NOT NULL,
    EskiDurum       VARCHAR(20),
    YeniDurum       VARCHAR(20),
    DegisimZamani   TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ================================================
-- ADIM 2: ToplamTutar guncelleme fonksiyonu
--
-- SIPARISDETAY'a her INSERT / UPDATE / DELETE
-- olayinda bu fonksiyon cagrilir.
-- Ilgili siparisteki tum satirlarin
-- Miktar * BirimFiyat toplamini hesaplayip
-- SIPARISLER.ToplamTutar'a yazar.
-- ================================================
CREATE OR REPLACE FUNCTION fn_toplam_tutar_guncelle()
RETURNS TRIGGER AS $$
DECLARE
    v_siparis_id INT;
BEGIN
    -- Hangi siparis etkilendi?
    IF TG_OP = 'DELETE' THEN
        v_siparis_id := OLD.SiparisID;
    ELSE
        v_siparis_id := NEW.SiparisID;
    END IF;

    -- O siparisteki tum satirlarin toplamini hesapla
    UPDATE SIPARISLER
    SET ToplamTutar = (
        SELECT COALESCE(SUM(Miktar * BirimFiyat), 0)
        FROM SIPARISDETAY
        WHERE SiparisID = v_siparis_id
    )
    WHERE SiparisID = v_siparis_id;

    RETURN NULL;  -- AFTER trigger icin NULL yeterli
END;
$$ LANGUAGE plpgsql;


-- ================================================
-- ADIM 3: ToplamTutar triggerini bagliyoruz
-- ================================================
CREATE TRIGGER trg_siparis_toplam_guncelle
AFTER INSERT OR UPDATE OR DELETE
ON SIPARISDETAY
FOR EACH ROW
EXECUTE FUNCTION fn_toplam_tutar_guncelle();


-- ================================================
-- ADIM 4: Mevcut siparislerin ToplamTutar'ini
-- manuel guncelle (trigger sadece bundan sonraki
-- olaylar icin calisir; eski kayitlar 0.00 kalir)
-- ================================================
UPDATE SIPARISLER s
SET ToplamTutar = (
    SELECT COALESCE(SUM(sd.Miktar * sd.BirimFiyat), 0)
    FROM SIPARISDETAY sd
    WHERE sd.SiparisID = s.SiparisID
);


-- ================================================
-- ADIM 5: Durum degisikligi loglama fonksiyonu
--
-- SIPARISLER tablosunda Durum sutunu degisirse
-- (ornegin: Hazirlaniyor -> Kargoda)
-- eski ve yeni degerleri SIPARIS_LOG'a yazar.
-- ================================================
CREATE OR REPLACE FUNCTION fn_siparis_durum_log()
RETURNS TRIGGER AS $$
BEGIN
    -- Durum gercekten degisti mi?
    IF OLD.Durum IS DISTINCT FROM NEW.Durum THEN
        INSERT INTO SIPARIS_LOG (SiparisID, EskiDurum, YeniDurum)
        VALUES (NEW.SiparisID, OLD.Durum, NEW.Durum);
    END IF;
    RETURN NEW;  -- AFTER UPDATE -> NEW satirini dondur
END;
$$ LANGUAGE plpgsql;


-- ================================================
-- ADIM 6: Durum log triggerini bagliyoruz
-- ================================================
CREATE TRIGGER trg_siparis_durum_log
AFTER UPDATE
ON SIPARISLER
FOR EACH ROW
EXECUTE FUNCTION fn_siparis_durum_log();


-- ================================================
-- TEST 1: ToplamTutar guncellendi mi?
-- Beklenen: 0.00 yerine gercek tutarlar gelmeli
-- ================================================
SELECT SiparisID, ToplamTutar FROM SIPARISLER ORDER BY SiparisID;


-- ================================================
-- TEST 2: Durum degistirip logu kontrol et
-- ================================================
UPDATE SIPARISLER SET Durum = 'Kargoda'
WHERE SiparisID = 3 AND Durum = 'Hazirlaniyor';

SELECT * FROM SIPARIS_LOG;
