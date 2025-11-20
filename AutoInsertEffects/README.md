# Auto Insert Effects Plugin untuk GrandMA2

Plugin yang otomatis membuat macros untuk 23 effect forms. Effects dibuat on-demand saat macro di-click dengan AT status!

## ✅ Version 4.0 - Smart Macros Edition

**NEW:** Macros dibuat saat plugin load, effects dibuat on-demand!
**NEW:** One-click operation - macro auto-create effect dan apply dengan AT status!
**IMPROVED:** Efisien - effects hanya dibuat saat dibutuhkan!

### Apa yang baru di v4.0:
- ✅ **Smart Macros** - Macros dibuat saat plugin load
- ✅ **On-Demand Effects** - Effects dibuat otomatis saat macro di-click
- ✅ **AT Status** - Effects langsung applied dengan "Effect X At 100"
- ✅ **No Input Required** - Tidak ada dialog input saat import
- ✅ **Efficient** - Tidak ada wasted effect slots
- ✅ **One-Click** - Satu klik macro = create + apply effect

### Cara Kerja:
1. **Saat Load Plugin**: 23 macros dibuat otomatis (Macro 1-23)
2. **Saat Click Macro**: 
   - Check apakah effect sudah ada
   - Jika belum ada, auto-create effect di slot kosong
   - Apply effect dengan AT 100 status
3. **Result**: Effect langsung active di output!

## 📦 Isi Folder

### Plugin Files:
- `auto_insert_effects.lua` - Main plugin (smart macros)
- `auto_insert_effects.xml` - Metadata (auto-run saat di-load)

### Documentation:
- `README.md` - File ini
- `INSTALASI.txt` - Panduan instalasi cepat
- `CHANGELOG.md` - Detail perubahan
- `TODO.md` - Implementation tracking

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

Plugin akan otomatis:
1. Membuat 23 macros di Macro Pool (Macro 1-23)
2. Selesai! Tidak ada input/dialog lain

### Langkah 3: Gunakan Macros

```
1. Buka Macro Pool
2. Click macro button (contoh: Macro 1 untuk Stomp)
3. Effect auto-created dan applied dengan AT 100!
```

## ✨ Features - 23 Effect Forms

Semua form yang tersedia di GrandMA2:

```
BASIC FORMS (Macro 1-6):
Macro 1:  Stomp       (60 BPM)
Macro 2:  Release     (60 BPM)
Macro 3:  Random      (80 BPM)
Macro 4:  Pwm         (90 BPM)
Macro 5:  Chase       (100 BPM)
Macro 6:  Flat Low    (60 BPM)

ADVANCED FORMS (Macro 7-12):
Macro 7:  Flat High   (60 BPM)
Macro 8:  Sin         (60 BPM)
Macro 9:  Cos         (60 BPM)
Macro 10: Ramp Plus   (70 BPM)
Macro 11: Ramp Minus  (70 BPM)
Macro 12: Ramp        (70 BPM)

PHASE FORMS (Macro 13-18):
Macro 13: Phase 1     (60 BPM)
Macro 14: Phase 2     (60 BPM)
Macro 15: Phase 3     (60 BPM)
Macro 16: Bump        (80 BPM)
Macro 17: Swing       (50 BPM)
Macro 18: Ramp 50     (70 BPM)

SPECIAL FORMS (Macro 19-23):
Macro 19: Circle      (40 BPM)
Macro 20: Sound       (120 BPM)
Macro 21: Flyout      (60 BPM)
Macro 22: Wave        (50 BPM)
Macro 23: Cross       (60 BPM)
```

## 💡 Usage - Super Simple!

### Cara Menggunakan:

1. **Load Plugin (Sekali Saja):**
   ```
   Plugin "Auto Insert Effects"
   ```
   - 23 macros dibuat di Macro Pool
   - Macro 1-23 dengan label sesuai effect name

2. **Gunakan Macro (Kapan Saja):**
   ```
   - Buka Macro Pool
   - Click Macro 1 → Stomp effect created & applied
   - Click Macro 8 → Sin effect created & applied
   - Click Macro 19 → Circle effect created & applied
   ```

