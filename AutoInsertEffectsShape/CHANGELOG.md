# Changelog - Auto Insert Effects Shape Plugin

All notable changes to this project will be documented in this file.

## [1.0.0] - 2024-01-15

### 🎉 Initial Release

#### Added
- **12 Predefined Shape Effects** for Pan/Tilt movement
  - 4 PT Circle effects (combined Pan + Tilt)
  - 4 Pan Only effects (horizontal movement)
  - 4 Tilt Only effects (vertical movement)

#### PT Circle Effects (Macro 1-4)
- **fx Circle 1**: Small circle with phase 0-90, wing (-2,2)
- **fx Circle 2**: Wide circle with phase 0-90, wing (-4,4)
- **fx Circle 3**: Full circle rotation with phase 0-360, wing (-2,2)
- **fx Circle 4**: Circle with 90° offset, wing (-2,2)

#### Pan Only Effects (Macro 5-8)
- **fx Pan Sym 1**: Symmetric pan sweep, phase 0-90, wing (-2,2)
- **fx Pan Sym 2**: Symmetric pan sweep, phase 0-180, wing (-3,3)
- **fx Pan NonSym 1**: Non-symmetric pan sweep, phase 0-360, wing (-2,2)
- **fx Pan NonSym 2**: Non-symmetric pan ramp, phase 0-180, wing (-4,4)

#### Tilt Only Effects (Macro 9-12)
- **fx Tilt Sym 1**: Symmetric tilt sweep, phase 0-90, wing (-2,2)
- **fx Tilt Sym 2**: Symmetric tilt sweep, phase 0-180, wing (-3,3)
- **fx Tilt NonSym 1**: Non-symmetric tilt sweep, phase 0-360, wing (-2,2)
- **fx Tilt NonSym 2**: Non-symmetric tilt ramp, phase 0-180, wing (-4,4)

#### Features
- ✅ Smart macro system (effects created on-demand)
- ✅ Predefined configurations for quick setup
- ✅ Symmetric and non-symmetric movement options
- ✅ Custom phase ranges for different movement styles
- ✅ Custom wing values for spread control
- ✅ Optimized BPM settings per effect type
- ✅ Auto-labeling of effects
- ✅ Progress bar during macro creation
- ✅ Confirmation dialogs
- ✅ Error handling

#### Documentation
- ✅ Complete README.md in Indonesian
- ✅ Quick installation guide (INSTALASI.txt)
- ✅ Usage examples and workflows
- ✅ Troubleshooting guide
- ✅ Tips & tricks section
- ✅ Effect comparison table
- ✅ Technical details and command sequences

#### Technical Details
- **Platform**: GrandMA2 v3.9.61+
- **Language**: Lua
- **Total Macros**: 12
- **Effect Types**: PT Circle, Pan Only, Tilt Only
- **Forms Used**: Sin (8), Cos (9), Ramp Plus (10)
- **Phase Ranges**: 0-90, 0-180, 0-360, 90 (static)
- **Wing Values**: (-2,2), (-3,3), (-4,4)
- **BPM Settings**: 40 (circles), 60 (sweeps), 70 (ramps)

#### Files Included
1. `auto_insert_effects_shape.lua` - Main plugin logic (450+ lines)
2. `auto_insert_effects_shape.xml` - Plugin metadata
3. `README.md` - Complete documentation (600+ lines)
4. `INSTALASI.txt` - Quick installation guide
5. `TODO.md` - Implementation tracking
6. `CHANGELOG.md` - This file

### Design Philosophy
- **Ease of Use**: One-click effect creation
- **Predefined Quality**: Professional configurations out of the box
- **Flexibility**: Multiple variations for different scenarios
- **Efficiency**: On-demand creation, no wasted effect slots
- **Documentation**: Comprehensive guides in Indonesian

### Based On
- Auto Insert Effects Plugin v4.0
- Smart macro approach
- GrandMA2 effect system

### Requirements
- GrandMA2 v3.9.61 or higher
- Moving head fixtures with Pan/Tilt attributes
- At least 1 fixture patched in show

### Known Limitations
- Requires fixtures with Pan/Tilt support
- Effects created in next available slot
- No automatic effect cleanup
- BPM values are fixed per effect type

### Future Considerations
- [ ] User-adjustable BPM settings
- [ ] Additional shape variations
- [ ] XY position effects
- [ ] Combined multi-attribute effects
- [ ] Effect preset library
- [ ] Auto-cleanup of unused effects

---

## Version Format

This project follows [Semantic Versioning](https://semver.org/):
- **MAJOR**: Incompatible API changes
- **MINOR**: New functionality (backwards compatible)
- **PATCH**: Bug fixes (backwards compatible)

## Categories

- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Security fixes

---

**Developer**: BLACKBOXAI  
**License**: Educational/Demo purposes  
**Platform**: GrandMA2 v3.9.61+
