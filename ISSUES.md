# ISSUES.md — Known Setup Problems

> Analysed 2026-11-10. These are the friction points that make this repo hard to set up on a fresh machine.

---

## 1. Hard prerequisite: JaKooLit installer assumed

The original README said "Requires Hyprland installed via JaKooLit's installer." That hidden dependency blocked anyone not already on the exact same machine.

**Status:** `install.sh` now checks all prereqs itself and prints distro-specific install commands. JaKooLit is listed as one option, not a requirement.

---

## 2. Fedora 43 only — no distro detection

Scripts with `dnf` calls or Fedora-specific paths failed silently on Arch, Ubuntu, etc.

**Status:** `install.sh` now detects distro via `/etc/os-release` and shows the right package manager command for each missing binary.

---

## 3. Hyprland version pinned to 0.57

Hyprland breaks Lua config syntax across releases. Outside 0.50–0.59 things fail silently.

**Status:** `install.sh` now reads `hyprctl version`, checks the minor version, and warns (with a prompt) if outside the tested range.

---

## 4. ~40 scripts assume binaries exist — no install step

Each script in `scripts/` and `UserScripts/` silently does nothing if its binary is missing. The original installer only checked 5 of the ~15 required tools.

**Status:** `install.sh` now checks all 15 required binaries and prints the install command for each missing one before proceeding.

Full list of required binaries:

| Binary | Used by |
|--------|---------|
| `waybar` | status bar |
| `rofi` | app launcher, wallpaper picker |
| `kitty` | terminal (Super+Enter) |
| `swww` | wallpaper daemon |
| `grim` + `slurp` | screenshots |
| `wl-copy` + `cliphist` | clipboard history (Super+V) |
| `hyprsunset` | night light / blue light filter |
| `hypridle` | idle/lock screen trigger |
| `swaync` | notifications |
| `brightnessctl` | brightness keys |
| `playerctl` | media keys (play/pause/next) |
| `wallust` | color generation from wallpaper |
| `python3` | Weather widget |

See `packages.txt` for per-distro install commands.

---

## 5. wallust not seeded on fresh install

On first install with no wallpaper, `wallust` never ran, so Waybar/Rofi/Kitty had no generated colors and looked broken or grey.

**Status:** `install.sh` now scans `~/Pictures` for an existing wallpaper and runs `wallust run <wallpaper>` automatically. If none is found, it prints the manual command.

---

## 6. 100+ Rofi .rasi files, no default marked

7 launcher types x up to 15 styles = 100+ `.rasi` files. Any parse error in one breaks the launcher. It was not documented which style is active.

**Workaround:** The active style is set in `.config/rofi/launchers/type-2/launcher.sh`. To change it, edit the `style` variable there. Unused styles can be deleted without affecting anything.

**Status:** Needs a cleanup commit to trim unused styles. Not done yet.

---

## 7. No package list

There was no single file listing every required package — users had to grep through 40+ scripts.

**Status:** `packages.txt` added with the full list and per-distro install commands.

---

## 8. monitors.conf — generic defaults, no explanation

The file uses `monitor=,preferred,auto,1` which works on most machines but gives no hint about how to set a specific resolution, refresh rate, or multi-monitor layout.

**Status:** Comments expanded with examples. Run `hyprctl monitors` to find your monitor names, then edit `~/.config/hypr/monitors.conf`.
