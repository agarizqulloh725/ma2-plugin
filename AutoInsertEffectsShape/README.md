# Auto Insert Effects Shape Plugin untuk GrandMA2

Plugin yang otomatis membuat **1 MASTER MACRO** untuk generate **12 Pan/Tilt shape effects** sekaligus dengan konfigurasi predefined!

## ✅ Version 1.0 - Master Macro Edition

**FITUR UTAMA:**
- ✅ **1 Master Macro** - Satu macro untuk generate semua effects
- ✅ **12 Shape Effects** - PT Circle, Pan Only, Tilt Only
- ✅ **One-Click Generation** - Semua effects dibuat sekaligus
- ✅ **Predefined Shapes** - Konfigurasi siap pakai untuk moving lights
- ✅ **Symmetric & Non-Symmetric** - Pilihan gerakan simetris dan non-simetris

### Apa yang baru:
- ✅ **Master Macro System** - 1 macro untuk generate semua 12 effects
- ✅ **PT Circle Effects** - 4 variasi circle dengan Pan+Tilt kombinasi
- ✅ **Pan Only Effects** - 4 variasi gerakan Pan saja (symmetric & non-symmetric)
- ✅ **Tilt Only Effects** - 4 variasi gerakan Tilt saja (symmetric & non-symmetric)
- ✅ **Custom Phase** - Phase ranges disesuaikan untuk setiap effect
- ✅ **Custom Wing** - Wing values untuk kontrol spread effect
- ✅ **Optimized BPM** - BPM disesuaikan untuk setiap jenis gerakan

## 📦 Isi Folder

### Plugin Files:
- `auto_insert_effects_shape.lua` - Main plugin (smart macros)
- `auto_insert_effects_shape.xml` - Metadata (auto-run saat di-load)

### Documentation:
- `README.md` - File ini (dokumentasi lengkap)
- `INSTALASI.txt` - Panduan instalasi cepat
- `TODO.md` - Implementation tracking

## 🚀 Quick Install

### Langkah 1: Copy Files

Copy file plugin ke folder plugins GrandMA2:

```
Copy ke: C:/ProgramData/MA Lighting Technologies/grandma/gma2_V_3.9.61/plugins/AutoInsertEffectsShape/
- auto_insert_effects_shape.lua
- auto_insert_effects_shape.xml
```

### Langkah 2: Load Plugin

Di GrandMA2 console:

```
Plugin "Auto Insert Effects Shape"
```

Plugin akan otomatis:
1. Membuat 1 MASTER MACRO di Macro Pool (Macro 1)
2. Macro berlabel "Generate All Shape FX"
3. Selesai! Tidak ada input/dialog lain

### Langkah 3: Generate Semua Effects

```
1. Buka Macro Pool
2. Click Macro 1 ("Generate All Shape FX")
3. SEMUA 12 effects auto-created sekaligus di Effect Pool!
4. Check Effect Pool untuk melihat semua effects
```

## ✨ Features - 12 Shape Effects

### 🔵 PT CIRCLE EFFECTS (Macro 1-4)
Kombinasi Pan + Tilt untuk membuat gerakan circle

```
Macro 1: fx Circle 1
- Type: PT Circle (Pan Sin 8 + Tilt Cos 9)
- Phase: 0 Thru 90
- Wing: (-2,2)
- BPM: 40
- Hasil: Circle kecil, smooth

Macro 2: fx Circle 2
- Type: PT Circle (Pan Sin 8 + Tilt Cos 9)
- Phase: 0 Thru 90
- Wing: (-4,4)
- BPM: 40
- Hasil: Circle besar, wide spread

Macro 3: fx Circle 3
- Type: PT Circle (Pan Sin 8 + Tilt Cos 9)
- Phase: 0 Thru 360
- Wing: (-2,2)
- BPM: 40
- Hasil: Full circle rotation

Macro 4: fx Circle 4
- Type: PT Circle (Pan Sin 8 + Tilt Cos 9)
- Phase: 90 (static)
- Wing: (-2,2)
- BPM: 40
- Hasil: Circle dengan offset 90 derajat
```

### ↔️ PAN ONLY EFFECTS (Macro 5-8)
Gerakan Pan saja (horizontal)

