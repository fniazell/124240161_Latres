# Rick & Morty Character Explorer

Aplikasi Flutter **Rick & Morty Character Explorer** yang dibuat untuk memenuhi seluruh ketentuan tugas Latihan Responsi Mobile Programming.

Aplikasi ini mengusung tema **Cartoon Sci-Fi Adventure** yang terinspirasi dari serial Rick and Morty, terhubung langsung dengan API resmi Rick & Morty, serta dilengkapi dengan autentikasi lokal berbasis SQLite dan manajemen favorit persisten via SharedPreferences.

---

## 🚀 Fitur Utama

### 1. Autentikasi (Login & Register)
- **Register Akun**: Mendaftarkan akun baru (nama, username/email, password, konfirmasi password). Password dienkripsi menggunakan hashing **SHA-256** dan disimpan di database lokal **SQLite**. Terdapat pencegahan duplikasi username.
- **Login Akun**: Memverifikasi kredensial akun dari database SQLite.
- **Sesi Persisten**: Status login disimpan menggunakan **SharedPreferences**. Saat aplikasi dibuka kembali, pengguna yang sudah login langsung diarahkan ke layar utama.
- **Logout**: Tombol logout dengan dialog konfirmasi, menghapus sesi login dan mengarahkan pengguna ke layar login dengan pencegahan navigasi kembali (*back button*).
- **Auth Guard**: Layar utama dan detail diproteksi sehingga hanya dapat diakses setelah login.

### 2. Home Screen (Penjelajah Karakter)
- **Data Asli dari API**: Mengambil daftar karakter dari endpoint resmi `GET https://rickandmortyapi.com/api/character`.
- **Informasi Kartu Karakter**: Menampilkan foto karakter dari API, nama karakter, badge status (Alive, Dead, Unknown dengan warna khusus), serta ikon favorit interaktif.
- **Filter Status Karakter**: Tombol filter dinamis untuk `All`, `Alive` (`?status=alive`), `Dead` (`?status=dead`), dan `Unknown` (`?status=unknown`).
- **Pencarian Karakter**: Fitur pencarian karakter berdasarkan nama (`?name={nama}`) dengan tombol reset dan penanganan 404 ketika karakter tidak ditemukan.
- **Pagination (Infinite Scroll)**: Mendukung pemuatan halaman berikutnya secara mulus saat scroll mencapai bagian bawah.
- **Akses Cepat**: Tombol menuju halaman episode di app bar.

### 3. Detail Screen
- **Tampilan Hero**: Foto karakter resolusi penuh dengan transisi gradien yang menyatu dengan latar belakang luar angkasa.
- **Informasi Lengkap**: Nama karakter, nomor registry dimensi, status badge, spesies, gender, tipe (jika ada), asal (*origin*), lokasi terakhir (*location*), dan jumlah episode kemunculan.
- **Manajemen Favorit**: Tombol toggle favorit di app bar dan panel aksi dengan notifikasi Snackbar ketika berhasil ditambahkan atau dihapus.

### 4. Favorite Screen
- **Penyimpanan Persisten**: Daftar karakter favorit disimpan di **SharedPreferences** dalam bentuk JSON sehingga tidak hilang ketika aplikasi ditutup.
- **Swipe-to-Dismiss**: Pengguna dapat menghapus karakter favorit dengan gesture swipe ke kiri menggunakan widget `Dismissible` yang dilengkapi indikator hapus dan feedback Snackbar.
- **Sinkronisasi Reaktif**: Perubahan status favorit di Home, Detail, maupun Favorite Screen langsung sinkron secara instan.
- **Empty State Menarik**: Tampilan ilustrasi portal kartun sci-fi dengan pesan *"Your portal is empty!"* dan tombol eksplorasi karakter.

### 5. Episode Screen
- **Data Episode Asli**: Mengambil daftar episode dari `GET https://rickandmortyapi.com/api/episode`.
- **Informasi Episode**: Menampilkan nama episode, tanggal penayangan (*air date*), dan kode episode (contoh: `S01E01`).
- **Fitur Layar**: Loading indicator, pagination, dan tombol retry bila terjadi kegagalan jaringan.

