# PENJELASAN PLUGIN GRANDMA2

## Dokumentasi Plugin Delay Sweeps dan Fadetime Macros

---

## 1. DELAY SWEEPS v1.8.1

### **Fungsi Utama:**
Plugin Delay Sweeps adalah tool untuk membuat efek delay/timing yang tersinkronisasi pada fixture lighting yang disusun dalam baris (rows). Plugin ini menghasilkan preset delay otomatis dengan berbagai pola pergerakan.

### **Kegunaan:**
- **Membuat efek sweep/wave** pada lampu yang bergerak dari satu sisi ke sisi lain
- **Menghasilkan pola delay otomatis** untuk berbagai arah (horizontal, vertical, center-out, dll)
- **Mempercepat workflow** programming dengan preset delay yang sudah jadi
- **Konsistensi timing** pada seluruh rig lighting

### **Cara Kerja:**

#### A. **Instalasi Awal:**
1. Plugin meminta user untuk input **Group numbers** untuk setiap baris fixture (dari Downstage ke Upstage)
2. User mengatur konfigurasi di bagian User Config:
   ```lua
   delaytime_list = {0, 0.25, 0.5, 1, 2, 4}  -- Waktu delay dalam detik
   chaserWings = false                        -- Mode wings (bidirectional)
   target_range = {                           -- Target sequences/executors
       [[Executor *."*_col" Cue *]],
       [[Sequence "*COLORS*" Cue *]],
   }
   presetTypes = {0}                          -- Tipe preset (0=semua, 1=dimmer, 2=position, dll)
   ```

#### B. **Output yang Dihasilkan:**

**1. Delay Presets (9 pola per waktu):**
   - `>>` - Left to Right (kiri ke kanan)
   - `<<` - Right to Left (kanan ke kiri)
   - `<<>>` - Center Out (dari tengah keluar)
   - `>><<` - Outside In (dari luar ke tengah)
   - `Up` - Bottom to Top (bawah ke atas)
   - `Down` - Top to Bottom (atas ke bawah)
   - `V. Out` - Vertical Center Out (vertikal dari tengah)
   - `V. In` - Vertical Outside In (vertikal dari luar)
   - `RND` - Random/Shuffled (acak)

**2. Macros:**
   - **Timing Macros** - Untuk memilih durasi sweep (0s, 0.25s, 0.5s, 1s, 2s, 4s)
   - **Direction Macros** - Untuk memilih arah sweep (>>, <<, Up, Down, dll)
   - **System Macros:**
     - `LOCK` - Mengunci semua macro dan preset
     - `UNLOCK` - Membuka kunci untuk editing
     - `UNINSTALL` - Menghapus seluruh sistem yang terinstall

**3. Plugins:**
   - **Execute Plugin** - Menjalankan delay sweep ke target sequences
   - **Update Plugin** - Untuk update preset jika ada perubahan fixture/group

#### C. **Workflow Penggunaan:**
1. Pilih waktu delay dengan macro timing (misal: "Sweep 2s")
2. Pilih arah dengan macro direction (misal: ">>")
3. Plugin otomatis apply delay preset ke semua target sequences
4. Delay akan tersimpan di cue-cue yang ditargetkan

### **Contoh Penggunaan:**
```
Scenario: Anda punya 5 baris lampu moving head
- Baris 1 (DS): Group 1
- Baris 2: Group 2
- Baris 3: Group 3
- Baris 4: Group 4
- Baris 5 (US): Group 5

Hasil: Plugin membuat preset yang membuat lampu "menyapu" 
dari DS ke US dengan timing yang smooth (misal 2 detik total)
```

---

## 2. FADETIME MACROS v2.1

### **Fungsi Utama:**
Plugin Fadetime Macros adalah tool untuk mengatur fade time (waktu transisi) pada range sequences secara cepat dan mudah melalui macro buttons.

### **Kegunaan:**
- **Mengubah fade time** pada multiple sequences sekaligus
- **Switching cepat** antara berbagai fade time preset
- **Konsistensi timing** pada programming
- **Workflow lebih cepat** dibanding manual assign fade time

### **Cara Kerja:**

#### A. **Instalasi:**
Plugin meminta input:
1. **Sequence Type** - Nama/kategori sequences (misal: "color", "position", "beam")
2. **Starting Macro** - Nomor macro pertama untuk disimpan
3. **Sequence Range** - Range sequences yang akan diatur (misal: Seq 1-30)
4. **Fade Times** - List waktu fade yang diinginkan (misal: 0, 1, 2, 3, 5 detik)

