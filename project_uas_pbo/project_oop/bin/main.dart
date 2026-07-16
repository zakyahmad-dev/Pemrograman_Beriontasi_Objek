// =====================================================
// UJIAN AKHIR SEMESTER - PEMROGRAMAN BERORIENTASI OBJEK
// NIM   : 251240001666
// Nama  : ZAKY AHMAD ALKAM MUSHOFFA
// Tema  : Sistem Reservasi Hotel
// File  : bin/main.dart (Entry Point Program)
// =====================================================

import 'dart:io';
import '../lib/models/kamar_standard.dart';
import '../lib/models/kamar_vip.dart';
import '../lib/controllers/hotel_manager.dart';
import '../lib/exceptions/reservasi_exception.dart';

// Future<void> karena main perlu async untuk await
Future<void> main() async {
  // Buat instance HotelManager sebagai controller utama
  final HotelManager manager = HotelManager();

  // =============================================
  // DATA AWAL: isi kamar hotel saat program start
  // =============================================
  _isiDataAwal(manager);

  bool jalan = true; // kontrol loop utama

  // =============================================
  // LOOP UTAMA PROGRAM
  // =============================================
  while (jalan) {
    _tampilkanMenu(manager);

    stdout.write('Pilih menu (1-7): ');
    String pilihan = stdin.readLineSync()?.trim() ?? '';

    print(''); // baris kosong

    switch (pilihan) {

      // ==========================================
      // MENU 1: Tambah Data Kamar
      // ==========================================
      case '1':
        await _menuTambahKamar(manager);
        break;

      // ==========================================
      // MENU 2: Lihat Semua Data Kamar
      // ==========================================
      case '2':
        _menuLihatSemua(manager);
        break;

      // ==========================================
      // MENU 3: Cari Kamar
      // ==========================================
      case '3':
        _menuCariKamar(manager);
        break;

      // ==========================================
      // MENU 4: Hitung Total Pendapatan
      // ==========================================
      case '4':
        _menuHitungTotal(manager);
        break;

      // ==========================================
      // MENU 5: Simpan Data (Async/Await)
      // ==========================================
      case '5':
        await _menuSimpanData(manager);
        break;

      // ==========================================
      // MENU 6: Buat Reservasi
      // ==========================================
      case '6':
        await _menuBuatReservasi(manager);
        break;

      // ==========================================
      // MENU 7: Keluar
      // ==========================================
      case '7':
        print('  Terima kasih! Sampai jumpa kembali.');
        print('  --    Sistem Reservasi Hotel    --');
        jalan = false;
        break;

      // ==========================================
      // INPUT TIDAK VALID
      // ==========================================
      default:
        print('  [Error]: Pilihan tidak valid! Masukkan angka 1-7.');
    }

    // Jeda sebelum tampil menu lagi (kecuali keluar)
    if (jalan) {
      print('');
      stdout.write('  Tekan Enter untuk kembali ke menu...');
      stdin.readLineSync();
    }
  }
}

// =============================================
// FUNGSI: isi data kamar awal hotel
// =============================================
void _isiDataAwal(HotelManager manager) {
  try {
    // KamarStandard: Inheritance dari Kamar
    manager.tambahKamar(KamarStandard('101', 350000, 'AC, TV, WiFi'));
    manager.tambahKamar(KamarStandard('102', 350000, 'AC, TV, WiFi'));
    manager.tambahKamar(KamarStandard('103', 400000, 'AC, TV, WiFi, Bathtub'));
    manager.tambahKamar(KamarStandard('104', 400000, 'AC, TV, WiFi, Bathtub'));

    // KamarVIP: Inheritance dari Kamar
    manager.tambahKamar(KamarVIP('201', 850000, 'Kolam Renang'));
    manager.tambahKamar(KamarVIP('202', 850000, 'Taman Kota'));
    manager.tambahKamar(KamarVIP('203', 1200000, 'Pantai',
        termasukSarapan: true));
    manager.tambahKamar(KamarVIP('204', 1500000, 'Pemandangan Gunung',
        termasukSarapan: true));

    print('====================================');
    print('       SISTEM RESERVASI HOTEL       ');
    print('====================================');
    print('  Data kamar berhasil dimuat.');
    print('  Total: ${manager.totalKamar} kamar siap dikelola.');
    print('====================================');
  } on ReservasiException catch (e) {
    // Tangkap custom exception ReservasiException
    print('[Error inisialisasi]: $e');
  } catch (e) {
    // Tangkap exception lainnya
    print('[Error tidak terduga]: $e');
  }
}

