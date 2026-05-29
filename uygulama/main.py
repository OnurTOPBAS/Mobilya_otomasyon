"""
Mobilya Otomasyonu - Ana Menu
"""
import tkinter as tk


def kategori_ekrani_ac():
    import kategori_ekrani
    kategori_ekrani.ekrani_ac(root)


def urun_ekrani_ac():
    print("Urun ekrani henuz hazir degil (Ali yazacak)")


def musteri_ekrani_ac():
    print("Musteri ekrani henuz hazir degil")


def siparis_ekrani_ac():
    print("Siparis ekrani henuz hazir degil")


root = tk.Tk()
root.title("Mobilya Otomasyon Sistemi")
root.geometry("400x500")

tk.Label(root, text="MOBILYA OTOMASYON SISTEMI",
         font=("Helvetica", 16, "bold"), pady=20).pack()

tk.Button(root, text="Kategoriler", width=25, height=2,
          command=kategori_ekrani_ac).pack(pady=10)
tk.Button(root, text="Urunler", width=25, height=2,
          command=urun_ekrani_ac).pack(pady=10)
tk.Button(root, text="Musteriler", width=25, height=2,
          command=musteri_ekrani_ac).pack(pady=10)
tk.Button(root, text="Siparisler", width=25, height=2,
          command=siparis_ekrani_ac).pack(pady=10)
tk.Button(root, text="Cikis", width=25, height=2,
          command=root.quit).pack(pady=10)

root.mainloop()