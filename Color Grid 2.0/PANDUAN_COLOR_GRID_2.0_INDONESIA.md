# PANDUAN LENGKAP COLOR GRID 2.0 - BAHASA INDONESIA

## DESKRIPSI PLUGIN
Color Grid 2.0 adalah plugin untuk grandma2 yang secara otomatis membuat sistem color grid lengkap dengan:
- Preset warna (100-112)
- Sequence warna untuk setiap group
- Macro untuk kontrol warna
- Layout view yang terorganisir

---

## PERSIAPAN SEBELUM MENJALANKAN PLUGIN

### 1. **BUAT GROUP FIXTURES TERLEBIH DAHULU**
   - Buka **Group Pool** di grandma2
   - Buat group-group fixtures yang ingin Anda kontrol warnanya
   - **PENTING:** Group harus dimulai dari **Group 1** dan berurutan (1, 2, 3, 4, dst)
   - Contoh:
     - Group 1: Moving Head Stage Left
     - Group 2: Moving Head Stage Right
     - Group 3: LED Par Upstage
     - Group 4: LED Strip Floor
   
   **CATATAN:** Jumlah group yang Anda buat akan menentukan berapa banyak macro yang dibuat!

### 2. **SIAPKAN RUANG KOSONG**
   Plugin ini akan membuat banyak item, pastikan Anda punya ruang kosong untuk:
   - **Image Pool:** Minimal 40+ slot kosong (untuk gambar warna)
   - **Preset Pool 4 (Color):** Slot 100-112 akan DIHAPUS dan diganti
   - **Executor/Button:** Sesuai jumlah group Anda
   - **Macro Pool:** Banyak slot kosong (lihat perhitungan di bawah)
   - **Layout View:** 1 slot kosong untuk layout

### 3. **BACKUP SHOWFILE ANDA**
   **SANGAT PENTING!** Plugin ini akan:
   - Menghapus Preset 4.100 sampai 4.112
   - Membuat banyak macro baru
   - Membuat sequence baru
   
   Backup showfile Anda sebelum menjalankan plugin!

---

## PERHITUNGAN JUMLAH MACRO YANG AKAN DIBUAT

Plugin ini membuat BANYAK macro karena sistem yang komprehensif:

### Formula Perhitungan:
```
Jumlah Macro = (Jumlah Group × 12) + (Jumlah Group + 1) × 12

Breakdown:
- Setiap group mendapat 12 macro (untuk 12 warna berbeda)
- Group "All" (semua fixtures) juga mendapat 12 macro
- Total = Group individu + Group "All"
```

### Contoh Perhitungan:

**Jika Anda punya 4 Group:**
- Macro untuk Group 1-4: 4 × 12 = 48 macro
- Macro untuk Group "All": 1 × 12 = 12 macro
- **TOTAL: 60 macro**

**Jika Anda punya 8 Group:**
- Macro untuk Group 1-8: 8 × 12 = 96 macro
- Macro untuk Group "All": 1 × 12 = 12 macro
- **TOTAL: 108 macro**

**Jika Anda punya 12 Group:**
- Macro untuk Group 1-12: 12 × 12 = 144 macro
- Macro untuk Group "All": 1 × 12 = 12 macro
- **TOTAL: 156 macro**

### Mengapa Banyak Macro?

Setiap group mendapat 12 macro untuk 12 warna:
1. White (Putih)
2. Red (Merah)
3. Orange (Oranye)
4. Yellow (Kuning)
5. Green (Hijau)
6. Sea Green (Hijau Laut)
7. Cyan (Cyan)
8. Blue (Biru)
9. Lavender (Lavender)
10. Pink (Pink)
11. Magenta (Magenta)
12. UV (Ultraviolet)

Ini memberikan kontrol cepat untuk setiap kombinasi group dan warna!

---

## LANGKAH-LANGKAH MENJALANKAN PLUGIN

### TAHAP 1: PILIH GAMBAR
**Dialog:** "PILIH GAMBAR"

**Pertanyaan:** "JUMLAH GAMBAR ADALAH [X] GAMBAR AKAN DISIMPAN!"

**Apa yang harus dijawab:**
- Masukkan **nomor slot Image Pool** dimana gambar pertama akan disimpan
- Contoh: Jika Anda ketik `500`, maka gambar akan disimpan di slot 500-540
- Plugin akan membuat sekitar 40+ gambar warna

**Tips:**
- Pilih nomor yang cukup tinggi agar tidak bentrok dengan image yang sudah ada
- Pastikan ada ruang kosong minimal 40+ slot dari nomor yang Anda pilih

---

### TAHAP 2: KONFIRMASI HAPUS PRESET
**Dialog:** "PERHATIAN!"

**Pesan:** "PRESET WARNA DARI 100 SAMPAI 112 AKAN DIHAPUS"

