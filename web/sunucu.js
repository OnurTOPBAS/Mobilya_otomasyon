
const express = require('express');
// PostgreSQL  için bağlantı sağlıyoruz (havuz sistemi)
const { Pool } = require('pg');

const havuz = new Pool({
    host: 'localhost',
    port: 5432,
    database: 'mobilyadb',
    user: 'onur',
    password: ''
});

const app = express();


const PORT = 3000;
app.use(express.static('public'));
// "/kategoriler" adresine GET isteği gelirse
app.get('/kategoriler', async function(istek, cevap) {
    try {
        const sonuc = await havuz.query('SELECT * FROM KATEGORILER ORDER BY KategoriID');
        cevap.json(sonuc.rows);
    } catch (hata) {
        console.log('Hata:', hata);
        cevap.status(500).send('Veri çekilemedi');
    }
});


app.listen(PORT, function() {
    console.log('Sunucu http://localhost:3000 adresinde çalışıyor');
});