// =============================================
// FUNGSI: tampilkan menu utama
// =============================================
void _tampilkanMenu(HotelManager manager) {
  print('\n====================================');
  print('         MENU UTAMA HOTEL           ');
  print('====================================');
  print('  1. Tambah Data Kamar');
  print('  2. Lihat Semua Data Kamar');
  print('  3. Cari Kamar');
  print('  4. Hitung Total Pendapatan');
  print('  5. Simpan Data');
  print('  6. Buat Reservasi');
  print('  7. Keluar');
  print('====================================');
  print('  Tersedia  : ${manager.kamarTersedia.length} kamar');
  print('  Terisi    : ${manager.kamarTerisi.length} kamar');
  print('====================================');
}

// =============================================
// MENU 1: Tambah Kamar Baru
// =============================================
Future<void> _menuTambahKamar(HotelManager manager) async {
  print('  --- TAMBAH DATA KAMAR ---');
  print('  Pilih tipe kamar:');
  print('  1. Kamar Standard');
  print('  2. Kamar VIP');
  stdout.write('  Pilih tipe (1/2): ');
  String tipe = stdin.readLineSync()?.trim() ?? '';

  try {
    stdout.write('  Nomor kamar : ');
    String nomor = stdin.readLineSync()?.trim() ?? '';

    if (nomor.isEmpty) {
      throw ReservasiException('Nomor kamar tidak boleh kosong!');
    }

    stdout.write('  Harga/malam : Rp');
    double harga = double.tryParse(stdin.readLineSync()?.trim() ?? '') ?? -1;

    // Validasi harga
    if (harga <= 0) {
      throw ReservasiException(
        'Harga tidak valid! Masukkan angka lebih dari 0.',
      );
    }

    if (tipe == '1') {
      stdout.write('  Fasilitas   : ');
      String fasilitas = stdin.readLineSync()?.trim() ?? '';

      if (fasilitas.isEmpty) {
        throw ReservasiException('Fasilitas tidak boleh kosong!');
      }

      // Buat objek KamarStandard dan tambahkan
      manager.tambahKamar(KamarStandard(nomor, harga, fasilitas));
      print('  [Sukses]: Kamar Standard $nomor berhasil ditambahkan!');

    } else if (tipe == '2') {
      stdout.write('  Pemandangan : ');
      String pemandangan = stdin.readLineSync()?.trim() ?? '';

      if (pemandangan.isEmpty) {
        throw ReservasiException('Pemandangan tidak boleh kosong!');
      }

      stdout.write('  Termasuk sarapan? (y/n): ');
      String sarapanInput = stdin.readLineSync()?.trim().toLowerCase() ?? 'y';
      bool sarapan = sarapanInput == 'y';

      // Buat objek KamarVIP dan tambahkan
      manager.tambahKamar(
        KamarVIP(nomor, harga, pemandangan, termasukSarapan: sarapan),
      );
      print('  [Sukses]: Kamar VIP $nomor berhasil ditambahkan!');

    } else {
      print('  [Error]: Tipe kamar tidak valid!');
    }

  } on ReservasiException catch (e) {
    // Tangkap custom exception
    print('  $e');
  } on KamarTidakDitemukanException catch (e) {
    print('  $e');
  } catch (e) {
    // Tangkap semua exception lain
    print('  [Error tidak terduga]: $e');
  }
}

// =============================================
// MENU 2: Lihat Semua Kamar
// =============================================
void _menuLihatSemua(HotelManager manager) {
  print('  --- DAFTAR SEMUA KAMAR ---');

  // Polymorphism terjadi di sini dalam manager.tampilkanSemua()
  // tampilkanInfo() dipanggil dari List<Kamar>,
  // tapi Dart memanggil versi yang sesuai tipe aslinya
  manager.tampilkanSemua();

  // Tampilkan info tambahan
  if (manager.daftarNamaTamu.isNotEmpty) {
    print('\n  Tamu yang sedang menginap:');
    // .map() HOF: mengubah list kamar menjadi list nama tamu
    for (String nama in manager.daftarNamaTamu) {
      print('  - $nama');
    }
  }

  // Cek dengan .any() - Higher Order Function
  if (!manager.adaKamarTersedia) {
    print('\n  [INFO]: Semua kamar sedang terisi!');
  }
}

// =============================================
// MENU 3: Cari Kamar
// =============================================
void _menuCariKamar(HotelManager manager) {
  print('  --- CARI KAMAR ---');
  print('  (Cari berdasarkan nomor, tipe, atau status)');
  stdout.write('  Kata kunci: ');
  String keyword = stdin.readLineSync()?.trim() ?? '';

  if (keyword.isEmpty) {
    print('  [Error]: Kata kunci tidak boleh kosong!');
    return;
  }

  try {
    // .where() Higher Order Function ada di dalam cariKamar()
    List hasil = manager.cariKamar(keyword);

    if (hasil.isEmpty) {
      print('  Tidak ditemukan kamar dengan kata kunci "$keyword".');
    } else {
      print('  Ditemukan ${hasil.length} kamar:');
      for (var k in hasil) {
        // Polymorphism: tampilkanInfo() sesuai tipe kamar
        k.tampilkanInfo();
      }
    }
  } catch (e) {
    print('  [Error]: $e');
  }
}

