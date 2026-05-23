# Tablo Tasarımı

**Belge Amacı:** Bu doküman, Gün 2'de aldığımız tablo tasarımı kararlarını kayıt altına alır. Gün 3'te SQL `CREATE TABLE` cümlelerini yazarken bu doküman referans olarak kullanılacaktır.

**Hazırlayanlar:** Onur TOPBAŞ, Ali Hamza TEKİNBAŞ
**Tarih:** Gün 2

---

## İçindekiler

1. [Genel Tasarım Kararları](#1-genel-tasarım-kararları)
2. [KATEGORILER Tablosu](#2-kategoriler-tablosu)
3. [URUNLER Tablosu](#3-urunler-tablosu)
4. [MUSTERILER Tablosu](#4-musteriler-tablosu)
5. [SIPARISLER Tablosu](#5-siparisler-tablosu)
6. [SIPARISDETAY Tablosu](#6-siparisdetay-tablosu)
7. [İlişki (Foreign Key) Özeti](#7-i̇lişki-foreign-key-özeti)
8. [Kısıtlayıcı (Constraint) Özeti](#8-kısıtlayıcı-constraint-özeti)
9. [Tasarım Kararlarının Gerekçeleri](#9-tasarım-kararlarının-gerekçeleri)

---

## 1. Genel Tasarım Kararları

| Karar | Seçim | Gerekçe |
|---|---|---|
| VTYS | PostgreSQL | Trigger, View, Index ve Procedure için güçlü destek; çapraz platform |
| Birincil anahtar stratejisi | `SERIAL` (otomatik artan) | Manuel ID yönetiminden kaçınmak; PostgreSQL'in IDENTITY karşılığı |
| Para tipi | `NUMERIC(10,2)` ve `NUMERIC(12,2)` | `FLOAT` yuvarlama hatası yapar, `NUMERIC` kesindir |
| Tarih tipi | `TIMESTAMP` | Hem tarih hem saat tutar; sipariş zamanlaması için gerekli |
| Karakter sınırı yaklaşımı | İhtiyaca göre `VARCHAR(n)`, uzun metinler için `TEXT` | VARCHAR'da `n` mantıksal sınır; PostgreSQL'de performans farkı yoktur |

---

## 2. KATEGORILER Tablosu

Mobilya mağazasının ürün kategorilerini tutar (örn. "Yatak Odası", "Oturma Grupları").

| Sütun | Tip | NOT NULL | UNIQUE | DEFAULT | Açıklama |
|---|---|---|---|---|---|
| KategoriID | SERIAL | ✓ (PK) | — | otomatik | Birincil anahtar |
| KategoriAdi | VARCHAR(100) | ✓ | ✓ | — | Kategori adı, tekil olmalı |
| Aciklama | TEXT | ✗ | — | — | Opsiyonel açıklama |

---

## 3. URUNLER Tablosu

Mağazadaki tüm ürünleri tutar. Her ürün bir kategoriye aittir.

| Sütun | Tip | NOT NULL | UNIQUE | DEFAULT | CHECK | Açıklama |
|---|---|---|---|---|---|---|
| UrunID | SERIAL | ✓ (PK) | — | otomatik | — | Birincil anahtar |
| KategoriID | INT | ✓ (FK) | — | — | — | KATEGORILER tablosuna bağlanır |
| UrunAdi | VARCHAR(150) | ✓ | — | — | — | Açıklayıcı ürün adı için uzun |
| Aciklama | TEXT | ✗ | — | — | — | Ürün açıklaması (opsiyonel) |
| Marka | VARCHAR(50) | ✗ | — | — | — | Yerli atölye için boş bırakılabilir |
| Renk | VARCHAR(40) | ✗ | — | — | — | Renk adı (örn. "Antrasit Gri") |
| RenkKodu | VARCHAR(7) | ✗ | — | — | — | Hex kodu (örn. "#4A4A4A") |
| Fiyat | NUMERIC(10,2) | ✓ | — | — | `> 0` | Maks. 99.999.999,99 TL |
| StokAdedi | INT | ✓ | — | 0 | `>= 0` | Negatif olamaz, 0 olabilir |
| EklenmeTarihi | TIMESTAMP | ✓ | — | CURRENT_TIMESTAMP | — | Otomatik atanır |

---

## 4. MUSTERILER Tablosu

Mağazaya kayıtlı müşterileri tutar.

| Sütun | Tip | NOT NULL | UNIQUE | DEFAULT | Açıklama |
|---|---|---|---|---|---|
| MusteriID | SERIAL | ✓ (PK) | — | otomatik | Birincil anahtar |
| AdSoyad | VARCHAR(100) | ✓ | — | — | Bireysel veya tüzel isim |
| Email | VARCHAR(100) | ✗ | ✓ | — | Opsiyonel ama tekil |
| Telefon | VARCHAR(20) | ✓ | ✓ | — | Zorunlu, tekil iletişim bilgisi |
| KayitTarihi | TIMESTAMP | ✓ | — | CURRENT_TIMESTAMP | Otomatik atanır |

**Önemli not:** Müşteri adresi bu tabloda tutulmaz, sipariş başına alıcı ve teslimat bilgisi SIPARISLER tablosunda yer alır (bkz. Bölüm 9).

---

## 5. SIPARISLER Tablosu

Her satır bir siparişin başlık bilgisini tutar. Sipariş içeriği SIPARISDETAY tablosundadır.

| Sütun | Tip | NOT NULL | DEFAULT | CHECK | Açıklama |
|---|---|---|---|---|---|
| SiparisID | SERIAL | ✓ (PK) | otomatik | — | Birincil anahtar |
| MusteriID | INT | ✓ (FK) | — | — | Siparişi veren müşteri |
| AliciAdSoyad | VARCHAR(100) | ✓ | — | — | Paketi alacak kişi |
| AliciTelefon | VARCHAR(20) | ✓ | — | — | Kargo iletişimi |
| TeslimatAdresi | TEXT | ✓ | — | — | Paketin gideceği adres |
| SiparisTarihi | TIMESTAMP | ✓ | CURRENT_TIMESTAMP | — | Otomatik atanır |
| Durum | VARCHAR(20) | ✓ | 'Hazırlanıyor' | `IN (...)` | Sipariş durumu |
| ToplamTutar | NUMERIC(12,2) | ✓ | 0 | `>= 0` | Trigger ile hesaplanır |

**Durum sütununun alabileceği değerler:**
- 'Hazırlanıyor'
- 'Kargoda'
- 'Teslim Edildi'
- 'İptal'

---

## 6. SIPARISDETAY Tablosu

Sipariş ile ürün arasındaki çok-a-çok ilişkiyi çözen ara tablodur (junction table). Bir siparişin içindeki her ürün için bir satır.

| Sütun | Tip | NOT NULL | DEFAULT | CHECK | Açıklama |
|---|---|---|---|---|---|
| SiparisDetayID | SERIAL | ✓ (PK) | otomatik | — | Birincil anahtar |
| SiparisID | INT | ✓ (FK) | — | — | Bağlı olduğu sipariş |
| UrunID | INT | ✓ (FK) | — | — | Sipariş edilen ürün |
| Miktar | INT | ✓ | — | `> 0` | Sipariş adedi |
| BirimFiyat | NUMERIC(10,2) | ✓ | — | `> 0` | Sipariş anındaki fiyat |

---

## 7. İlişki (Foreign Key) Özeti

| Çocuk Tablo | Çocuk Sütun | Ebeveyn Tablo | Ebeveyn Sütun | ON DELETE | Gerekçe |
|---|---|---|---|---|---|
| URUNLER | KategoriID | KATEGORILER | KategoriID | RESTRICT | Ürünü olan kategori silinemesin |
| SIPARISLER | MusteriID | MUSTERILER | MusteriID | RESTRICT | Siparişi olan müşteri silinemesin |
| SIPARISDETAY | SiparisID | SIPARISLER | SiparisID | CASCADE | Sipariş silinince detayları da silinsin |
| SIPARISDETAY | UrunID | URUNLER | UrunID | RESTRICT | Satılmış ürün silinemesin |

---

## 8. Kısıtlayıcı (Constraint) Özeti

### Primary Key (5)
Her tabloda otomatik artan ID sütunu üzerinde.

### Foreign Key (4)
Yukarıdaki Bölüm 7'de detaylandırıldı.

### UNIQUE (3)
- `KATEGORILER.KategoriAdi`
- `MUSTERILER.Email`
- `MUSTERILER.Telefon`

### CHECK (6)
- `URUNLER.Fiyat > 0`
- `URUNLER.StokAdedi >= 0`
- `SIPARISDETAY.Miktar > 0`
- `SIPARISDETAY.BirimFiyat > 0`
- `SIPARISLER.ToplamTutar >= 0`
- `SIPARISLER.Durum IN ('Hazırlanıyor', 'Kargoda', 'Teslim Edildi', 'İptal')`

### DEFAULT (5)
- `URUNLER.StokAdedi = 0`
- `URUNLER.EklenmeTarihi = CURRENT_TIMESTAMP`
- `MUSTERILER.KayitTarihi = CURRENT_TIMESTAMP`
- `SIPARISLER.SiparisTarihi = CURRENT_TIMESTAMP`
- `SIPARISLER.Durum = 'Hazırlanıyor'`
- `SIPARISLER.ToplamTutar = 0`

---

## 9. Tasarım Kararlarının Gerekçeleri

### 9.1 Adres Bilgisinin SIPARISLER'e Taşınması

Adres alanını MUSTERILER tablosundan çıkarıp SIPARISLER tablosuna yerleştirdik. Bunun nedeni, bir müşterinin her zaman kendi adresine sipariş vermek zorunda olmamasıdır. Müşteri, sipariş verdiği anda hediye gönderimi veya farklı bir teslimat noktası seçebilir.

Daha kapsamlı bir sistemde adres bilgilerinin ayrı bir tabloda tutulması (Address Book Pattern) daha uygun olurdu. Ancak ders projesi kapsamı için sipariş içine yerleştirme yaklaşımı yeterli görüldü.

### 9.2 Alıcı Bilgilerinin Ayrı Tablo Olmaması

Alıcı bilgilerinin (AliciAdSoyad, AliciTelefon) ayrı bir ALICILAR tablosu olarak değil, SIPARISLER tablosunun sütunları olarak modellenmesinin nedeni şu üç testtir:

- Alıcının bağımsız bir kimliği yoktur; sipariş tamamlandıktan sonra anlamı kalmaz.
- Alıcı üzerinde bağımsız işlem yapılmaz (silme, güncelleme, sorgulama).
- Her sipariş için alıcı bilgisi farklı olabilir, dolayısıyla tekrar eden bir varlık değildir.

### 9.3 SIPARISDETAY.BirimFiyat Sütununun Varlığı

Ürün fiyatı URUNLER tablosunda zaten tutuluyor olmasına rağmen SIPARISDETAY tablosunda BirimFiyat sütunu ayrıca tutuldu. Bunun nedeni siparişin verildiği andaki fiyatın korunması gerekliliğidir. Ürün fiyatı sonradan değişirse, geçmiş siparişlerin tutarları yanlış raporlanmamalıdır. Bu yaklaşım kurumsal sistemlerde "Snapshot Pattern" olarak bilinir.

### 9.4 Header-Detail Yapısı

Sipariş bilgisi iki tabloya bölünmüştür: tek seferlik bilgileri (tarih, müşteri, adres, toplam) içeren SIPARISLER ve sipariş içindeki her ürün için bir satır içeren SIPARISDETAY. Bu yapı, fiş/fatura sistemlerinin klasik tasarımıdır ve veri tekrarını önler, tutarlılığı garanti eder.

### 9.5 ON DELETE Davranışları

- **RESTRICT** (Kategori, Müşteri, Ürün): Bir varlığın silinmesi başka kayıtları yetim bırakacaksa silmeyi engelle. Veri bütünlüğünü korur.
- **CASCADE** (Sipariş → Detay): Bir sipariş silindiğinde detayları da otomatik silinsin. Detaylar siparişten bağımsız anlam taşımaz.

### 9.6 NUMERIC vs FLOAT Tercihi

Para birimleri için `NUMERIC(10,2)` tercih edildi. `FLOAT` veya `REAL` türleri, ikilik tabanlı kayan nokta gösterimi nedeniyle yuvarlama hataları üretir (örn. 0.1 + 0.2 ≠ 0.3). `NUMERIC` ondalık aritmetik kullandığı için para hesaplamalarında kesin sonuç verir.

### 9.7 VARCHAR Boyutlandırması

PostgreSQL'de `VARCHAR(50)` ile `VARCHAR(100)` arasında depolama veya performans farkı yoktur; VARCHAR sadece girilen veri kadar yer kaplar, `n` değeri yalnızca mantıksal bir tavandır. Bu nedenle boyutlandırmada cömert davranıldı (ad-soyad ve email için 100, ürün adı için 150). Bu, ileride veri uzunluğu nedeniyle yaşanabilecek girememe sorunlarını önler.
