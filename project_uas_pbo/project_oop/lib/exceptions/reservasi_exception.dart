// =====================================================
// CUSTOM EXCEPTION
// Digunakan untuk menangani error spesifik pada sistem
// reservasi hotel. Implements Exception agar bisa di-
// throw dan di-catch seperti exception biasa di Dart.
// =====================================================

class ReservasiException implements Exception {
  final String pesan;

  // Constructor menerima pesan error yang deskriptif
  ReservasiException(this.pesan);

  // Override toString agar pesan tampil saat di-print
  @override
  String toString() => '[ReservasiException]: $pesan';
}

class HargaTidakValidException implements Exception {
  final String pesan;

  HargaTidakValidException(this.pesan);

  @override
  String toString() => '[HargaTidakValidException]: $pesan';
}

class KamarTidakDitemukanException implements Exception {
  final String pesan;

  KamarTidakDitemukanException(this.pesan);

  @override
  String toString() => '[KamarTidakDitemukanException]: $pesan';
}