"""
PostgreSQL Veritabani Baglanti Modülü
Tüm ekranlar bu modülden bağlanti alır.
"""
import psycopg2


def baglanti_al():
    """PostgreSQL'e baglanti olusturur ve geri doner."""
    try:
        conn = psycopg2.connect(
            host="localhost",
            port="5432",
            database="mobilyadb",
            user="onur",
            password=""
        )
        return conn
    except Exception as e:
        print(f"Baglanti hatasi: {e}")
        return None


if __name__ == "__main__":
    conn = baglanti_al()
    if conn:
        print("Baglanti basarili!")
        conn.close()
    else:
        print("Baglanti basarisiz.")