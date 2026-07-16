// =====================================================
// CONTROLLER: HotelManager
// Menerapkan konsep:
// - Collection        : List dan Map
// - Higher Order Func : .where() .map() .fold() .any()
// - Async/Await       : simpanData() dengan Future
// - Generics          : Penyimpanan<T>
// =====================================================

import 'dart:async';
import '../models/kamar.dart';
import '../exceptions/reservasi_exception.dart';

// =============================================
// GENERICS CLASS
// <T> memungkinkan class ini menyimpan tipe data apapun
// Contoh: Penyimpanan<Kamar>, Penyimpanan<String>, dll
// =============================================
class Penyimpanan<T> {
  final List<T> _data = [];

  void tambah(T item)       => _data.add(item);
  void hapus(T item)        => _data.remove(item);
  List<T> ambilSemua()      => List.unmodifiable(_data);
  int get jumlah            => _data.length;
  bool get kosong           => _data.isEmpty;
}

// =============================================
// HOTEL MANAGER
// Mengelola semua operasi terkait kamar hotel
// =============================================
class HotelManager {

  // ---- COLLECTION: List ----
  // Menggunakan Generics Penyimpanan<Kamar>
  final Penyimpanan<Kamar> _penyimpanan = Penyimpanan<Kamar>();

  // ---- COLLECTION: Map ----
  // Menyimpan riwayat reservasi: nomor kamar -> nama tamu
  final Map<String, String> _riwayatReservasi = {};

  // ---- COLLECTION: Set ----
  // Menyimpan tipe kamar yang sudah pernah dipesan (unik)
  final Set<String> _tipeKamarPernahDipesan = {};

  // ===========================================
  // TAMBAH KAMAR
  // ===========================================
  void tambahKamar(Kamar kamar) {
    // Cek duplikat nomor kamar menggunakan .any() (Higher Order Function)
    bool sudahAda = _penyimpanan.ambilSemua().any(
      (k) => k.nomor == kamar.nomor,
    );

    if (sudahAda) {
      throw ReservasiException(
        'Kamar dengan nomor ${kamar.nomor} sudah ada!',
      );
    }
    _penyimpanan.tambah(kamar);
  }

  // ===========================================
  // LIHAT SEMUA KAMAR
  // Polymorphism terjadi di sini: tampilkanInfo()
  // dipanggil dari List<Kamar>, tapi Dart otomatis
  // memanggil versi yang sesuai (Standard/VIP)
  // ===========================================
  void tampilkanSemua() {
    List<Kamar> semua = _penyimpanan.ambilSemua();

    if (semua.isEmpty) {
      print('  Belum ada data kamar.');
      return;
    }

    // Kelompokkan berdasarkan tipe menggunakan Map
    // .where() adalah Higher Order Function
    List<Kamar> standard = semua
        .where((k) => k.tipeKamar == 'Standard')
        .toList();
    List<Kamar> vip = semua
        .where((k) => k.tipeKamar == 'VIP')
        .toList();

    print('\n  -- Kamar Standard (${standard.length} kamar) --');
    if (standard.isEmpty) {
      print('  Tidak ada kamar standard.');
    } else {
      // Polymorphism: tampilkanInfo() versi KamarStandard yang dipanggil
      for (var k in standard) k.tampilkanInfo();
    }

    print('\n  -- Kamar VIP (${vip.length} kamar) --');
    if (vip.isEmpty) {
      print('  Tidak ada kamar VIP.');
    } else {
      // Polymorphism: tampilkanInfo() versi KamarVIP yang dipanggil
      for (var k in vip) k.tampilkanInfo();
    }

    print('\n  Total: ${semua.length} kamar terdaftar');
  }

  // ===========================================
  // CARI KAMAR berdasarkan nomor atau tipe
  // Menggunakan .where() - Higher Order Function
  // ===========================================
  List<Kamar> cariKamar(String keyword) {
    // .where() menyaring list sesuai kondisi
    // .toList() mengubah hasil Iterable menjadi List
    return _penyimpanan.ambilSemua().where((k) {
      return k.nomor.contains(keyword) ||
             k.tipeKamar.toLowerCase().contains(keyword.toLowerCase()) ||
             k.status.toLowerCase().contains(keyword.toLowerCase());
    }).toList();
  }

  // ===========================================
  // HITUNG TOTAL PENDAPATAN dari kamar terisi
  // Menggunakan .fold() - Higher Order Function
  // fold() menggabungkan semua elemen menjadi satu nilai
  // ===========================================
  double hitungTotalPendapatan() {
    List<Kamar> terisi = _penyimpanan.ambilSemua()
        .where((k) => k.status == 'Terisi')
        .toList();

    // .fold(nilaiAwal, fungsi)
    // mulai dari 0, tambahkan harga setiap kamar terisi
    return terisi.fold(0.0, (total, kamar) => total + kamar.harga);
  }

