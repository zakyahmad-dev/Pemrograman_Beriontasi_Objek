// =====================================================
// CLASS TURUNAN 1: KamarStandard
// Menerapkan konsep:
// - Inheritance  : extends Kamar (mewarisi semua milik Kamar)
// - Polymorphism : override method tampilkanInfo()
// =====================================================

import 'kamar.dart';

class KamarStandard extends Kamar {
  // Atribut tambahan khusus kamar standard
  // (tidak dimiliki class induk Kamar)
  String _fasilitas;

  // Constructor memanggil super() untuk mengisi field induk
  KamarStandard(String nomor, double harga, this._fasilitas)
      : super(nomor, 'Standard', harga);
  // 'Standard' dikirim sebagai tipeKamar ke constructor Kamar

  // Getter fasilitas
  String get fasilitas => _fasilitas;

  // Setter fasilitas: fasilitas tidak boleh kosong
  set fasilitas(String nilai) {
    if (nilai.trim().isEmpty) {
      throw ArgumentError('Fasilitas tidak boleh kosong!');
    }
    _fasilitas = nilai;
  }

  // ---- POLYMORPHISM ----
  // Override tampilkanInfo() dengan tampilan khusus Standard
  // Saat dipanggil dari List<Kamar>, Dart otomatis
  // memanggil versi ini (bukan versi induk)
  @override
  void tampilkanInfo() {
    // Format tampilan berbeda dari KamarVIP (polymorphism)
    print(
      '  [STANDARD] '
      'No: $nomor | '
      'Fasilitas: $_fasilitas | '
      'Harga: Rp${_formatRupiah(harga)}/malam | '
      'Status: $status'
      '${status == "Terisi" ? " (Tamu: $namaTamu)" : ""}',
    );
  }

  // Helper untuk format angka rupiah dengan titik ribuan
  String _formatRupiah(double angka) {
    String s = angka.toStringAsFixed(0);
    // Tambahkan titik setiap 3 digit dari belakang
    String hasil = '';
    int hitung = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      if (hitung > 0 && hitung % 3 == 0) hasil = '.$hasil';
      hasil = s[i] + hasil;
      hitung++;
    }
    return hasil;
  }
}