3. **Itu Saja!**
   - Tidak perlu create effect manual
   - Tidak perlu apply effect manual
   - Satu klik = semuanya otomatis!

### 🎯 Contoh Workflow:

**Scenario 1: First Time Use**
```
1. Load plugin → 23 macros created
2. Click Macro 1 (Stomp)
   → Effect 1 created with Stomp form
   → Effect 1 applied At 100 to all fixtures
   → Done!
```

**Scenario 2: Effect Already Exists**
```
1. Click Macro 1 (Stomp) again
   → Plugin detects Effect 1 already exists
   → Directly applies Effect 1 At 100
   → No duplicate creation!
```

**Scenario 3: Multiple Effects**
```
1. Click Macro 1 → Stomp effect (Effect 1)
2. Click Macro 8 → Sin effect (Effect 2)
3. Click Macro 19 → Circle effect (Effect 3)
   → Each effect created in next empty slot
   → All applied with AT 100 status
```

### 🔥 Keuntungan Smart Macros:

**1. Efisien:**
- Effects hanya dibuat saat dibutuhkan
- Tidak ada wasted effect slots
- Effect Pool tetap bersih

**2. Cepat:**
- One-click operation
- Tidak perlu manual create effect
- Tidak perlu manual apply effect

**3. AT Status:**
- Effect langsung active di output
- Tidak perlu store ke programmer
- Tidak perlu store ke cue

**4. Smart:**
- Auto-detect jika effect sudah ada
- Tidak create duplicate
- Reuse existing effects

**5. Simple:**
- Tidak ada input dialog
- Tidak ada konfirmasi berulang
- Just click and go!

## 🔧 Technical Details

### Smart Macro Logic:

Setiap macro berisi Lua script yang:

```lua
1. Search effect by name in Effect Pool
2. If found:
   - Use existing effect number
3. If not found:
   - Find next empty effect slot
   - Create effect with correct form & BPM
   - Label effect with name
4. Apply effect with AT 100 status
5. Done!
```

### Command Sequence (Auto-executed):

```lua
-- Check if effect exists
for i=1,999 do
  if Effect[i].label == "Stomp" then
    effect_num = i
    break
  end
end

-- Create if not exists
if not effect_num then
  ClearAll
  Fixture Thru
  Presettype "Dimmer"
  At Form "Stomp"
  At EffectBPM 60
  Store Effect [next_empty_slot]
  Label Effect [slot] "Stomp"
end

-- Apply with AT status
ClearAll
Fixture Thru
Effect [effect_num] At 100
```

## ⚠️ Requirements

- GrandMA2 v3.9.61 or higher
- At least 1 fixture patched in show
- Fixtures should support Dimmer attribute

## 🆘 Troubleshooting

### Plugin tidak jalan?
- Check files ada di folder plugins yang benar
- Check System Monitor untuk error messages
- Pastikan ada fixtures yang sudah di-patch

### Macros tidak muncul?
- Refresh Macro Pool (F5)
- Check System Monitor
- Re-load plugin: `Plugin "Auto Insert Effects"`

### Macro tidak create effect?
- Pastikan ada fixtures di-patch
- Check System Monitor untuk error
- Manual test: Click macro dan lihat output

### Effect tidak applied?
- Check apakah fixtures selected
- Verify effect created di Effect Pool
- Check DMX output

## 📝 Version History

### v4.0 (2024) - Current - Smart Macros Edition
- ✅ **Smart Macros** - Macros created on plugin load
- ✅ **On-Demand Effects** - Effects created when macro clicked
- ✅ **AT Status** - Effects applied with "Effect X At 100"
- ✅ **No Input** - No dialogs or user input required
- ✅ **Efficient** - Effects only created when needed
- ✅ **One-Click** - Single click creates and applies effect
- ✅ **Smart Detection** - Reuses existing effects

### v3.0 (2024) - Dynamic Placement Edition
- User input untuk start number
- Dynamic empty slot detection
- Tidak overwrite effect yang sudah ada

### v2.0 (2024) - All Forms Edition
- 23 effects dengan semua available forms
- Improved error handling

### v1.0 (2024)
- Initial release

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

Plugin v4.0 dengan Smart Macros - Create effects on-demand dengan AT status!