**Apa yang harus dijawab:**
- Klik **OK** jika Anda setuju preset 4.100-4.112 dihapus
- Klik **Cancel** jika Anda ingin membatalkan

**Yang Terjadi:**
- Preset Color 4.100 sampai 4.112 akan dihapus
- Preset baru untuk 12 warna akan dibuat di slot tersebut
- Setiap group akan mendapat preset warna yang sama

---

### TAHAP 3: PILIH EXECUTOR UNTUK SEQUENCE
**Dialog:** "PERHATIAN!"

**Pesan:** "ANDA HARUS MEMILIH EXECUTOR BUTTON KOSONG UNTUK SEQUENCE WARNA. DARI [X] EXECUTOR AKAN DISIMPAN."

**Apa yang harus dijawab:**

#### A. Input Nomor Halaman
**Dialog:** "HALAMAN UNTUK SEQUENCE"
**Pertanyaan:** "MASUKKAN NOMOR HALAMAN UNTUK SEQUENCE"

- Masukkan nomor **Page** dimana sequence akan disimpan
- Contoh: `1` untuk Page 1, `2` untuk Page 2, dst

#### B. Input Nomor Executor
**Dialog:** "EXECUTOR ATAU BUTTON MANA"
**Pertanyaan:** "CONTOH: 101"

- Masukkan nomor **Executor** awal (format: 101, 201, 301, dst)
- Contoh: `201` = Page yang dipilih, Executor 201
- Plugin akan menggunakan executor berurutan dari nomor ini

**Contoh:**
- Jika Anda punya 4 group dan pilih executor `201`:
  - Group 1 sequence → Executor 201
  - Group 2 sequence → Executor 202
  - Group 3 sequence → Executor 203
  - Group 4 sequence → Executor 204

**Tips:**
- Pilih executor yang kosong dan berurutan
- Pastikan ada cukup executor kosong sesuai jumlah group Anda

---

### TAHAP 4: PILIH NOMOR MACRO
**Dialog:** "PERHATIAN!"

**Pesan:** "SEKARANG ANDA HARUS MEMILIH NOMOR AWAL MACRO DIMANA [X] MACRO AKAN DISIMPAN"

**Pertanyaan:** "BERAPA NOMOR MACRO. CONTOH MACRO ADALAH 400"

**Apa yang harus dijawab:**
- Masukkan nomor **Macro** awal dimana macro pertama akan disimpan
- Contoh: `400` = Macro akan dimulai dari 400, 401, 402, dst
- Ingat perhitungan jumlah macro di atas!

**Contoh:**
- Jika Anda punya 4 group dan pilih macro `400`:
  - Macro 400-411: Group 1 (12 warna)
  - Macro 412-423: Group 2 (12 warna)
  - Macro 424-435: Group 3 (12 warna)
  - Macro 436-447: Group 4 (12 warna)
  - Macro 448-459: Group "All" (12 warna)
  - **Total: 60 macro**

**Tips:**
- Pilih nomor yang cukup tinggi (400+) agar tidak bentrok
- Pastikan ada ruang kosong sesuai perhitungan jumlah macro

---

### TAHAP 5: PILIH LAYOUT VIEW
**Dialog:** "TAMPILAN LAYOUT ANDA"

**Pertanyaan:** "PILIH JENDELA UNTUK LAYOUT ANDA"

**Apa yang harus dijawab:**
- Masukkan nomor **Layout View** dimana layout akan dibuat
- Contoh: `10` = Layout akan dibuat di Layout 10
- Layout ini akan menampilkan semua macro dalam grid yang terorganisir

**Tips:**
- Pilih layout view yang kosong
- Layout ini akan menjadi control panel warna Anda

---

## STRUKTUR HASIL YANG DIBUAT

### 1. **Preset Pool (4.100 - 4.112)**
12 preset warna standar:
- 100: White
- 101: Red
- 102: Orange
- 103: Yellow
- 104: Green
- 105: Sea Green
- 106: Cyan
- 107: Blue
- 108: Lavender
- 109: Pink
- 110: Magenta
- 111: UV

### 2. **Sequence Pool**
Satu sequence untuk setiap group yang berisi 12 cue (satu untuk setiap warna)

### 3. **Macro Pool**
Macro terorganisir per group:
- **Group 1:** Macro [start] sampai [start+11] (12 warna)
- **Group 2:** Macro [start+12] sampai [start+23] (12 warna)
- **Group 3:** Macro [start+24] sampai [start+35] (12 warna)
- dst...
- **Group "All":** Macro terakhir (12 warna untuk semua fixtures)

### 4. **Layout View**
Grid visual yang menampilkan semua macro dengan:
- Icon warna untuk setiap macro
- Terorganisir per group
- Mudah diakses untuk kontrol cepat

---

