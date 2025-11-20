# Auto Insert Effects Plugin untuk GrandMA2

Plugin yang otomatis membuat 23 sample effects dengan SEMUA form yang tersedia di GrandMA2.

## ✅ Version 3.0 - Dynamic Placement Edition

**NEW:** Dynamic slot detection - tidak overwrite effect yang sudah ada!
**NEW:** User input untuk start number
**FIXED:** Pure Dimmer effects - tidak ada Pan/Tilt
**IMPROVED:** Smart placement di slot kosong

### Apa yang baru di v3.0:
- ✅ Input start number dari user
- ✅ Automatic empty slot detection
- ✅ Tidak overwrite effect yang sudah ada
- ✅ Pure Dimmer effects (semua 23 effects)
- ✅ Menampilkan slot yang digunakan
- ✅ Smart error handling

### Fitur dari versi sebelumnya:
- ✅ 23 effects dengan semua form yang tersedia
- ✅ Command sequence yang benar (Presettype → At Form)
- ✅ Error handling yang lebih baik
- ✅ Sleep delays untuk stabilitas

## 📦 Isi Folder

### Plugin Files:
- `auto_insert_effects.lua` - Main plugin (23 effects, all forms)
- `auto_insert_effects.xml` - Metadata (auto-run saat di-load)

### Documentation:
- `README.md` - File ini
- `INSTALASI.txt` - Panduan instalasi cepat

## 🚀 Quick Install

### Langkah 1: Copy Files

Copy file plugin ke folder plugins GrandMA2:

```
Copy ke: C:/ProgramData/MA Lighting Technologies/grandma/gma2_V_3.9.61/plugins/
- auto_insert_effects.lua
- auto_insert_effects.xml
```

### Langkah 2: Load Plugin

Di GrandMA2 console:

```
Plugin "Auto Insert Effects"
```

Plugin akan otomatis jalan dan membuat 23 effects.

## ✨ Features - 23 Effect Forms

Semua form yang tersedia di GrandMA2 "Select Form" dialog:

```
BASIC FORMS (1-6):
Effect 1:  Stomp       (60 BPM)
Effect 2:  Release     (60 BPM)
Effect 3:  Random      (80 BPM)
Effect 4:  Pwm         (90 BPM)
Effect 5:  Chase       (100 BPM)
Effect 6:  Flat Low    (60 BPM)

ADVANCED FORMS (7-12):
Effect 7:  Flat High   (60 BPM)
Effect 8:  Sin         (60 BPM)
Effect 9:  Cos         (60 BPM)
Effect 10: Ramp Plus   (70 BPM)
Effect 11: Ramp Minus  (70 BPM)
Effect 12: Ramp        (70 BPM)

PHASE FORMS (13-18):
Effect 13: Phase 1     (60 BPM)
Effect 14: Phase 2     (60 BPM)
Effect 15: Phase 3     (60 BPM)
Effect 16: Bump        (80 BPM)
Effect 17: Swing       (50 BPM)
Effect 18: Ramp 50     (70 BPM)

SPECIAL FORMS (19-23):
Effect 19: Circle      (40 BPM)
Effect 20: Sound       (120 BPM)
Effect 21: Flyout      (60 BPM)
Effect 22: Wave        (50 BPM)
Effect 23: Cross       (60 BPM)
```

## 🔧 Technical Details

### Bug Fix Implementation:

**Correct Command Sequence:**
```lua
gma.cmd("ClearAll");
gma.sleep(0.1);
gma.cmd("Fixture Thru");
gma.sleep(0.1);
gma.cmd("Presettype \"Dimmer\"");  -- Select attribute FIRST
gma.sleep(0.1);
gma.cmd("At Form \"Sin\"");         -- Now works!
gma.sleep(0.1);
gma.cmd("At EffectBPM 60");
gma.sleep(0.1);
gma.cmd("Store Effect 1 /nc");
```

### Why it works:
1. `ClearAll` clears programmer
2. `Fixture Thru` selects all fixtures
3. `Presettype "Dimmer"` creates attribute selection
4. `At Form` can now modify the selected attribute
5. Sleep delays ensure commands execute properly
6. No more "OBJECT DOES NOT EXIST" error!

