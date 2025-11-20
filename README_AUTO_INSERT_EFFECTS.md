# Auto Insert Effects Plugin untuk GrandMA2

Plugin ini secara otomatis membuat dan memasukkan sample effect dimmer ke dalam Effect Pool ketika plugin di-load/install.

## Fitur

- **Otomatis Insert**: Plugin akan langsung berjalan saat di-load (execute_on_load="1")
- **5 Sample Effects**: Membuat 5 effect dimmer dengan berbagai pattern
- **User Friendly**: Menampilkan progress bar dan konfirmasi dialog
- **Safe**: Meminta konfirmasi sebelum membuat effects

## Effects yang Dibuat

Plugin ini akan membuat 5 effect dimmer berikut:

| Effect # | Nama | Form | BPM | Deskripsi |
|----------|------|------|-----|-----------|
| 1 | Dimmer Sine | Sine | 60 | Smooth sine wave dimmer effect |
| 2 | Dimmer Ramp | Ramp | 80 | Linear ramp up dimmer effect |
| 3 | Dimmer Saw | Saw | 100 | Sawtooth dimmer effect |
| 4 | Dimmer Random | Random | 120 | Random dimmer effect |
| 5 | Dimmer Square | Square | 90 | Square wave dimmer effect |

## Cara Install

1. Copy file `auto_insert_effects.lua` dan `auto_insert_effects.xml` ke folder plugins GrandMA2:
   ```
   C:/ProgramData/MA Lighting Technologies/grandma/gma2_V_3.9.61/plugins/
   ```

2. Buka GrandMA2 console

3. Load plugin dengan command:
   ```
   Plugin "Auto Insert Effects"
   ```

4. Plugin akan otomatis:
   - Menampilkan dialog konfirmasi
   - Membuat 5 sample effects
   - Menampilkan progress bar
   - Menampilkan summary hasil

## Persyaratan

- **Fixtures**: Minimal harus ada 1 fixture yang sudah di-patch di show
- **Effect Numbers**: Effect 1-5 akan dibuat/overwrite jika sudah ada

## Cara Menggunakan Effects

Setelah plugin selesai, Anda bisa menggunakan effects dengan cara:

1. **Dari Command Line**:
   ```
   Fixture 1 Thru 10
   Effect 1 At 100
   ```

2. **Dari Effect Pool**:
   - Buka Effect Pool window
   - Pilih effect yang diinginkan
   - Drag ke fixtures atau executors

3. **Store ke Cue**:
   ```
   Fixture 1 Thru 10
   Effect 1 At 100
   Store Cue 1
   ```

## Customisasi

Untuk mengubah effects yang dibuat, edit file `auto_insert_effects.lua` pada bagian `effects_config`:

```lua
local effects_config = {
    {
        number = 1,           -- Nomor effect
        name = "Dimmer Sine", -- Nama effect
        form = "Sine",        -- Form: Sine, Ramp, Saw, Random, Square, dll
        bpm = 60,             -- Speed dalam BPM
        description = "..."   -- Deskripsi
    },
    -- Tambahkan effect lain di sini
};
```

## Form yang Tersedia

GrandMA2 mendukung berbagai form untuk effects:
- **Sine**: Gelombang sinus halus
- **Ramp**: Naik linear
- **Saw**: Gigi gergaji
- **Square**: Gelombang kotak
- **Random**: Acak
- **Step**: Bertahap
- **Pulse**: Pulsa
- Dan lainnya...

## Troubleshooting

### Plugin tidak jalan
- Pastikan file .lua dan .xml ada di folder plugins yang benar
- Check System Monitor untuk error messages
- Pastikan ada fixtures yang sudah di-patch

### Effects tidak muncul
- Check apakah ada error di System Monitor
- Pastikan fixtures sudah di-patch dengan benar
- Coba manual command: `Store Effect 1`

### Effects sudah ada
- Plugin akan menampilkan konfirmasi sebelum overwrite
- Backup show Anda sebelum menjalankan plugin
- Atau ubah nomor effect di `effects_config`

## File Structure

```
plugins/
├── auto_insert_effects.lua    # Main plugin logic
├── auto_insert_effects.xml    # Plugin metadata
└── README_AUTO_INSERT_EFFECTS.md  # Dokumentasi ini
```

## Versi

- **Version**: 1.0
- **Compatible**: GrandMA2 v3.9.61+
- **Author**: BLACKBOXAI
- **Date**: 2024

## Lisensi

Plugin ini dibuat untuk keperluan edukasi dan demonstrasi.

## Support

Untuk pertanyaan atau masalah, check:
- GrandMA2 Manual: Help > Manual
- System Monitor untuk error logs
- MA Lighting Forum

---

**Catatan**: Selalu backup show Anda sebelum menginstall plugin baru!