#### B. **Output yang Dihasilkan:**

**1. Set Variable Macro:**
   - Menyimpan range sequences dan macro range ke system variables
   - Variable: `$[type]Execs` dan `$[type]FdMacros`

**2. Fade Time Macros:**
   - Satu macro untuk setiap fade time yang diinput
   - Label: "Fade 0s", "Fade 1s", "Fade 2s", dll
   - Fungsi: Set fade time untuk semua cue di sequences yang ditarget

**3. System Macros:**
   - `DISABLE Uninstall` - Mengunci uninstall macro
   - `ENABLE Uninstall` - Membuka kunci uninstall
   - `UNINSTALL FadeTimes` - Menghapus semua macro yang dibuat

#### C. **Cara Kerja Teknis:**
```lua
-- Setiap macro fade time melakukan:
1. Off semua macro fade time lainnya (visual feedback)
2. Assign fade time ke semua cue di range sequences
3. Set macro sendiri ke status "Top" (aktif)
```

#### D. **Workflow Penggunaan:**
1. Tekan macro "Fade 2s" → Semua cue di sequences target akan punya fade 2 detik
2. Tekan macro "Fade 5s" → Fade time berubah jadi 5 detik
3. Bisa switch kapan saja selama programming

### **Contoh Penggunaan:**
```
Scenario: Anda punya color sequences di Seq 1-20
- Install plugin dengan fade times: 0, 1, 2, 3, 5 detik
- Saat programming:
  * Tekan "Fade 0s" untuk snap changes
  * Tekan "Fade 3s" untuk smooth transitions
  * Tekan "Fade 5s" untuk slow fades
```

---

## PERBANDINGAN KEDUA PLUGIN

| Aspek | Delay Sweeps | Fadetime Macros |
|-------|--------------|-----------------|
| **Fungsi** | Mengatur DELAY timing (kapan fixture mulai) | Mengatur FADE timing (berapa lama transisi) |
| **Target** | Delay values dalam presets | Fade time dalam cues |
| **Kompleksitas** | Lebih kompleks (9 pola arah) | Lebih sederhana (hanya set nilai) |
| **Use Case** | Efek wave/sweep/chase | Smooth transitions |
| **Output** | Presets + Macros + Plugins | Macros only |

---

## TIPS PENGGUNAAN

### Delay Sweeps:
1. **Buat groups yang rapi** - Pastikan fixture dalam group sudah terurut dengan benar
2. **Test dengan waktu kecil dulu** - Mulai dengan 0.25s atau 0.5s untuk test
3. **Gunakan chaserWings** untuk efek bidirectional yang lebih smooth
4. **Lock setelah selesai** untuk menghindari perubahan tidak sengaja

### Fadetime Macros:
1. **Buat kategori berbeda** - Install terpisah untuk color, position, beam, dll
2. **Gunakan range yang logis** - Group sequences berdasarkan fungsi
3. **Sediakan variasi waktu** - Dari snap (0s) hingga slow (5s+)
4. **Update saat menambah sequences** - Jalankan ulang installer jika range berubah

---

## TROUBLESHOOTING

### Delay Sweeps:
- **Preset tidak apply**: Cek target_range di user config
- **Arah terbalik**: Cek urutan groups (harus DS ke US)
- **Timing tidak smooth**: Adjust delaytime_list values

### Fadetime Macros:
- **Macro tidak bekerja**: Cek sequence range masih valid
- **Fade tidak apply**: Pastikan cues ada di sequences
- **Conflict dengan macro lain**: Gunakan starting macro number yang berbeda

---

## KESIMPULAN

**Delay Sweeps** dan **Fadetime Macros** adalah tools yang sangat powerful untuk mempercepat workflow programming di grandma2. 

- **Delay Sweeps** = Untuk membuat efek movement/timing yang dinamis
- **Fadetime Macros** = Untuk kontrol cepat fade time saat programming

Kedua plugin ini dibuat oleh Jason Giaffo (Giaffo Designs) dan merupakan commercial plugins yang memerlukan lisensi untuk penggunaan.

---

**Catatan:** Plugin ini menggunakan Lua scripting dan grandma2 API untuk automasi. Pastikan backup showfile sebelum menginstall plugin baru.