### 6. Bottom Navigation Bar
- Dua navigasi utama: **Explorer** dan **Favorites** (dengan badge jumlah favorit).
- Menjaga state antartab menggunakan `IndexedStack` tanpa melakukan request API yang tidak diperlukan.

---

## 🎨 Konsep Desain UI

- **Tema**: Cartoon Sci-Fi Adventure (terinspirasi dari portal antardimensi Rick & Morty).
- **Palet Warna**:
  - Portal Green (`#00FF9D`)
  - Electric Lime (`#97CE4C`)
  - Deep Space Navy (`#0B0F19`)
  - Cosmic Cyan (`#00E5FF`)
  - Dimension Purple (`#8B5CF6`)
  - Toxic Red (`#EF4444`)
  - Morty Yellow (`#FACC15`)
- **Elemen Visual**: Rounded cards, outline tegas, glow shadows, badge status menyala, serta tata letak responsif bebas overflow.

---

## 🛠️ Arsitektur & Struktur Direktori

```
lib/
├── constants/
│   └── app_theme.dart             # Konfigurasi warna, tipografi, dan tema aplikasi
├── models/
│   ├── character_model.dart       # Model data karakter Rick & Morty
│   ├── episode_model.dart         # Model data episode
│   └── user_model.dart            # Model data akun pengguna
├── providers/
│   ├── auth_provider.dart         # Pengelolaan autentikasi dan status sesi
│   ├── character_provider.dart    # Pengelolaan daftar karakter, filter, dan pencarian
│   ├── episode_provider.dart      # Pengelolaan daftar episode dan pagination
│   └── favorite_provider.dart     # Pengelolaan daftar favorit persisten
├── screens/
│   ├── detail_screen.dart         # Halaman detail spesifikasi karakter
│   ├── episode_screen.dart        # Halaman daftar episode serial
│   ├── favorite_screen.dart       # Halaman karakter favorit (swipe-to-dismiss)
│   ├── home_screen.dart           # Halaman utama penjelajah karakter
│   ├── login_screen.dart          # Halaman masuk dimensi
│   ├── main_nav_screen.dart       # Pembungkus bottom navigation bar
│   ├── register_screen.dart       # Halaman registrasi akun baru
│   └── splash_screen.dart         # Layar pembuka beranimasi & pengecekan sesi
├── services/
│   ├── api_service.dart           # Service HTTP untuk Rick & Morty REST API
│   ├── database_helper.dart       # SQLite Database (sqflite) dengan hash SHA-256
│   └── session_manager.dart       # Penyimpanan sesi via SharedPreferences
├── widgets/
│   ├── cartoon_button.dart        # Tombol kartun bertema sci-fi
│   ├── character_card.dart        # Kartu karakter pada grid dua kolom
│   ├── custom_text_field.dart     # Input form dengan ikon dan validasi
│   ├── empty_state_view.dart      # Komponen portal kosong sci-fi
│   ├── portal_card.dart           # Kontainer kartu dengan border portal
│   └── status_badge.dart          # Badge status karakter (Alive, Dead, Unknown)
└── main.dart                      # Titik awal aplikasi Flutter
```

---

## 📦 Dependency yang Digunakan

- `http: ^1.6.0`: HTTP Client untuk REST API Rick & Morty.
- `shared_preferences: ^2.5.6`: Penyimpanan sesi login dan daftar favorit persisten.
- `sqflite: ^2.4.6`: Database SQLite untuk penyimpanan akun pengguna.
- `sqflite_common_ffi: ^2.4.7`: Dukungan SQLite pada platform desktop/Windows.
- `provider: ^6.1.5+1`: Manajemen state aplikasi.
- `crypto: ^3.0.8`: Enkripsi password menggunakan SHA-256.
- `path: ^1.9.1`: Utilitas manipulasi path file database.

---

## 💻 Cara Menjalankan Aplikasi

1. **Unduh dependensi**:
   ```bash
   flutter pub get
   ```

2. **Jalankan pengujian (Unit & Widget Tests)**:
   ```bash
   flutter test
   ```

3. **Jalankan pada perangkat Android**:
   ```bash
   flutter run -d <device_id_or_emulator>
   ```

4. **Jalankan pada Browser Chrome**:
   ```bash
   flutter run -d chrome
   ```

5. **Jalankan pada Windows Desktop**:
   ```bash
   flutter run -d windows
   ```