```
Macro 5: fx Pan Sym 1 (SYMMETRIC)
- Attribute: Pan only
- Form: Sin 8
- Phase: 0 Thru 90
- Wing: (-2,2)
- BPM: 60
- Hasil: Pan sweep simetris, range kecil

Macro 6: fx Pan Sym 2 (SYMMETRIC)
- Attribute: Pan only
- Form: Sin 8
- Phase: 0 Thru 180
- Wing: (-3,3)
- BPM: 60
- Hasil: Pan sweep simetris, range medium

Macro 7: fx Pan NonSym 1 (NON-SYMMETRIC)
- Attribute: Pan only
- Form: Sin 8
- Phase: 0 Thru 360
- Wing: (-2,2)
- BPM: 60
- Hasil: Pan sweep non-simetris, full rotation

Macro 8: fx Pan NonSym 2 (NON-SYMMETRIC)
- Attribute: Pan only
- Form: Ramp Plus 10
- Phase: 0 Thru 180
- Wing: (-4,4)
- BPM: 70
- Hasil: Pan ramp non-simetris, wide spread
```

### ↕️ TILT ONLY EFFECTS (Macro 9-12)
Gerakan Tilt saja (vertical)

```
Macro 9: fx Tilt Sym 1 (SYMMETRIC)
- Attribute: Tilt only
- Form: Cos 9
- Phase: 0 Thru 90
- Wing: (-2,2)
- BPM: 60
- Hasil: Tilt sweep simetris, range kecil

Macro 10: fx Tilt Sym 2 (SYMMETRIC)
- Attribute: Tilt only
- Form: Cos 9
- Phase: 0 Thru 180
- Wing: (-3,3)
- BPM: 60
- Hasil: Tilt sweep simetris, range medium

Macro 11: fx Tilt NonSym 1 (NON-SYMMETRIC)
- Attribute: Tilt only
- Form: Cos 9
- Phase: 0 Thru 360
- Wing: (-2,2)
- BPM: 60
- Hasil: Tilt sweep non-simetris, full rotation

Macro 12: fx Tilt NonSym 2 (NON-SYMMETRIC)
- Attribute: Tilt only
- Form: Ramp Plus 10
- Phase: 0 Thru 180
- Wing: (-4,4)
- BPM: 70
- Hasil: Tilt ramp non-simetris, wide spread
```

## 💡 Usage - Super Simple!

### Cara Menggunakan:

1. **Load Plugin (Sekali Saja):**
   ```
   Plugin "Auto Insert Effects Shape"
   ```
   - 1 master macro dibuat di Macro Pool
   - Macro 1 dengan label "Generate All Shape FX"

2. **Generate Semua Effects (One-Click):**
   ```
   - Buka Macro Pool
   - Click Macro 1 ("Generate All Shape FX")
   - SEMUA 12 effects dibuat sekaligus!
   ```

3. **Itu Saja!**
   - Tidak perlu create effect manual
   - Tidak perlu configure shape manual
   - Satu klik = 12 effects langsung jadi!
   - Semua effects sudah ada di Effect Pool

### 🎯 Contoh Workflow:

**Scenario 1: Generate All Effects**
```
1. Load plugin: Plugin "Auto Insert Effects Shape"
2. Click Macro 1 ("Generate All Shape FX")
   → ALL 12 effects created instantly!
   → fx Circle 1-4 (PT Circle effects)
   → fx Pan Sym 1-2, fx Pan NonSym 1-2 (Pan effects)
   → fx Tilt Sym 1-2, fx Tilt NonSym 1-2 (Tilt effects)
```

**Scenario 2: Use Circle Effect**
```
1. Select fixtures (moving heads)
2. Go to Effect Pool
3. Apply "fx Circle 1" to fixtures
   → Fixtures bergerak dalam circle pattern
   → Phase 0-90, Wing (-2,2)
```

**Scenario 3: Use Pan Sweep**
```
1. Select fixtures
2. Go to Effect Pool
3. Apply "fx Pan Sym 1" to fixtures
   → Fixtures sweep horizontal simetris
   → Phase 0-90, Wing (-2,2)
```