## CARA MENGGUNAKAN SETELAH PLUGIN SELESAI

### Menggunakan Macro:
1. Buka **Macro Pool**
2. Klik macro warna yang diinginkan
3. Warna akan langsung diterapkan ke group yang sesuai

### Menggunakan Layout View:
1. Buka **Layout View** yang Anda pilih
2. Anda akan melihat grid warna yang terorganisir
3. Klik button warna untuk mengaktifkan
4. Lebih visual dan mudah digunakan daripada macro pool

### Menggunakan Sequence:
1. Buka **Sequence Pool**
2. Jalankan sequence untuk group tertentu
3. Sequence akan cycle melalui semua 12 warna

---

## TROUBLESHOOTING

### "Nilai Tidak Valid! Input harus berupa angka"
**Penyebab:** Anda memasukkan teks atau karakter yang bukan angka
**Solusi:** Masukkan hanya angka (contoh: 400, bukan "empat ratus")

### "NILAI TIDAK VALID! Nilai harus berupa angka!"
**Penyebab:** Sama seperti di atas
**Solusi:** Masukkan hanya angka

### Macro terlalu banyak
**Penyebab:** Anda punya banyak group
**Solusi:** 
- Kurangi jumlah group sebelum menjalankan plugin, ATAU
- Pastikan Anda punya cukup ruang di Macro Pool

### Plugin berhenti di tengah jalan
**Penyebab:** Mungkin kehabisan ruang atau ada konflik
**Solusi:**
- Restore backup showfile Anda
- Periksa kembali ruang yang tersedia
- Jalankan ulang dengan nomor slot yang berbeda

---

## TIPS & BEST PRACTICES

1. **Mulai dengan Group Sedikit**
   - Jika pertama kali, coba dengan 2-3 group dulu
   - Pahami cara kerjanya sebelum membuat untuk banyak group

2. **Gunakan Nomor Tinggi**
   - Image: 500+
   - Macro: 400+
   - Executor: 201+ (di page terpisah)
   - Ini menghindari konflik dengan item yang sudah ada

3. **Organisasi Group**
   - Beri nama group yang jelas
   - Urutkan group sesuai posisi fisik fixtures
   - Ini memudahkan saat menggunakan macro

4. **Backup Rutin**
   - Selalu backup sebelum menjalankan plugin
   - Simpan versi sebelum dan sesudah

5. **Test di Showfile Kosong**
   - Jika ragu, test dulu di showfile baru/kosong
   - Pahami hasilnya sebelum apply ke showfile production

---

## CONTOH SKENARIO PENGGUNAAN

### Skenario: Setup untuk 4 Group Moving Heads

**Persiapan:**
- Group 1: Movers Stage Left (8 fixtures)
- Group 2: Movers Stage Right (8 fixtures)
- Group 3: Movers Upstage (6 fixtures)
- Group 4: Movers Downstage (6 fixtures)

**Jawaban Input Plugin:**

1. **Pilih Gambar:** `500`
   - Gambar akan disimpan di Image 500-540

2. **Konfirmasi Hapus Preset:** `OK`
   - Preset 4.100-4.112 akan dihapus dan dibuat ulang

3. **Halaman Sequence:** `2`
   - Sequence akan dibuat di Page 2

4. **Executor Awal:** `201`
   - Group 1 → Executor 201
   - Group 2 → Executor 202
   - Group 3 → Executor 203
   - Group 4 → Executor 204

5. **Nomor Macro Awal:** `400`
   - Group 1: Macro 400-411 (12 warna)
   - Group 2: Macro 412-423 (12 warna)
   - Group 3: Macro 424-435 (12 warna)
   - Group 4: Macro 436-447 (12 warna)
   - Group All: Macro 448-459 (12 warna)
   - **Total: 60 macro**

6. **Layout View:** `10`
   - Layout akan dibuat di Layout 10

**Hasil:**
- 60 macro siap pakai
- 4 sequence untuk kontrol per group
- 1 layout view dengan grid warna visual
- 12 preset warna standar

---

## MENGAPA GENERATE BANYAK MACRO?

### Alasan Desain:

**1. Kontrol Granular Per Group**
   - Setiap group perlu kontrol independen
   - Anda bisa mengatur warna berbeda untuk setiap group secara bersamaan
   - Contoh: Group 1 = Red, Group 2 = Blue, Group 3 = Green

**2. 12 Warna Standar**
   - Setiap group mendapat akses ke 12 warna standar
   - Warna sudah di-preset untuk konsistensi
   - Tidak perlu mixing warna manual setiap kali

**3. Group "All" untuk Kontrol Global**
   - Macro tambahan untuk mengontrol semua fixtures sekaligus
   - Berguna untuk efek sinkron
   - Contoh: Semua fixtures = White untuk wash putih

