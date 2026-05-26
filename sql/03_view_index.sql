create view vw_urun_katalog as
select
    U.UrunID,
    U.UrunAdi,
    K.KategoriAdi,
    U.Marka,
    U.Renk,
    U.Fiyat,
    U.StokAdedi
    FROM URUNLER U
INNER JOIN KATEGORILER K ON U.KategoriID = K.KategoriID;


create view vw_stok_durumu as
select
    U.UrunID,
    U.UrunAdi,
    K.KategoriAdi,
    U.StokAdedi
from URUNLER U
inner join KATEGORILER K on U.KategoriID = K.KategoriID
where U.StokAdedi < 10;

CREATE INDEX ix_urunler_kategori ON URUNLER(KategoriID);
SELECT indexname FROM pg_indexes WHERE tablename = 'urunler';