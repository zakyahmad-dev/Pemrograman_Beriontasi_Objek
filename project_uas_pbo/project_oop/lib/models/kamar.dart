// =====================================================
// CLASS INDUK: Kamar (Abstract)
// Menerapkan konsep:
// - Encapsulation  : field private dengan getter/setter
// - Abstraction    : abstract class dengan method abstrak
// - Interface      : implements IBisa (kontrak method)
// =====================================================

import '../exceptions/reservasi_exception.dart';

// ---- INTERFACE ----
// Di Dart, interface dibuat menggunakan abstract class.
// Setiap class yang implements IBisa WAJIB mengisi semua
// method yang ada di dalam IBisa ini.
abstract class IBisa {
  void tampilkanInfo(); // wajib diimplementasi
  String getStatus();   // wajib diimplementasi
}

// ---- ABSTRACT CLASS INDUK ----
// Abstract class tidak bisa dibuat objeknya langsung,
// hanya bisa diwariskan ke class turunan.
abstract class Kamar implements IBisa {
  // ---- ENCAPSULATION: field private ----
  // Field diawali _ agar hanya bisa diakses dalam class ini
  String _nomor;
  String _tipeKamar;
  double _harga;
  String _status;
  String _namaTamu; // menyimpan nama tamu yang memesan

  // ---- CONSTRUCTOR ----
  Kamar(this._nomor, this._tipeKamar, this._harga)
      : _status = 'Tersedia',  // status awal selalu Tersedia
        _namaTamu = '-';       // nama tamu kosong jika belum dipesan

  // =============================================
  // GETTER: mengambil nilai field private dari luar
  // =============================================
  String get nomor     => _nomor;
  String get tipeKamar => _tipeKamar;
  double get harga     => _harga;
  String get status    => _status;
  String get namaTamu  => _namaTamu;

  // =============================================
  // SETTER dengan validasi (bagian dari Encapsulation)
  // =============================================

  // Setter harga: harga tidak boleh negatif atau nol
  set harga(double nilai) {
    // throw exception jika harga tidak valid
    if (nilai <= 0) {
      throw HargaTidakValidException(
        'Harga harus lebih dari 0. Nilai yang dimasukkan: $nilai',
      );
    }
    _harga = nilai;
  }

  // Setter status: hanya boleh 'Tersedia' atau 'Terisi'
  set status(String nilai) {
    if (nilai != 'Tersedia' && nilai != 'Terisi') {
      throw ReservasiException(
        'Status hanya boleh "Tersedia" atau "Terisi". Nilai: $nilai',
      );
    }
    _status = nilai;
  }

  // Setter namaTamu: nama tidak boleh kosong jika status Terisi
  set namaTamu(String nama) {
    if (nama.trim().isEmpty) {
      throw ReservasiException('Nama tamu tidak boleh kosong!');
    }
    _namaTamu = nama;
  }

  // =============================================
  // METHOD getStatus dari interface IBisa
  // =============================================
  @override
  String getStatus() => _status;

  // =============================================
  // METHOD ABSTRAK: wajib di-override oleh turunan
  // =============================================
  @override
  void tampilkanInfo(); // tidak ada body, harus diisi di subclass
}