// =============================================
// MENU 4: Hitung Total Pendapatan
// =============================================
void _menuHitungTotal(HotelManager manager) {
  print('  --- HITUNG TOTAL PENDAPATAN ---');

  // .fold() Higher Order Function ada di dalam hitungTotalPendapatan()
  double total = manager.hitungTotalPendapatan();

  print('  Kamar terisi    : ${manager.kamarTerisi.length} kamar');
  print('  Kamar tersedia  : ${manager.kamarTersedia.length} kamar');
  print('  Total pendapatan: Rp${_formatRupiah(total)}/malam');

  // Tampilkan riwayat reservasi (Map)
  Map<String, String> riwayat = manager.riwayatReservasi;
  if (riwayat.isNotEmpty) {
    print('\n  Riwayat Reservasi Aktif:');
    riwayat.forEach((nomor, nama) {
      print('  Kamar $nomor -> $nama');
    });
  }

  // Tampilkan tipe yang pernah dipesan (Set - tidak ada duplikat)
  Set<String> tipeDipesan = manager.tipeKamarPernahDipesan;
  if (tipeDipesan.isNotEmpty) {
    print('\n  Tipe kamar yang pernah dipesan:');
    for (String tipe in tipeDipesan) {
      print('  - $tipe');
    }
  }

  // Cek semua kamar terisi dengan .every() HOF
  if (manager.semuaKamarTerisi) {
    print('\n  [INFO]: Semua kamar sedang terisi. Hotel penuh!');
  }
}

// =============================================
// MENU 5: Simpan Data (Async/Await)
// =============================================
Future<void> _menuSimpanData(HotelManager manager) async {
  print('  --- SIMPAN DATA ---');
  try {
    // await menunggu proses async selesai sebelum lanjut
    await manager.simpanData();
  } catch (e) {
    print('  [Error saat menyimpan]: $e');
  }
}

// =============================================
// MENU 6: Buat Reservasi (Async/Await)
// =============================================
Future<void> _menuBuatReservasi(HotelManager manager) async {
  print('  --- BUAT RESERVASI ---');

  // Cek apakah ada kamar tersedia
  if (!manager.adaKamarTersedia) {
    print('  Maaf, tidak ada kamar yang tersedia saat ini.');
    return;
  }

  // Tampilkan kamar yang tersedia
  print('  Kamar yang tersedia:');
  for (var k in manager.kamarTersedia) {
    k.tampilkanInfo(); // Polymorphism
  }

  try {
    // Input data reservasi
    stdout.write('\n  Nama tamu     : ');
    String nama = stdin.readLineSync()?.trim() ?? '';

    stdout.write('  Nomor kamar   : ');
    String nomor = stdin.readLineSync()?.trim() ?? '';

    stdout.write('  Jumlah malam  : ');
    int malam = int.tryParse(stdin.readLineSync()?.trim() ?? '') ?? 0;

    // await menunggu proses reservasi selesai (ada delay 2 detik)
    Map<String, dynamic> hasil = await manager.buatReservasi(
      nomor      : nomor,
      namaTamu   : nama,
      jumlahMalam: malam,
    );

    // Tampilkan struk reservasi
    _tampilkanStruk(hasil);

    // Tanya apakah ingin simpan sekarang
    stdout.write('\n  Simpan data sekarang? (y/n): ');
    String simpan = stdin.readLineSync()?.trim().toLowerCase() ?? 'n';
    if (simpan == 'y') {
      await manager.simpanData();
    }

  } on ReservasiException catch (e) {
    // Tangkap custom exception ReservasiException
    print('  $e');
  } on KamarTidakDitemukanException catch (e) {
    // Tangkap custom exception KamarTidakDitemukanException
    print('  $e');
  } on HargaTidakValidException catch (e) {
    // Tangkap custom exception HargaTidakValidException
    print('  $e');
  } catch (e) {
    // Tangkap semua exception lain
    print('  [Error tidak terduga]: $e');
  }
}

// =============================================
// HELPER: Tampilkan struk reservasi
// =============================================
void _tampilkanStruk(Map<String, dynamic> data) {
  print('\n  ====================================');
  print('           STRUK RESERVASI            ');
  print('  ====================================');
  print('  Nama Tamu    : ${data['namaTamu']}');
  data['kamar'].tampilkanInfo(); // Polymorphism
  print('  Jml. Malam   : ${data['jumlahMalam']} malam');
  print('  Subtotal     : Rp${_formatRupiah(data['subtotal'])}');
  print('  Pajak (10%)  : Rp${_formatRupiah(data['pajak'])}');
  print('  TOTAL BAYAR  : Rp${_formatRupiah(data['total'])}');
  print('  ====================================');
  print('  [Sukses]: Reservasi berhasil dibuat!');
}

// =============================================
// HELPER: Format angka menjadi format rupiah
// =============================================
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