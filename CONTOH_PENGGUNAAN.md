# CONTOH PENGGUNAAN - Auto Insert Effects Plugin

Dokumen ini berisi contoh-contoh praktis penggunaan effects yang dibuat oleh plugin.

---

## 📋 Daftar Contoh

1. [Basic Dimmer Chase](#1-basic-dimmer-chase)
2. [Color Rainbow Effect](#2-color-rainbow-effect)
3. [Strobe Effect](#3-strobe-effect)
4. [Wave Effect dengan Phase Offset](#4-wave-effect-dengan-phase-offset)
5. [Kombinasi Multiple Effects](#5-kombinasi-multiple-effects)
6. [Effect dengan Fade Time](#6-effect-dengan-fade-time)
7. [Effect di Executor dengan Fader](#7-effect-di-executor-dengan-fader)
8. [Effect dengan Wings](#8-effect-dengan-wings)
9. [Dynamic Speed Control](#9-dynamic-speed-control)
10. [Effect untuk Specific Fixture Group](#10-effect-untuk-specific-fixture-group)

---

## 1. Basic Dimmer Chase

**Tujuan**: Membuat chase sederhana dengan dimmer sine wave

```
Fixture 1 Thru 10
Effect 1 At 100
Store Cue 1
```

**Hasil**: Fixtures akan fade in/out dengan smooth sine wave

**Tips**: 
- Gunakan Effect 1 (Sine 60 BPM) untuk smooth chase
- Adjust speed dengan `EffectRate 150` untuk lebih cepat

---

## 2. Color Rainbow Effect

**Tujuan**: Membuat rainbow color effect (Advanced version only)

```
Fixture 1 Thru 10
Effect 9 At 100
Store Cue 2
```

**Hasil**: Fixtures akan berubah warna mengikuti rainbow spectrum

**Catatan**: Fixtures harus support RGB/CMY

---

## 3. Strobe Effect

**Tujuan**: Membuat strobe effect dengan square wave

```
Fixture 1 Thru 10
Effect 5 At 100
EffectRate 300
Store Cue 3
```

**Hasil**: Fast strobe effect

**Variasi**:
```
EffectWidth 20    (Short flash)
EffectWidth 80    (Long flash)
```

---

## 4. Wave Effect dengan Phase Offset

**Tujuan**: Membuat wave effect yang bergerak dari kiri ke kanan

```
Fixture 1 Thru 10
Effect 1 At 100
EffectPhase 0 Thru 360
Store Cue 4
```

**Hasil**: Wave effect bergerak smooth dari fixture 1 ke 10

**Variasi**:
```
EffectPhase 360 Thru 0    (Reverse direction)
EffectPhase 0 Thru 720    (Multiple waves)
```

---

## 5. Kombinasi Multiple Effects

**Tujuan**: Combine dimmer dan color effects

```
Fixture 1 Thru 10
Effect 1 At 100           (Dimmer sine)
Effect 9 At 100           (Color rainbow)
Store Cue 5
```

**Hasil**: Fixtures fade in/out sambil berubah warna

**Tips**: Experiment dengan kombinasi berbeda untuk hasil unik

---

## 6. Effect dengan Fade Time

**Tujuan**: Smooth transition saat effect dimulai

```
Fixture 1 Thru 10
Effect 1 At 100 Fade 3
Store Cue 6
```

**Hasil**: Effect akan fade in selama 3 detik

**Variasi**:
```
Effect 1 At 100 Fade 5 Delay 2    (Fade 5s, delay 2s)
```

---

## 7. Effect di Executor dengan Fader

**Tujuan**: Control effect intensity dengan fader

```
Fixture 1 Thru 10
Effect 1 At 100
Store Executor 1.1
```

**Cara Pakai**:
- Push fader up = Effect intensity naik
- Push fader down = Effect intensity turun
- Flash button = Instant full effect

---

## 8. Effect dengan Wings

**Tujuan**: Spread effect dari center ke edge

```
Fixture 1 Thru 10
Effect 1 At 100
Assign Effect 1 /wings = "spread"
Store Cue 8
```

**Wings Options**:
- `spread`: Center ke edge
- `mirror`: Mirror effect
- `wings`: Wing effect

---

## 9. Dynamic Speed Control

**Tujuan**: Control effect speed secara real-time

**Setup**:
```
Fixture 1 Thru 10
Effect 1 At 100
Store Cue 9
```

**Control Speed**:
```
Go Cue 9
EffectRate 50     (Slow)
EffectRate 100    (Normal)
EffectRate 200    (Fast)
EffectRate 400    (Very fast)
```

**Tips**: Bisa assign EffectRate ke encoder untuk real-time control

---

## 10. Effect untuk Specific Fixture Group

**Tujuan**: Apply effect hanya ke group tertentu

**Setup Group**:
```
Fixture 1 Thru 5
Store Group 1 "Front"

Fixture 6 Thru 10
Store Group 2 "Back"
```

**Apply Effect**:
```
Group 1
Effect 1 At 100
Store Cue 10

Group 2
Effect 2 At 100
Store Cue 11
```

**Hasil**: Front fixtures pakai Effect 1, Back fixtures pakai Effect 2

---

## 🎯 Contoh Project Lengkap

### Project: Simple Light Show

**Setup**:
```
# Patch 20 fixtures
# Install plugin
# Create groups
```

**Cue List**:

```
Cue 1: Intro
  Fixture 1 Thru 20
  Effect 1 At 50
  Fade 5
  Store Cue 1

Cue 2: Build Up
  Fixture 1 Thru 20
  Effect 1 At 100
  EffectRate 150
  Fade 3
  Store Cue 2

Cue 3: Drop
  Fixture 1 Thru 20
  Effect 5 At 100
  EffectRate 300
  Effect 9 At 100
  Store Cue 3

Cue 4: Break
  Fixture 1 Thru 20
  Effect 1 At 30
  EffectPhase 0 Thru 360
  Fade 2
  Store Cue 4

Cue 5: Outro
  Fixture 1 Thru 20
  Effect 1 At 0
  Fade 5
  Store Cue 5
```

**Playback**:
```
Go Sequence 1
```

---

## 🎨 Creative Ideas

### Idea 1: Breathing Effect
```
Fixture 1 Thru 10
Effect 1 At 50
EffectRate 30
Store Cue "Breathing"
```

### Idea 2: Random Sparkle
```
Fixture 1 Thru 20
Effect 4 At 100
EffectRate 200
EffectWidth 20
Store Cue "Sparkle"
```

### Idea 3: Slow Color Wash
```
Fixture 1 Thru 10
Effect 9 At 100
EffectRate 20
Store Cue "Color Wash"
```

### Idea 4: Fast Strobe
```
Fixture 1 Thru 10
Effect 5 At 100
EffectRate 500
EffectWidth 10
Store Cue "Strobe"
```

### Idea 5: Wave Chase
```
Fixture 1 Thru 20
Effect 2 At 100
EffectPhase 0 Thru 720
Store Cue "Wave"
```

---

## 🎭 Advanced Techniques

### Technique 1: Layered Effects

```
# Layer 1: Slow dimmer
Fixture 1 Thru 10
Effect 1 At 50
Store Cue 1

# Layer 2: Fast color
Fixture 1 Thru 10
Effect 9 At 100
EffectRate 200
Store Cue 2

# Playback both
Go Cue 1
Go Cue 2
```

### Technique 2: Effect Masking

```
# Create mask group
Fixture 1 + 3 + 5 + 7 + 9
Store Group 10 "Odd"

# Apply effect to mask
Group 10
Effect 1 At 100
Store Cue 10
```

### Technique 3: Effect Morphing

```
# Start with Effect 1
Fixture 1 Thru 10
Effect 1 At 100
Store Cue 1

# Morph to Effect 2
Fixture 1 Thru 10
Effect 2 At 100
Fade 5
Store Cue 2

# Playback
Go Cue 1
Go Cue 2    (Will morph from Effect 1 to 2)
```

---

## 📊 Effect Comparison Table

| Effect | Speed | Smoothness | Energy | Best For |
|--------|-------|------------|--------|----------|
| Effect 1 (Sine) | Medium | Very Smooth | Low | Ambient, slow songs |
| Effect 2 (Ramp) | Medium | Smooth | Medium | Build-ups |
| Effect 3 (Saw) | Fast | Sharp | High | Drops, intense parts |
| Effect 4 (Random) | Fast | Chaotic | High | Energetic, random |
| Effect 5 (Square) | Medium | Sharp | High | Strobe, on/off |

---

## 🎵 Music Sync Tips

### Slow Song (60-80 BPM)
```
Effect 1 At 100
EffectRate 60
```

### Medium Song (100-120 BPM)
```
Effect 2 At 100
EffectRate 100
```

### Fast Song (140-180 BPM)
```
Effect 3 At 100
EffectRate 150
```

### Match BPM Exactly
```
# Jika lagu 128 BPM
Effect 1 At 100
EffectRate 128
```

---

## 💡 Pro Tips

1. **Start Simple**: Mulai dengan 1 effect, pahami dulu cara kerjanya
2. **Experiment**: Coba kombinasi berbeda untuk hasil unik
3. **Save Often**: Save show setelah create effect yang bagus
4. **Use Groups**: Organize fixtures dengan groups untuk control lebih mudah
5. **Label Everything**: Beri nama yang jelas untuk cues dan effects
6. **Test First**: Test effect di show kosong sebelum pakai di production
7. **Backup**: Selalu backup show sebelum experiment
8. **Learn Commands**: Pahami command line untuk workflow lebih cepat
9. **Use Macros**: Buat macros untuk effect combinations yang sering dipakai
10. **Watch Tutorials**: Banyak tutorial GrandMA2 di YouTube

---

## 🔗 Next Steps

Setelah mahir dengan basic effects:

1. **Learn Effect Editor**: Edit effects secara detail
2. **Create Custom Forms**: Buat form sendiri
3. **Use Effect Layers**: Combine multiple effect layers
4. **Master Phase Control**: Control phase untuk complex patterns
5. **Explore Effect Blocks**: Gunakan blocks untuk step effects
6. **Learn Effect Wings**: Master wings untuk spread effects
7. **Create Effect Macros**: Automate effect workflows
8. **Study Effect Theory**: Pahami matematika di balik effects

---

## 📚 Resources

- **GrandMA2 Manual**: Help > Manual (Effect section)
- **Command Reference**: Help > Command Reference
- **Video Tutorials**: YouTube "GrandMA2 Effects"
- **Forum**: https://forum.malighting.com
- **Practice Shows**: Download practice shows untuk belajar

---

**Selamat berkreasi dengan effects! 🎭✨**

Ingat: Practice makes perfect. Semakin sering experiment, semakin mahir Anda!