**Scenario 4: Kombinasi Effects**
```
1. Apply "fx Circle 1" → Circle movement
2. Apply "fx Pan Sym 1" → Add pan sweep
3. Apply "fx Tilt Sym 1" → Add tilt sweep
   → Combine multiple effects untuk gerakan kompleks
```

### 🔥 Keuntungan Plugin Ini:

**1. One-Click Generation:**
- 1 macro untuk semua effects
- Generate 12 effects sekaligus
- Super cepat dan efisien

**2. Predefined Shapes:**
- Tidak perlu configure manual
- Shapes sudah dioptimasi
- Siap pakai untuk show

**3. Variety:**
- 4 circle variations
- 4 pan variations (symmetric & non-symmetric)
- 4 tilt variations (symmetric & non-symmetric)

**4. Efficient:**
- All effects created at once
- No repeated clicking
- Master macro approach

**5. Professional:**
- Optimized BPM settings
- Proper phase configurations
- Ready for live shows

## 🔧 Technical Details

### Effect Parameters Explained:

**Phase:**
- `0 Thru 90`: Quarter cycle (subtle movement)
- `0 Thru 180`: Half cycle (medium movement)
- `0 Thru 360`: Full cycle (complete rotation)
- `90`: Static offset (starting position)

**Wing:**
- `(-2,2)`: Small spread (tight pattern)
- `(-3,3)`: Medium spread (balanced)
- `(-4,4)`: Large spread (wide pattern)

**Forms:**
- `Sin 8`: Smooth sine wave (fluid movement)
- `Cos 9`: Smooth cosine wave (fluid movement)
- `Ramp Plus 10`: Linear ramp up (mechanical movement)

**Symmetric vs Non-Symmetric:**
- **Symmetric**: Fixtures mirror each other (balanced look)
- **Non-Symmetric**: Fixtures move independently (dynamic look)

### Command Sequence (PT Circle):

```lua
ClearAll
Fixture Thru
Presettype Pan
At Form 8              -- Sin for Pan
Presettype Tilt
At Form 9              -- Cos for Tilt
At EffectBPM 40
At EffectPhase 0 Thru 90
At EffectWing (-2,2)
Store Effect /nc /o
Label Effect "fx Circle 1"
ClearAll
```

### Command Sequence (Pan Only):

```lua
ClearAll
Fixture Thru
Presettype Pan
At Form 8              -- Sin
At EffectBPM 60
At EffectPhase 0 Thru 90
At EffectWing (-2,2)
Store Effect /nc /o
Label Effect "fx Pan Sym 1"
ClearAll
```

### Command Sequence (Tilt Only):

```lua
ClearAll
Fixture Thru
Presettype Tilt
At Form 9              -- Cos
At EffectBPM 60
At EffectPhase 0 Thru 90
At EffectWing (-2,2)
Store Effect /nc /o
Label Effect "fx Tilt Sym 1"
ClearAll
```

## 📊 Effect Comparison Table

| Macro | Name | Type | Phase | Wing | Symmetric | Use Case |
|-------|------|------|-------|------|-----------|----------|
| 1 | fx Circle 1 | PT Circle | 0-90 | (-2,2) | Yes | Subtle circle |
| 2 | fx Circle 2 | PT Circle | 0-90 | (-4,4) | Yes | Wide circle |
| 3 | fx Circle 3 | PT Circle | 0-360 | (-2,2) | Yes | Full circle |
| 4 | fx Circle 4 | PT Circle | 90 | (-2,2) | Yes | Offset circle |
| 5 | fx Pan Sym 1 | Pan Only | 0-90 | (-2,2) | Yes | Subtle pan |
| 6 | fx Pan Sym 2 | Pan Only | 0-180 | (-3,3) | Yes | Medium pan |
| 7 | fx Pan NonSym 1 | Pan Only | 0-360 | (-2,2) | No | Full pan sweep |
| 8 | fx Pan NonSym 2 | Pan Only | 0-180 | (-4,4) | No | Wide pan ramp |
| 9 | fx Tilt Sym 1 | Tilt Only | 0-90 | (-2,2) | Yes | Subtle tilt |
| 10 | fx Tilt Sym 2 | Tilt Only | 0-180 | (-3,3) | Yes | Medium tilt |
| 11 | fx Tilt NonSym 1 | Tilt Only | 0-360 | (-2,2) | No | Full tilt sweep |
| 12 | fx Tilt NonSym 2 | Tilt Only | 0-180 | (-4,4) | No | Wide tilt ramp |