**4. Workflow Cepat**
   - Satu klik = satu warna untuk satu group
   - Tidak perlu select group → pilih warna → apply
   - Sangat cepat untuk programming dan live show

### Alternatif Jika Macro Terlalu Banyak:

Jika Anda merasa macro terlalu banyak:

**Opsi 1: Kurangi Jumlah Group**
- Gabungkan beberapa fixtures dalam satu group
- Contoh: Semua movers kiri-kanan jadi 1 group

**Opsi 2: Gunakan Layout View Saja**
- Sembunyikan Macro Pool
- Gunakan hanya Layout View untuk kontrol
- Lebih visual dan terorganisir

**Opsi 3: Gunakan Sequence**
- Gunakan executor sequence untuk cycle warna
- Tidak perlu buka macro pool

---

## STRUKTUR MACRO YANG DIBUAT

Setiap macro berisi command untuk:
1. Select group tertentu
2. Apply preset warna tertentu
3. Store ke programmer
4. Clear selection

Contoh isi macro untuk "Group 1 - Red":
```
Group 1
At Preset 4.101
Store
ClearAll
```

Ini memastikan warna diterapkan dengan benar dan konsisten.

---

## FAQ (PERTANYAAN UMUM)

**Q: Apakah saya bisa mengubah warna preset setelah plugin selesai?**
A: Ya! Edit Preset 4.100-4.112 sesuai keinginan. Semua macro akan menggunakan preset yang sudah diubah.

**Q: Bagaimana jika saya tambah group baru setelah plugin selesai?**
A: Anda perlu jalankan plugin lagi, atau buat macro manual untuk group baru tersebut.

**Q: Apakah plugin ini menghapus data yang sudah ada?**
A: Ya, plugin akan menghapus Preset 4.100-4.112. Pastikan backup dulu!

**Q: Bisakah saya menggunakan nomor preset yang berbeda?**
A: Tidak, plugin ini hard-coded untuk menggunakan Preset 4.100-4.112. Jika ingin ubah, perlu edit script plugin.

**Q: Apakah macro bisa dihapus setelah dibuat?**
A: Ya, Anda bisa hapus macro yang tidak diperlukan secara manual.

**Q: Bagaimana cara menghapus semua yang dibuat plugin?**
A: 
- Delete Preset 4.100-4.112
- Delete Macro range yang dibuat
- Delete Sequence yang dibuat
- Delete Layout View yang dibuat
- Delete Image yang dibuat
- Atau restore dari backup

---

## KEUNTUNGAN MENGGUNAKAN PLUGIN INI

✅ **Hemat Waktu:** Setup color grid manual bisa memakan waktu berjam-jam
✅ **Konsisten:** Semua warna menggunakan preset yang sama
✅ **Terorganisir:** Macro dan sequence tersusun rapi per group
✅ **Visual:** Layout view memberikan kontrol visual yang mudah
✅ **Fleksibel:** Bisa digunakan untuk berbagai jenis fixtures
✅ **Profesional:** Hasil yang rapi dan standar industri

---

## SUPPORT & INFORMASI

**Versi Plugin:** Color Grid 2.0 EDITION D.R.L
**Platform:** grandma2 v3.9.61
**Bahasa:** Indonesia (diterjemahkan dari Portugis)

**Catatan Versi:**
- Terjemahan ke bahasa Indonesia
- Semua fungsi tetap sama dengan versi original
- Hanya teks user interface yang diubah

---

## CHECKLIST SEBELUM MENJALANKAN

- [ ] Backup showfile sudah dibuat
- [ ] Group fixtures sudah dibuat dan berurutan dari 1
- [ ] Sudah hitung berapa macro yang akan dibuat
- [ ] Sudah siapkan nomor slot untuk:
  - [ ] Image Pool (40+ slot kosong)
  - [ ] Macro Pool (sesuai perhitungan)
  - [ ] Executor (sesuai jumlah group)
  - [ ] Layout View (1 slot kosong)
- [ ] Preset 4.100-4.112 boleh dihapus (atau sudah kosong)
- [ ] Sudah memahami semua input yang akan ditanyakan

**Jika semua checklist sudah ✓, Anda siap menjalankan plugin!**

---

## QUICK REFERENCE

| Input | Contoh | Keterangan |
|-------|--------|------------|
| Nomor Image | 500 | Slot awal untuk ~40 gambar |
| Konfirmasi Preset | OK | Hapus Preset 4.100-4.112 |
| Halaman Sequence | 2 | Page untuk sequence |
| Nomor Executor | 201 | Executor awal (berurutan) |
| Nomor Macro | 400 | Macro awal (banyak!) |
| Layout View | 10 | Slot untuk layout |

**Formula Macro:** (Jumlah Group × 12) + 12 = Total Macro

---

**SELAMAT MENGGUNAKAN COLOR GRID 2.0!** 🎨
