INSERT INTO KATEGORILER (KategoriAdi, Aciklama) VALUES
('Oturma Grubu', 'Koltuk, Kanepe'),
('Çalışma Odası', 'Çalışma Masası,Sandalye,Kitaplık'),
('Mutfak Mobilyası', 'Mutfak Dolabı,Yemek Masası,Sandalye'),
('TV Üniteleri', 'Tv Ünitesi,Kitaplık'),
('Çocuk Odası', 'Yatak,Dolap,Çalışma Masası,Lambader'),
('Banyo Mobilyası', 'Banyo Dolabı,Duşakabin,Ayna'),
('Dolaplar', 'Mutfak Dolabı,Banyo Dolabı,Kıyafet Dolabı'),
('Bahçe Mobilyası', 'Bahçe Masası,Sandalye,Tente'),
('Sehpalar', 'Zigon Sehpa,Orta Sehpa,Yan Sehpa,Dresuar Sehpa')
('Yatak Odası', 'Yatak, Dolap, Komodin');

INSERT INTO MUSTERILER (AdSoyad, Email, Telefon) VALUES
('Onur TOPBAŞ', 'onurtopbas@gmail.com', '05321112233'),
('Ali Hamza TEKİNBAŞ', 'alhamtek@gmail.com', '05422223344'),
('Burak Alp AYDOĞMUŞ', 'aydogmusburakalp@gmail.com', '05053334455'),
('Taha SARIKAYA', 'mtahasarıkaya@gmail.com', '05554445566'),
('Gani Efe HARPUTLU', 'ganiefe@gmail.com', '05335556677'),
('Fatih YARDIM', 'fatihyar@gmail.com', '05436667788'),
('Erdem ŞAHİN', 'erdemsahinofficial@gmail.com', '05067778899'),
('Eren Can AYDIN', 'erencanaydin@gmail.com', '05548889900'),
('Tevfik Fetih ERKİN', 'tevfikfetih@gmail.com', '05359990011'),
('Özkan BAKİ', 'ozkanbaki@gmail.com', '05440001122');


INSERT INTO URUNLER (KategoriID, UrunAdi, Aciklama, Marka, Renk, RenkKodu, Fiyat, StokAdedi) VALUES
(1, '3 Kişilik Deri Kanepe', 'Suni deri, rahat oturum alanı', 'Bellona', 'Siyah', '#000000', 12500.50, 5),
(2, 'L Tipi Çalışma Masası', 'Geniş yüzeyli köşe masası', 'Vivense', 'Beyaz', '#FFFFFF', 2100.00, 20),
(3, 'Açılabilir Yemek Masası', '4-6 kişilik mutfak masası', 'Kelebek', 'Ceviz', '#5C4033', 3400.00, 12),
(4, 'Led Işıklı TV Ünitesi', 'Ekstra saklama alanlı, duvar raflı', 'Enza Home', 'Antrasit', '#293133', 4100.75, 8),
(5, 'Metal Ranza', 'Güvenlik korkuluklu ve merdivenli', 'Çilek', 'Gri', '#808080', 5500.00, 10),
(6, 'Aynalı Banyo Dolabı Takımı', 'Lavabo altı dolap ve üst aynalı modül', 'Vitra', 'Beyaz', '#FFFFFF', 3200.00, 15),
(7, '3 Kapılı Sürgülü Gardırop', 'Boy aynalı ve geniş iç hacimli', 'IKEA', 'Siyah', '#000000', 6500.00, 7),
(8, 'Bahçe Takımı', 'Suya dayanıklı 1 masa ve 4 sandalye', 'Mudo', 'Kahverengi', '#964B00', 14500.00, 4),
(9, '3lü Zigon Sehpa Takımı', 'Metal ayaklı pratik kullanım', 'Vivense', 'Ceviz', '#5C4033', 850.00, 30),
(10, 'Çift Kişilik Baza', 'Modern görünümlü ', 'IKEA', 'Meşe', '#C2B280', 4500.00, 15);
