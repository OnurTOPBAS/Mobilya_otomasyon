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