  // ===========================================
  // BUAT RESERVASI
  // ===========================================
  Future<Map<String, dynamic>> buatReservasi({
    required String nomor,
    required String namaTamu,
    required int jumlahMalam,
  }) async {
    // Validasi input
    if (namaTamu.trim().isEmpty) {
      throw ReservasiException('Nama tamu tidak boleh kosong!');
    }
    if (jumlahMalam <= 0) {
      throw ReservasiException('Jumlah malam harus lebih dari 0!');
    }

    // Cari kamar yang diminta
    Kamar? kamarDipilih;
    for (var k in _penyimpanan.ambilSemua()) {
      if (k.nomor == nomor) {
        kamarDipilih = k;
        break;
      }
    }

    // Jika kamar tidak ditemukan
    if (kamarDipilih == null) {
      throw KamarTidakDitemukanException(
        'Kamar nomor $nomor tidak ditemukan!',
      );
    }

    // Jika kamar sudah terisi
    if (kamarDipilih.status == 'Terisi') {
      throw ReservasiException(
        'Kamar $nomor sedang terisi oleh ${kamarDipilih.namaTamu}!',
      );
    }

    // Proses reservasi (simulasi async)
    print('\n  [INFO]: Memproses reservasi...');
    await Future.delayed(Duration(seconds: 2)); // simulasi proses

    // Update data kamar
    kamarDipilih.status   = 'Terisi';
    kamarDipilih.namaTamu = namaTamu;

    // Simpan ke riwayat (Map)
    _riwayatReservasi[nomor] = namaTamu;

    // Simpan ke Set tipe yang pernah dipesan
    _tipeKamarPernahDipesan.add(kamarDipilih.tipeKamar);

    // Hitung biaya
    double subtotal = kamarDipilih.harga * jumlahMalam;
    double pajak    = subtotal * 0.10;
    double total    = subtotal + pajak;

    // Kembalikan data sebagai Map
    return {
      'kamar'       : kamarDipilih,
      'namaTamu'    : namaTamu,
      'jumlahMalam' : jumlahMalam,
      'subtotal'    : subtotal,
      'pajak'       : pajak,
      'total'       : total,
    };
  }

  // ===========================================
  // CHECKOUT (bebaskan kamar)
  // ===========================================
  Future<void> checkOut(String nomor) async {
    Kamar? kamar;
    for (var k in _penyimpanan.ambilSemua()) {
      if (k.nomor == nomor) {
        kamar = k;
        break;
      }
    }

    if (kamar == null) {
      throw KamarTidakDitemukanException(
        'Kamar nomor $nomor tidak ditemukan!',
      );
    }

    if (kamar.status == 'Tersedia') {
      throw ReservasiException('Kamar $nomor sudah dalam status Tersedia!');
    }

    print('\n  [INFO]: Memproses checkout...');
    await Future.delayed(Duration(seconds: 1)); // simulasi proses

    // Reset status kamar
    String namaTamuLama = kamar.namaTamu;
    kamar.status   = 'Tersedia';
    kamar.namaTamu = '-';

    print('  [Sukses]: Kamar $nomor atas nama "$namaTamuLama" telah checkout.');
  }

  // ===========================================
  // UPDATE HARGA KAMAR
  // ===========================================
  void updateHarga(String nomor, double hargaBaru) {
    Kamar? kamar;
    for (var k in _penyimpanan.ambilSemua()) {
      if (k.nomor == nomor) {
        kamar = k;
        break;
      }
    }

    if (kamar == null) {
      throw KamarTidakDitemukanException(
        'Kamar nomor $nomor tidak ditemukan!',
      );
    }

    // setter harga akan throw HargaTidakValidException jika negatif
    kamar.harga = hargaBaru;
  }

  // ===========================================
  // SIMPAN DATA (Async/Await)
  // Simulasi menyimpan data ke file/database
  // ===========================================
  Future<void> simpanData() async {
    print('\n  [INFO]: Menyimpan data ke sistem...');
    await Future.delayed(Duration(seconds: 2)); // simulasi delay I/O
    print('  [Sukses]: Data berhasil disimpan!');
    print('  Total kamar tersimpan : ${_penyimpanan.jumlah}');
    print('  Total reservasi aktif : ${_riwayatReservasi.length}');
  }

  // ===========================================
  // GETTER untuk akses data dari luar
  // ===========================================

  // Ambil semua kamar tersedia menggunakan .where()
  List<Kamar> get kamarTersedia => _penyimpanan.ambilSemua()
      .where((k) => k.status == 'Tersedia')
      .toList();

  // Ambil semua kamar terisi menggunakan .where()
  List<Kamar> get kamarTerisi => _penyimpanan.ambilSemua()
      .where((k) => k.status == 'Terisi')
      .toList();

  // Ambil riwayat reservasi (Map)
  Map<String, String> get riwayatReservasi =>
      Map.unmodifiable(_riwayatReservasi);

  // Ambil tipe kamar yang pernah dipesan (Set)
  Set<String> get tipeKamarPernahDipesan =>
      Set.unmodifiable(_tipeKamarPernahDipesan);

  // Cek apakah ada kamar yang tersedia (.any() HOF)
  bool get adaKamarTersedia => _penyimpanan.ambilSemua()
      .any((k) => k.status == 'Tersedia');

  // Cek apakah semua kamar terisi (.every() HOF)
  bool get semuaKamarTerisi => _penyimpanan.ambilSemua()
      .every((k) => k.status == 'Terisi');

  int get totalKamar => _penyimpanan.jumlah;

  // Ambil nama semua tamu yang sedang menginap (.map() HOF)
  List<String> get daftarNamaTamu => _penyimpanan.ambilSemua()
      .where((k) => k.status == 'Terisi')
      .map((k) => k.namaTamu)   // .map() mengubah setiap Kamar menjadi String nama
      .toList();
}