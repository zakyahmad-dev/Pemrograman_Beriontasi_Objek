# Sistem Reservasi Hotel

Aplikasi manajemen reservasi hotel berbasis **CLI (Command Line Interface)** yang dibuat menggunakan bahasa pemrograman **Dart** dengan menerapkan konsep **Pemrograman Berorientasi Objek (OOP)**.

---

## Identitas Mahasiswa

| Keterangan       | Detail                                    |
|------------------|-------------------------------------------|
| **Nama**         | Zaky Ahmad Alkam Mushoffa                 |
| **NIM**          | 251240001666                              |
| **Mata Kuliah**  | Pemrograman Berorientasi Objek        
|
| **Semester**     | 2                                         |

---

## Tema Aplikasi

**Sistem Reservasi Hotel** — aplikasi untuk mengelola data kamar hotel, membuat reservasi, mencatat tamu, serta menghitung total pendapatan dari kamar yang terisi.

Aplikasi ini memiliki 2 jenis kamar:

-  **Kamar Standard** — kamar biasa dengan fasilitas dasar
-  **Kamar VIP** — kamar mewah dengan pemandangan dan sarapan

---

##  Fitur Program

Program memiliki menu utama sebagai berikut:

| No | Menu                          | Keterangan                                            |
|----|-------------------------------|-------------------------------------------------------|
| 1  | **Tambah Data Kamar**         | Menambah kamar baru (Standard/VIP) beserta harga      |
| 2  | **Lihat Semua Data Kamar**    | Menampilkan seluruh data kamar hotel                  |
| 3  | **Cari Kamar**                | Mencari kamar berdasarkan nomor, tipe, atau status    |
| 4  | **Hitung Total Pendapatan**   | Menghitung total pendapatan dari kamar terisi         |
| 5  | **Simpan Data**               | Simulasi penyimpanan data (async/await)               |
| 6  | **Buat Reservasi**            | Membuat reservasi kamar dan mencetak struk            |
| 7  | **Keluar**                    | Menutup program                                       |

---

##  Konsep OOP yang Diterapkan

| Konsep                          | Implementasi                                             |
|---------------------------------|----------------------------------------------------------|
| **Class & Object**              | `Kamar`, `KamarStandard`, `KamarVIP`, `HotelManager`     |
| **Encapsulation**               | Field `_nomor`, `_harga`, `_status` + getter/setter      |
| **Inheritance**                 | `KamarStandard` & `KamarVIP` extends `Kamar`             |
| **Polymorphism**                | Override method `tampilkanInfo()` di tiap subclass       |
| **Abstract Class & Interface**  | `Kamar` (abstract) & `IBisa` (interface)                 |
| **Collection**                  | `List`, `Map`, `Set`                                     |
| **Higher Order Function**       | `.where()`, `.map()`, `.fold()`, `.any()`, `.every()`    |
| **Custom Exception**            | `ReservasiException`, `HargaTidakValidException`         |
| **Async / Await**               | Simulasi proses reservasi & simpan data                  |

---

##  Struktur Folder

project_oop/
│
├── bin/
│ └── main.dart ← Entry point program
│
├── lib/
│ ├── models/
│ │ ├── kamar.dart ← Abstract class induk
│ │ ├── kamar_standard.dart ← Subclass Kamar Standard
│ │ └── kamar_vip.dart ← Subclass Kamar VIP
│ │
│ ├── controllers/
│ │ └── hotel_manager.dart ← Controller pengelola data
│ │
│ └── exceptions/
│ └── reservasi_exception.dart ← Custom exception
│
├── pubspec.yaml ← Konfigurasi project
└── README.md ← Dokumentasi project


## Cara Menjalankan Program

## syarat

Pastikan **Dart SDK** sudah terinstal di komputer.
Cek versi Dart dengan perintah:

```bash
dart --version
Jika belum terinstal, silakan download di sini:
https://dart.dev/get-dart

2️ Clone / Download Project
Bash

git clone https://github.com/username/project_oop.git
Atau download manual dari repositori GitHub.

3️ Masuk ke Folder Project
Bash

cd project_oop
4️ Install Dependency (opsional)
Bash

dart pub get
5️ Jalankan Program
Bash

dart run bin/main.dart
Contoh Tampilan Program
text

====================================
   SISTEM RESERVASI HOTEL UNISNU
====================================
  Data kamar berhasil dimuat.
  Total: 8 kamar siap dikelola.
====================================

====================================
         MENU UTAMA HOTEL
====================================
  1. Tambah Data Kamar
  2. Lihat Semua Data Kamar
  3. Cari Kamar
  4. Hitung Total Pendapatan
  5. Simpan Data
  6. Buat Reservasi
  7. Keluar
====================================
  Tersedia  : 8 kamar
  Terisi    : 0 kamar
====================================
Pilih menu (1-7):

Catatan

Program ini dibuat untuk memenuhi tugas Ujian Akhir Semester (UAS) mata kuliah Pemrograman Berorientasi Objek (Dart).
Fokus utama program adalah penerapan konsep OOP yang benar, rapi, dan mudah dipahami.
Program berjalan di terminal (CLI), tanpa tampilan grafis.