## ⚠️ Requirements

- GrandMA2 v3.9.61 or higher
- Moving head fixtures with Pan/Tilt attributes
- At least 1 fixture patched in show

## 🆘 Troubleshooting

### Plugin tidak jalan?
- Check files ada di folder `AutoInsertEffectsShape/`
- Check System Monitor untuk error messages
- Pastikan ada fixtures dengan Pan/Tilt yang sudah di-patch

### Master macro tidak muncul?
- Refresh Macro Pool (F5)
- Check System Monitor
- Re-load plugin: `Plugin "Auto Insert Effects Shape"`
- Look for Macro 1 dengan label "Generate All Shape FX"

### Effects tidak ter-generate?
- Click Macro 1 lagi
- Check System Monitor untuk error
- Verify fixtures sudah di-patch
- Check Effect Pool untuk melihat effects yang sudah dibuat

### Effect tidak bergerak?
- Pastikan fixtures support Pan/Tilt
- Check DMX output
- Apply effect dari Effect Pool ke fixtures
- Check BPM rate (mungkin terlalu lambat)

### Circle tidak sempurna?
- Check fixture calibration
- Adjust wing values untuk spread yang lebih baik
- Verify Pan/Tilt range fixtures

### Symmetric effect tidak simetris?
- Check fixture numbering/patching
- Verify fixtures dalam group yang sama
- Check phase distribution

## 💡 Tips & Tricks

### Tip 1: Generate Once, Use Many Times
```
- Generate semua effects sekali saja
- Semua effects tersimpan di Effect Pool
- Gunakan kapan saja tanpa perlu generate lagi
```

### Tip 2: Kombinasi Effects
```
- Gunakan Circle + Pan untuk gerakan kompleks
- Layer multiple effects untuk variasi
- Adjust BPM untuk sinkronisasi
```

### Tip 3: Adjust Wing Values
```
- Wing kecil (-2,2) untuk tight pattern
- Wing besar (-4,4) untuk wide spread
- Edit effect di Effect Pool untuk adjust
```

### Tip 4: Phase Variations
```
- Phase 0-90 untuk subtle movement
- Phase 0-180 untuk balanced movement
- Phase 0-360 untuk full rotation
```

### Tip 5: BPM Adjustment
```
- Slow BPM (30-40) untuk smooth, elegant
- Medium BPM (50-70) untuk balanced
- Fast BPM (80-120) untuk energetic
- Edit effect di Effect Pool untuk adjust
```

### Tip 6: Symmetric vs Non-Symmetric
```
- Symmetric untuk look yang balanced
- Non-Symmetric untuk dynamic, chaotic look
- Mix keduanya untuk variety
```

## 📝 Version History

### v1.0 (2024) - Initial Release - Master Macro Edition
- ✅ 1 master macro untuk generate semua effects
- ✅ 12 predefined shape effects
- ✅ PT Circle effects (4 variations)
- ✅ Pan Only effects (4 variations)
- ✅ Tilt Only effects (4 variations)
- ✅ One-click generation system
- ✅ All effects created at once
- ✅ Symmetric & non-symmetric options
- ✅ Custom phase & wing configurations

## 👤 Credits

**Developer**: BLACKBOXAI  
**Platform**: GrandMA2 v3.9.61+  
**Language**: Lua  
**License**: Educational/Demo purposes  
**Based on**: Auto Insert Effects Plugin

## 📞 Support

Untuk pertanyaan atau issue:
1. Baca dokumentasi lengkap
2. Check System Monitor untuk error messages
3. Test dengan show kosong
4. Verify fixtures support Pan/Tilt
5. Baca GrandMA2 manual

---

**Selamat menggunakan! 🎭✨**

Plugin v1.0 - Pan/Tilt Shape Effects dengan predefined configurations!
