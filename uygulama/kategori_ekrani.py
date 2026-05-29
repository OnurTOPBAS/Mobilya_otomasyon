"""
Kategori Yonetim Ekrani
"""
import tkinter as tk
from tkinter import ttk, messagebox
from baglanti import baglanti_al


def kategorileri_yukle(tree):
    for satir in tree.get_children():
        tree.delete(satir)

    conn = baglanti_al()
    if conn is None:
        return
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT KategoriID, KategoriAdi, Aciklama FROM KATEGORILER ORDER BY KategoriID")
        for satir in cursor.fetchall():
            tree.insert("", "end", values=satir)
        cursor.close()
    except Exception as e:
        messagebox.showerror("Hata", f"Veri yuklenemedi: {e}")
    finally:
        conn.close()


def kategori_ekle(ad_entry, aciklama_entry, tree):
    ad = ad_entry.get().strip()
    aciklama = aciklama_entry.get().strip()

    if not ad:
        messagebox.showwarning("Uyari", "Kategori adi bos olamaz!")
        return

    conn = baglanti_al()
    if conn is None:
        return
    try:
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO KATEGORILER (KategoriAdi, Aciklama) VALUES (%s, %s)",
            (ad, aciklama if aciklama else None)
        )
        conn.commit()
        messagebox.showinfo("Basarili", "Kategori eklendi.")
        ad_entry.delete(0, tk.END)
        aciklama_entry.delete(0, tk.END)
        kategorileri_yukle(tree)
        cursor.close()
    except Exception as e:
        conn.rollback()
        messagebox.showerror("Hata", f"Eklenemedi: {e}")
    finally:
        conn.close()


def kategori_sil(tree):
    secili = tree.selection()
    if not secili:
        messagebox.showwarning("Uyari", "Silinecek kategoriyi secin.")
        return

    kategori_id = tree.item(secili[0])["values"][0]

    if not messagebox.askyesno("Onay", "Bu kategoriyi silmek istediginize emin misiniz?"):
        return

    conn = baglanti_al()
    if conn is None:
        return
    try:
        cursor = conn.cursor()
        cursor.execute("DELETE FROM KATEGORILER WHERE KategoriID = %s", (kategori_id,))
        conn.commit()
        messagebox.showinfo("Basarili", "Kategori silindi.")
        kategorileri_yukle(tree)
        cursor.close()
    except Exception as e:
        conn.rollback()
        messagebox.showerror("Hata", f"Silinemedi: {e}\n(Bu kategoriye bagli urun olabilir.)")
    finally:
        conn.close()


def ekrani_ac(parent):
    pencere = tk.Toplevel(parent)
    pencere.title("Kategoriler")
    pencere.geometry("700x500")

    tk.Label(pencere, text="KATEGORI YONETIMI",
             font=("Helvetica", 14, "bold")).pack(pady=10)

    cerceve = tk.Frame(pencere)
    cerceve.pack(fill="both", expand=True, padx=20, pady=10)

    tree = ttk.Treeview(cerceve, columns=("id", "ad", "aciklama"), show="headings", height=10)
    tree.heading("id", text="ID")
    tree.heading("ad", text="Kategori Adi")
    tree.heading("aciklama", text="Aciklama")
    tree.column("id", width=50)
    tree.column("ad", width=200)
    tree.column("aciklama", width=400)
    tree.pack(fill="both", expand=True)

    form_cerceve = tk.Frame(pencere)
    form_cerceve.pack(pady=10)

    tk.Label(form_cerceve, text="Kategori Adi:").grid(row=0, column=0, padx=5)
    ad_entry = tk.Entry(form_cerceve, width=25)
    ad_entry.grid(row=0, column=1, padx=5)

    tk.Label(form_cerceve, text="Aciklama:").grid(row=0, column=2, padx=5)
    aciklama_entry = tk.Entry(form_cerceve, width=30)
    aciklama_entry.grid(row=0, column=3, padx=5)

    btn_cerceve = tk.Frame(pencere)
    btn_cerceve.pack(pady=10)

    tk.Button(btn_cerceve, text="Ekle", width=15,
              command=lambda: kategori_ekle(ad_entry, aciklama_entry, tree)
              ).pack(side="left", padx=5)
    tk.Button(btn_cerceve, text="Sec ve Sil", width=15,
              command=lambda: kategori_sil(tree)).pack(side="left", padx=5)
    tk.Button(btn_cerceve, text="Yenile", width=15,
              command=lambda: kategorileri_yukle(tree)).pack(side="left", padx=5)

    kategorileri_yukle(tree)