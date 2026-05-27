-- ============================================================
-- Gun 6: Trigger Tanimlari
-- Onur: trg_stok_kontrol, trg_stok_dus
-- Ali: trg_siparis_toplam_gÜncelle
-- ============================================================
CREATE OR REPLACE FUNCTION fn_stok_kontrol()
RETURNS TRIGGER AS $$
DECLARE
    mevcut_stok INT;
BEGIN
    SELECT StokAdedi INTO mevcut_stok
    FROM URUNLER
    WHERE UrunID = NEW.UrunID;

    IF mevcut_stok < NEW.Miktar THEN
        RAISE EXCEPTION 'Yetersiz stok! Mevcut: %, Istenen: %', mevcut_stok, NEW.Miktar;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_stok_kontrol
BEFORE INSERT ON SIPARISDETAY
FOR EACH ROW
EXECUTE FUNCTION fn_stok_kontrol();

create or replace function fn_stok_dus()
returns trigger as $$
begin
    update URUNLER
    set StokAdedi = StokAdedi - new.Miktar
    where UrunID = new.UrunID;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_stok_dus
AFTER INSERT ON SIPARISDETAY
FOR EACH ROW
EXECUTE FUNCTION fn_stok_dus();


-- ============================================================
-- ALI HAMZA TEKINBAS -- Gun 6
-- ============================================================

-- Log tablosu: Durum degisikliklerini kayit altina alir
CREATE TABLE IF NOT EXISTS SIPARIS_LOG (
    LogID           SERIAL        PRIMARY KEY,
    SiparisID       INT           NOT NULL,
    EskiDurum       VARCHAR(20),
    YeniDurum       VARCHAR(20),
    DegisimZamani   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ToplamTutar guncelleme fonksiyonu
CREATE OR REPLACE FUNCTION fn_toplam_tutar_guncelle()
RETURNS TRIGGER AS $$
DECLARE
    v_siparis_id INT;
BEGIN
    IF TG_OP = 'DELETE' THEN
        v_siparis_id := OLD.SiparisID;
    ELSE
        v_siparis_id := NEW.SiparisID;
    END IF;

    UPDATE SIPARISLER
    SET ToplamTutar = (
        SELECT COALESCE(SUM(Miktar * BirimFiyat), 0)
        FROM SIPARISDETAY
        WHERE SiparisID = v_siparis_id
    )
    WHERE SiparisID = v_siparis_id;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- ToplamTutar trigger: SIPARISDETAY degisince otomatik hesapla
CREATE TRIGGER trg_siparis_toplam_guncelle
AFTER INSERT OR UPDATE OR DELETE
ON SIPARISDETAY
FOR EACH ROW
EXECUTE FUNCTION fn_toplam_tutar_guncelle();

-- Mevcut siparislerin ToplamTutar'ini guncelle
UPDATE SIPARISLER s
SET ToplamTutar = (
    SELECT COALESCE(SUM(sd.Miktar * sd.BirimFiyat), 0)
    FROM SIPARISDETAY sd
    WHERE sd.SiparisID = s.SiparisID
);

-- Durum degisikligi loglama fonksiyonu
CREATE OR REPLACE FUNCTION fn_siparis_durum_log()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.Durum IS DISTINCT FROM NEW.Durum THEN
        INSERT INTO SIPARIS_LOG (SiparisID, EskiDurum, YeniDurum)
        VALUES (NEW.SiparisID, OLD.Durum, NEW.Durum);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Durum log trigger
CREATE TRIGGER trg_siparis_durum_log
AFTER UPDATE
ON SIPARISLER
FOR EACH ROW
EXECUTE FUNCTION fn_siparis_durum_log();