## ⚠️ Requirements

- GrandMA2 v3.9.61 or higher
- At least 1 fixture patched in show
- Fixtures should support Dimmer attribute

## 💡 Quick Usage

### Cara Menggunakan Plugin:

1. **Load Plugin:**
   ```
   Plugin "Auto Insert Effects"
   ```

2. **Input Start Number:**
   - Dialog akan muncul meminta start number
   - Contoh: ketik `10` untuk mulai dari Effect 10
   - Tekan Enter atau kosongkan untuk default (Effect 1)

3. **Konfirmasi:**
   - Plugin akan menampilkan konfirmasi
   - Klik "Yes" untuk melanjutkan

4. **Hasil:**
   - Plugin akan mencari slot kosong secara otomatis
   - Effects akan ditempatkan di slot yang tersedia
   - Tidak akan overwrite effect yang sudah ada

### Contoh Skenario:

**Skenario 1: Effect Pool Kosong**
- Input start number: `1`
- Hasil: Effects dibuat di slot 1-23

**Skenario 2: Sudah Ada Effect 1-10**
- Input start number: `1`
- Hasil: Plugin skip slot 1-10, buat di slot 11-33

**Skenario 3: Mulai dari Nomor Tertentu**
- Input start number: `100`
- Hasil: Effects dibuat di slot 100-122

### Menggunakan Effects:

```
# Apply effect to fixtures
Fixture 1 Thru 10
Effect 1 At 100

# Store to cue
Fixture 1 Thru 10
Effect 8 At 100
Store Cue 1

# Adjust speed
EffectRate 200  (faster)
EffectRate 50   (slower)

# Try different effects
Effect 19 At 100  (Circle)
Effect 22 At 100  (Wave)
```

## 🆘 Troubleshooting

### Plugin tidak jalan?
- Check files ada di folder plugins yang benar
- Check System Monitor untuk error messages
- Pastikan ada fixtures yang sudah di-patch

### Effects tidak muncul?
- Refresh Effect Pool (F5)
- Check System Monitor
- Manual test: `Fixture 1; Presettype "Dimmer"; At Form "Sin"; Store Effect 1`

### Masih ada error "OBJECT DOES NOT EXIST"?
- Pastikan menggunakan version 2.0 (yang sudah di-fix)
- Check apakah fixtures sudah di-patch
- Pastikan ada delay antara commands

### Beberapa effects gagal dibuat?
- Normal, beberapa form mungkin tidak compatible dengan semua fixtures
- Check System Monitor untuk detail error
- Effects yang berhasil tetap tersimpan

## 📝 Version History

### v3.0 (2024) - Current - Dynamic Placement Edition
- ✅ User input untuk start number
- ✅ Dynamic empty slot detection
- ✅ Tidak overwrite effect yang sudah ada
- ✅ Pure Dimmer effects (fix Pan/Tilt issue)
- ✅ Menampilkan slot yang digunakan
- ✅ Smart placement algorithm

### v2.0 (2024) - All Forms Edition
- ✅ 23 effects dengan semua available forms
- ✅ Removed color effects
- ✅ Improved error handling
- ✅ Added sleep delays for stability
- ✅ Better command sequence

### v1.1 (2024)
- ✅ FIXED: "OBJECT DOES NOT EXIST" error
- ✅ Improved command sequence
- ✅ 10 effects (8 dimmer + 2 color)

### v1.0 (2024)
- Initial release
- Basic and Advanced versions

## 👤 Credits

**Developer**: BLACKBOXAI  
**Platform**: GrandMA2 v3.9.61+  
**Language**: Lua  
**License**: Educational/Demo purposes

## 📞 Support

Untuk pertanyaan atau issue:
1. Baca dokumentasi lengkap
2. Check System Monitor untuk error messages
3. Test dengan show kosong
4. Baca GrandMA2 manual

---

**Selamat menggunakan! 🎭✨**

Plugin ini sudah di-update dengan semua 23 effect forms yang tersedia di GrandMA2.
