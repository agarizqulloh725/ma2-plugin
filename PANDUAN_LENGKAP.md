# PANDUAN LENGKAP - Auto Insert Effects Plugin untuk GrandMA2

## Daftar Isi
1. [Pengenalan](#pengenalan)
2. [Versi Plugin](#versi-plugin)
3. [Instalasi](#instalasi)
4. [Cara Menggunakan](#cara-menggunakan)
5. [Customisasi](#customisasi)
6. [Tips & Trik](#tips--trik)
7. [Troubleshooting](#troubleshooting)

---

## Pengenalan

Plugin ini dibuat untuk mempermudah proses setup effect di GrandMA2 dengan cara otomatis membuat sample effects yang siap pakai. Sangat berguna untuk:

- **Pemula**: Belajar cara kerja effects di GrandMA2
- **Programmer**: Quick start untuk project baru
- **Training**: Demonstrasi berbagai jenis effects
- **Testing**: Test fixture capabilities dengan berbagai effect patterns

---

## Versi Plugin

### 🟢 Versi BASIC (Recommended untuk pemula)

**Files:**
- `auto_insert_effects.lua`
- `auto_insert_effects.xml`

**Features:**
- 5 sample dimmer effects
- Auto-run saat plugin di-load
- Simple dan mudah dipahami
- Cocok untuk belajar

**Effects yang dibuat:**
```
Effect 1: Dimmer Sine    (60 BPM)  - Gelombang sinus halus
Effect 2: Dimmer Ramp    (80 BPM)  - Ramp naik linear  
Effect 3: Dimmer Saw     (100 BPM) - Gigi gergaji
Effect 4: Dimmer Random  (120 BPM) - Acak
Effect 5: Dimmer Square  (90 BPM)  - Gelombang kotak
```

### 🔵 Versi ADVANCED (Untuk user berpengalaman)

**Files:**
- `auto_insert_effects_advanced.lua`
- `auto_insert_effects_advanced.xml`

**Features:**
- 10 sample effects (8 dimmer + 2 color)
- Manual run (tidak auto-run)
- Advanced parameters (width, phase, blocks)
- Lebih banyak variasi

**Effects yang dibuat:**
```
DIMMER EFFECTS:
Effect 1: Dim Sine Slow   (40 BPM)   - Sine lambat
Effect 2: Dim Sine Fast   (120 BPM)  - Sine cepat
Effect 3: Dim Ramp Up     (60 BPM)   - Ramp naik
Effect 4: Dim Saw         (80 BPM)   - Sawtooth
Effect 5: Dim Random      (100 BPM)  - Random
Effect 6: Dim Square      (90 BPM)   - Square 50%
Effect 7: Dim Pulse       (120 BPM)  - Pulse pendek
Effect 8: Dim Step 4      (60 BPM)   - 4-step

COLOR EFFECTS:
Effect 9: RGB Rainbow     (30 BPM)   - Rainbow color
Effect 10: RGB Strobe     (180 BPM)  - Color strobe
```

---

## Instalasi

### Langkah 1: Copy Files

**Untuk Versi BASIC:**
```
Copy ke: C:/ProgramData/MA Lighting Technologies/grandma/gma2_V_3.9.61/plugins/
- auto_insert_effects.lua
- auto_insert_effects.xml
```

**Untuk Versi ADVANCED:**
```
Copy ke: C:/ProgramData/MA Lighting Technologies/grandma/gma2_V_3.9.61/plugins/
- auto_insert_effects_advanced.lua
- auto_insert_effects_advanced.xml
```

### Langkah 2: Persiapan di GrandMA2

1. Buka GrandMA2 Console
2. Pastikan ada minimal 1 fixture yang sudah di-patch
3. Backup show Anda (File > Save As)

### Langkah 3: Load Plugin

**Versi BASIC (Auto-run):**
```
Plugin "Auto Insert Effects"
```
Plugin akan langsung jalan dan menampilkan dialog konfirmasi.

**Versi ADVANCED (Manual):**
```
Plugin "Auto Insert Effects Advanced"
```
Plugin akan menunggu Anda klik tombol Start.

---

## Cara Menggunakan

### Setelah Plugin Selesai

1. **Buka Effect Pool**
   ```
   Menu > Windows > Effect Pool
   ```

2. **Lihat Effects yang Dibuat**
   - Effect akan muncul dengan nama dan nomor
   - Icon menunjukkan jenis effect (dimmer/color)

### Mengaplikasikan Effect ke Fixtures

#### Method 1: Command Line
```
Fixture 1 Thru 10
Effect 1 At 100
```

#### Method 2: Drag & Drop
1. Select fixtures di Fixture Sheet
2. Drag effect dari Effect Pool ke fixtures
3. Adjust intensity dengan fader

#### Method 3: Store ke Cue
```
Fixture 1 Thru 10
Effect 1 At 100
Store Cue 1
```

#### Method 4: Assign ke Executor
```
Assign Effect 1 At Executor 1.1
```

### Mengatur Effect Speed

```
Effect 1 At 100
EffectRate 200    (2x lebih cepat)
EffectRate 50     (2x lebih lambat)
```

### Mengatur Effect Width

```
Effect 1 At 100
EffectWidth 50    (50% width)
EffectWidth 200   (200% width)
```

---

## Customisasi

### Mengubah Effects yang Dibuat

Edit file `.lua` pada bagian `effects_config`:

```lua
local effects_config = {
    {
        number = 1,              -- Nomor effect (1-999)
        name = "My Effect",      -- Nama effect (max 32 char)
        preset_type = "Dimmer",  -- Dimmer, Color, Position, dll
        form = "Sine",           -- Sine, Ramp, Saw, Random, dll
        bpm = 60,                -- Speed (1-1000 BPM)
        width = 100,             -- Width (0-200%)
        phase = 0,               -- Phase offset (0-360)
        blocks = 1,              -- Blocks untuk Step form
        description = "..."      -- Deskripsi
    },
    -- Tambah effect lain...
};
```

### Form yang Tersedia

| Form | Deskripsi | Cocok untuk |
|------|-----------|-------------|
| Sine | Gelombang sinus halus | Dimmer smooth |
| Ramp | Naik linear | Fade in effect |
| Saw | Gigi gergaji | Strobe effect |
| Square | Gelombang kotak | On/off effect |
| Random | Acak | Flicker effect |
| Pulse | Pulsa pendek | Flash effect |
| Step | Bertahap | Chase effect |

### Preset Types yang Tersedia

- **Dimmer**: Intensity effects
- **Color**: RGB/CMY color effects
- **Position**: Pan/Tilt effects
- **Gobo**: Gobo rotation effects
- **Focus**: Focus/Zoom effects
- **Beam**: Iris/Prism effects

### Contoh Custom Effect

```lua
{
    number = 11,
    name = "Custom Strobe",
    preset_type = "Dimmer",
    form = "Square",
    bpm = 240,           -- Sangat cepat
    width = 10,          -- Pulse sangat pendek
    phase = 0,
    description = "Fast strobe effect"
}
```

---

## Tips & Trik

### 💡 Tip 1: Kombinasi Multiple Effects

```
Fixture 1 Thru 10
Effect 1 At 100        (Dimmer sine)
Effect 9 At 100        (Color rainbow)
Store Cue 1
```

### 💡 Tip 2: Effect dengan Fade Time

```
Fixture 1 Thru 10
Effect 1 At 100 Fade 3
```

### 💡 Tip 3: Effect dengan Delay

```
Fixture 1 Thru 10
Effect 1 At 100 Delay 2
```

### 💡 Tip 4: Effect Offset antar Fixtures

```
Fixture 1 Thru 10
Effect 1 At 100
EffectPhase 0 Thru 360
```

### 💡 Tip 5: Pause/Resume Effect

```
Pause Effect 1
Toggle Effect 1
```

### 💡 Tip 6: Effect dengan Wings

```
Assign Effect 1 /wings = "spread"
```

### 💡 Tip 7: Copy Effect Settings

```
Copy Effect 1 At Effect 11
```

---

## Troubleshooting

### ❌ Plugin tidak muncul

**Problem**: Plugin tidak terlihat di list
**Solution**:
1. Check file ada di folder yang benar
2. Restart GrandMA2
3. Check nama file exact match dengan XML
4. Check XML syntax tidak error

### ❌ Plugin error saat load

**Problem**: Error message di System Monitor
**Solution**:
1. Buka System Monitor (Menu > Windows > System Monitor)
2. Baca error message
3. Check syntax Lua di file .lua
4. Pastikan semua function ada return value

### ❌ Effects tidak muncul di pool

**Problem**: Plugin jalan tapi effect tidak ada
**Solution**:
1. Refresh Effect Pool (F5)
2. Check System Monitor untuk error
3. Manual test: `Store Effect 1`
4. Check apakah fixtures sudah di-patch

### ❌ Effects tidak bekerja pada fixtures

**Problem**: Effect ada tapi tidak terlihat di fixtures
**Solution**:
1. Check fixtures support preset type yang digunakan
2. Check DMX output aktif
3. Test manual: `Fixture 1 At 100`
4. Check programmer values

### ❌ Color effects tidak bekerja

**Problem**: Color effects (9-10) tidak terlihat
**Solution**:
1. Check fixtures support RGB/CMY
2. Check fixture profile correct
3. Test manual color: `Fixture 1 At Color "Red"`
4. Gunakan dimmer effects saja jika fixtures tidak support color

### ❌ Plugin terlalu lambat

**Problem**: Plugin butuh waktu lama untuk create effects
**Solution**:
1. Normal, karena ada delay untuk save
2. Kurangi jumlah effects di config
3. Kurangi sleep time (tapi bisa cause error)

---

## Command Reference

### Effect Commands

```
Store Effect [number]              - Simpan effect
Delete Effect [number]             - Hapus effect
Copy Effect [n] At Effect [n]      - Copy effect
Label Effect [n] "name"            - Beri nama effect
Assign Effect [n] /param=value     - Set parameter

Effect [n] At [value]              - Apply effect
Effect [n] Off                     - Matikan effect
Effect [n] On                      - Nyalakan effect
Pause Effect [n]                   - Pause effect
Toggle Effect [n]                  - Toggle effect

EffectRate [value]                 - Set speed
EffectWidth [value]                - Set width
EffectPhase [value]                - Set phase
```

### Plugin Commands

```
Plugin "name"                      - Load plugin
Plugin "name" /unload              - Unload plugin
List Plugin                        - List semua plugins
```

---

## Keyboard Shortcuts

| Shortcut | Function |
|----------|----------|
| F5 | Refresh windows |
| Ctrl+Z | Undo |
| Ctrl+Y | Redo |
| Esc | Clear selection |
| . (dot) | Thru |
| + | Plus |
| - | Minus |

---

## Best Practices

### ✅ DO:
- Backup show sebelum install plugin
- Test di show kosong dulu
- Baca System Monitor untuk errors
- Customize config sesuai kebutuhan
- Gunakan naming convention yang jelas

### ❌ DON'T:
- Install plugin di show production tanpa test
- Overwrite effects yang sudah digunakan
- Ignore error messages
- Run multiple plugins bersamaan
- Lupa save show setelah create effects

---

## FAQ

**Q: Apakah plugin ini aman?**
A: Ya, plugin hanya create effects dan tidak mengubah patch atau DMX output.

**Q: Bisa create lebih dari 10 effects?**
A: Ya, edit `effects_config` dan tambah entry baru.

**Q: Bisa create position effects?**
A: Ya, ubah `preset_type` menjadi "Position" dan gunakan form seperti "Circle".

**Q: Effect hilang setelah restart?**
A: Save show setelah create effects (File > Save).

**Q: Bisa auto-run setiap kali buka show?**
A: Tidak recommended, tapi bisa set `execute_on_load="1"` di XML.

**Q: Bisa create effect untuk fixture tertentu saja?**
A: Ya, edit bagian `gma.cmd("Fixture Thru")` menjadi `gma.cmd("Fixture 1 Thru 10")`.

---

## Resources

### GrandMA2 Documentation
- Manual: Help > Manual di console
- Command Reference: Help > Command Reference
- Lua API: Help > Lua Functions

### Online Resources
- MA Lighting Forum: https://forum.malighting.com
- MA Lighting Website: https://www.malighting.com
- YouTube Tutorials: Search "GrandMA2 Effects Tutorial"

---

## Version History

### v1.0 (2024)
- Initial release
- Basic version dengan 5 effects
- Advanced version dengan 10 effects
- Full documentation dalam bahasa Indonesia

---

## Credits

**Developer**: BLACKBOXAI
**Platform**: GrandMA2 v3.9.61+
**Language**: Lua
**License**: Educational/Demo purposes

---

## Support

Untuk pertanyaan atau issue:
1. Check dokumentasi ini terlebih dahulu
2. Check System Monitor untuk error messages
3. Test dengan show kosong
4. Baca GrandMA2 manual untuk command reference

---

**Selamat menggunakan Auto Insert Effects Plugin! 🎭✨**

Semoga plugin ini membantu workflow Anda di GrandMA2!
