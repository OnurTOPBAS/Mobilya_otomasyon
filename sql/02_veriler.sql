-- ================================================
-- GUN 4: SIPARISLER ve SIPARISDETAY TEST VERİSİ
-- Yazan: Ali Hamza TEKINBAS
-- Aciklama: SIPARISLER tablosuna 10 adet gercekci
-- siparis kaydi girildi. Her siparisin alici bilgisi,
-- teslimat adresi ve durumu farkli tutularak
-- gercek hayat senaryolari yansitildi.
-- SIPARISDETAY'a ise her siparise en az 1 urun
-- eklenerek FK baglantisi test edildi.
-- ================================================

-- SIPARISLER: 10 adet siparis kaydi
INSERT INTO SIPARISLER (MusteriID, AliciAdSoyad, AliciTelefon, TeslimatAdresi, Durum) VALUES
(1,  'Onur TOPBAS',        '05321112233', 'Izmit Merkez, Kocaeli',  'Teslim Edildi'),
(2,  'Ali Hamza TEKINBAS', '05422223344', 'Gebze, Kocaeli',         'Kargoda'),
(3,  'Burak Alp AYDOGMUS', '05053334455', 'Kadikoy, Istanbul',      'Hazirlaniyor'),
(4,  'Taha SARIKAYA',      '05554445566', 'Umraniye, Istanbul',     'Teslim Edildi'),
(5,  'Gani Efe HARPUTLU',  '05335556677', 'Konak, Izmir',           'Iptal'),
(6,  'Fatih YARDIM',       '05436667788', 'Cankaya, Ankara',        'Hazirlaniyor'),
(7,  'Erdem SAHIN',        '05067778899', 'Nilufer, Bursa',         'Kargoda'),
(8,  'Eren Can AYDIN',     '05548889900', 'Selcuklu, Konya',        'Teslim Edildi'),
(9,  'Tevfik Fetih ERKIN', '05359990011', 'Atakum, Samsun',         'Hazirlaniyor'),
(10, 'Ozkan BAKI',         '05440001122', 'Melikgazi, Kayseri',     'Kargoda');

-- SIPARISDETAY: Her sipariste en az 1 urun
-- BirimFiyat: urunun siparis anindaki fiyati baz alindi
INSERT INTO SIPARISDETAY (SiparisID, UrunID, Miktar, BirimFiyat) VALUES
(1,  17, 1, 6500.00),    -- Gardirop
(1,  19, 2,  850.00),    -- Zigon Sehpa x2 (ayni siparise 2 urun)
(2,  11, 1, 12500.50),   -- Deri Kanepe
(3,  12, 1, 2100.00),    -- Calisma Masasi
(3,  14, 1, 4100.75),    -- TV Unitesi (ayni siparise 2 urun)
(4,  15, 2, 5500.00),    -- Ranza x2
(5,  13, 1, 3400.00),    -- Yemek Masasi
(6,  16, 1, 3200.00),    -- Banyo Dolabi
(7,  18, 1, 14500.00),   -- Bahce Takimi
(8,  20, 1, 4500.00),    -- Baza
(9,  12, 1, 2100.00),    -- Calisma Masasi
(10, 11, 1, 12500.50);   -- Deri Kanepe
