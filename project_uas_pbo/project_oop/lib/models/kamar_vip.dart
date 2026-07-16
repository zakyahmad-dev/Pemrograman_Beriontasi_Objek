// =====================================================
// CLASS TURUNAN 2: KamarVIP
// Menerapkan konsep:
// - Inheritance  : extends Kamar (mewarisi semua milik Kamar)
// - Polymorphism : override method tampilkanInfo()
// =====================================================

import 'kamar.dart';

class KamarVIP extends Kamar {
  // Atribut tambahan khusus kamar VIP
  String _pemandangan;
  bool   _termasukSarapan; // fitur ekstra kamar VIP

  // Constructor memanggil super() untuk mengisi field induk
  KamarVIP(String nomor, double harga, this._pemandangan,
      {bool termasukSarapan = true})
      : _termasukSarapan = termasukSarapan,
        super(nomor, 'VIP', harga);
  // 'VIP' dikirim sebagai tipeKamar ke constructor Kamar

  // Getter
  String get pemandangan      => _pemandangan;
  bool   get termasukSarapan  => _termasukSarapan;

  // Setter pemandangan
  set pemandangan(String nilai) {
    if (nilai.trim().isEmpty) {
      throw ArgumentError('Pemandangan tidak boleh kosong!');
    }
    _pemandangan = nilai;
  }

  // ---- POLYMORPHISM ----
  // Override tampilkanInfo() dengan tampilan khusus VIP
  // Tampilan berbeda dari KamarStandard meskipun method
  // dipanggil dengan cara yang sama dari List<Kamar>
  @override
  void tampilkanInfo() {
    String sarapan = _termasukSarapan ? 'Ya' : 'Tidak';
    print(
      '  [VIP] '
      'No: $nomor | '
      'Pemandangan: $_pemandangan | '
      'Sarapan: $sarapan | '
      'Harga: Rp${_formatRupiah(harga)}/malam | '
      'Status: $status'
      '${status == "Terisi" ? " (Tamu: $namaTamu)" : ""}',
    );
  }

  // Helper format rupiah (sama seperti di KamarStandard)
  String _formatRupiah(double angka) {
    String s = angka.toStringAsFixed(0);
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