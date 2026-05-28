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
