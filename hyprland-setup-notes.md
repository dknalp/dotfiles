# Hyprland Setup Notes
> Last updated: 2026-11-08

---

## System Info

| Item | Value |
|---|---|
| OS | Fedora Linux 43 (KDE Plasma Desktop Edition) |
| Kernel | 7.2.9-101.fc43.x86_64 |
| GPU | Intel Alder Lake-P GT1 UHD Graphics |
| Display Manager | SDDM (stays running, handles both KDE and Hyprland sessions) |
| Session Type | Wayland |

---

## Hyprland Distribution

**JaKooLit's Fedora-Hyprland dotfiles**
- Repo: https://github.com/JaKooLit/Fedora-Hyprland
- Installed to: `~/Fedora-Hyprland/`
- Version tag: `v2.3.20` (found in `~/.config/hypr/v2.3.20`)

**Hyprland binary**
- Version: 0.57.1
- Source COPR: `ashbuk/Hyprland-Fedora` (sdegler/hyprland was broken — library version mismatch)
- Installed via: `sudo dnf install hyprland` after enabling ashbuk COPR

> ⚠️ Hyprland 0.57 dropped `.conf` support entirely. Only `hyprland.lua` is read now.
> JaKooLit's dotfiles are all `.conf` — they are IGNORED by Hyprland 0.57.
> All real config lives in `~/.config/hypr/hyprland.lua`.

---

## Key Config Files

| File | Purpose |
|---|---|
| `~/.config/hypr/hyprland.lua` | **THE real config** — only file Hyprland 0.57 reads |
| `~/.config/hypr/UserConfigs/Startup_Apps.conf` | Autostart entries (partially ignored — use hyprland.lua) |
| `~/.config/hypr/UserConfigs/UserKeybinds.conf` | User keybinds (partially ignored — use hyprland.lua) |
| `~/.config/hypr/UserConfigs/WindowRules.conf` | Window rules (partially ignored) |
| `~/.config/hypr/UserConfigs/UserSettings.conf` | User settings overrides (partially ignored) |
| `~/.config/hypr/configs/SystemSettings.conf` | JaKooLit system defaults (partially ignored) |
| `~/.config/hypr/configs/Keybinds.conf` | JaKooLit default keybinds (partially ignored) |
| `~/.config/hypr/monitors.conf` | Monitor config |
| `~/.config/hypr/workspaces.conf` | Workspace rules |
| `~/.config/hypr/hyprlock.conf` | Lock screen config |
| `~/.config/hypr/hypridle.conf` | Idle daemon config |

---

## Active Keybinds (from hyprland.lua)

| Key | Action |
|---|---|
| `Super + Q` | Close active window |
| `Super + Return` | Open kitty terminal |
| `Super + D` | Open rofi app launcher |
| `Super + Space` | Open rofi app launcher |
| `Super + W` | Open Brave browser (Flatpak) |
| `Super + C` | Open VS Code |
| `Super + F` | Open wallpaper picker (rofi image browser from ~/Pictures/wallpapers/) |
| `Super + .` | Open keybind cheat sheet (2-column rofi popup, no search bar) |
| `Super + E` | Open Thunar file manager (default — replaces Dolphin) |
| `Super + Shift + Up` | Increase screen brightness (+5%) |
| `Super + Shift + Down` | Decrease screen brightness (-5%) |
| `Super + Shift + Right` | Increase volume (+5%) |
| `Super + Shift + Left` | Decrease volume (-5%) |

## Keybind Cheat Sheet

**Keybind:** `Super + .` — toggles open/close  
**Script:** `~/.config/hypr/UserScripts/KeybindHints.sh`  
**Theme:** `~/.config/rofi/cheatsheet.rasi` — Catppuccin Mocha, 2 columns, 8 rows, no search bar  

**How it works:** pipes shortcut strings into rofi dmenu with a dedicated theme  
**To add shortcuts:** edit the `printf` list in `KeybindHints.sh`  
**Design notes:**
- Use plain "Super" not ⊞ (doesn't render in rofi)  
- 2 columns × 8 rows fits all 16 shortcuts without scrolling  
- No inputbar (search removed) — just a clean reference popup  
- Used `-no-custom` so pressing Enter doesn't execute anything
| `Super + V` | Toggle float on window |
| `Super + P` | Toggle pseudo-tile |
| `Super + J` | Toggle split layout |
| `Super + 1–9` | Switch to workspace 1–9 |
| `Super + Shift + 1–9` | Move window to workspace 1–9 |
| `Super + Left/Right/Up/Down` | Focus window in direction |
| `Super + Shift + Left/Right/Up/Down` | Move window in direction |
| `Super + mouse drag` | Move window |
| `Super + right-click drag` | Resize window |
| `Super + Shift + R` | Reload Hyprland config |

---

## Installed Applications

| App | Install method | Command |
|---|---|---|
| kitty | dnf | `kitty` |
| Brave Browser | Flatpak | `flatpak run com.brave.Browser` |
| Thunar | dnf | `thunar` | ← default file manager (replaces Dolphin) |
| rofi (Wayland) | dnf | `rofi -show drun -theme ~/.config/rofi/launchers/type-2/catppuccin-mocha.rasi` |
| Waybar | dnf | auto-started |
| hyprlock | COPR | `hyprlock` |
| hypridle | COPR | auto-started |
| gnome-keyring | dnf | auto-started (protects Brave passwords) |
| kvantum | dnf (--nogpgcheck) | theme engine |
| nwg-look | COPR | GTK theme switcher |

---

## Keyboard Layout

- Set in `hyprland.lua` under the `input` block: `kb_layout = "tr"` (Turkish Q)
- The `.conf` file `SystemSettings.conf` also has `kb_layout = tr` but is ignored by 0.57

---

## Browser Password Safety

- Brave Flatpak stores passwords via **gnome-keyring** (not KWallet)
- gnome-keyring is auto-started via SDDM PAM (`/etc/pam.d/sddm` already has `pam_gnome_keyring.so`)
- KDE/KWallet config is untouched — switching back to KDE Plasma restores everything

---

## COPR Repos Enabled

```bash
sudo dnf copr list
# Active relevant ones:
# ashbuk/Hyprland-Fedora   ← Hyprland 0.57.1 builds for Fedora 43
# sdegler/hyprland          ← DISABLED (broken — library version mismatch)
# erikreider/SwayNotificationCenter
# tofik/nwg-shell
```

---

## Switching Between KDE and Hyprland

At the SDDM login screen, click the session selector (bottom-left corner):
- **Hyprland** → JaKooLit Hyprland setup
- **Plasma** → KDE Plasma (fully preserved, nothing was changed)

---

## Useful Commands

```bash
# Reload Hyprland config (live, no logout)
hyprctl reload

# Check active keybinds
hyprctl binds

# Check config errors
hyprctl configerrors

# Check keyboard layout
hyprctl getoption input:kb_layout

# Check running windows
hyprctl clients

# Kill a window interactively
hyprctl kill

# Apply Lua code live (temporary — survives until next reload)
hyprctl eval "hl.bind('SUPER + X', hl.dsp.exec_cmd('some-app'))"
```

---

## Docs & References

| Resource | URL |
|---|---|
| Hyprland wiki | https://wiki.hypr.land |
| Hyprland binds (Lua) | https://wiki.hypr.land/configuring/core/binds/ |
| Hyprland variables | https://wiki.hypr.land/configuring/core/variables/ |
| JaKooLit Fedora-Hyprland | https://github.com/JaKooLit/Fedora-Hyprland |
| ashbuk COPR | https://github.com/AshBuk/Hyprland-Fedora |
| Hyprland forum | https://forum.hypr.land |

---

## Waybar (Status Bar)

**What it is:** Waybar v0.15.0 — top status bar showing workspaces, clock, battery, media controls, etc. Installed via dnf, fully configured by JaKooLit dotfiles.

**Why it wasn't showing:** The autostart line in `hyprland.lua` was commented out. Added it properly with:
```lua
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
end)
```

**Start manually (without logout):**
```bash
pkill waybar; waybar &
```

**Config file:** `~/.config/waybar/configs/[TOP] Default Laptop`
- Position: top, 3px margin, floats with 8px left/right margin
- Left: music player, window title
- Center: workspaces, clock, weather, notifications
- Right: system tray, battery, network, volume, bluetooth

**Style:** `~/.config/waybar/style.css` — this is a **symlink**, not a real file.
Currently points to: `~/.config/waybar/style/[Catppuccin] Mocha.css`

**To change style** (e.g. switch theme):
```bash
ln -sf "/home/dogukan/.config/waybar/style/[THEME NAME].css" ~/.config/waybar/style.css
pkill waybar; waybar &
```

### Current active setup: Minimal Catppuccin

**Config symlink:** `~/.config/waybar/config` → `~/.config/waybar/configs/[TOP] Minimal`
**Style symlink:** `~/.config/waybar/style.css` → `~/.config/waybar/style/minimal-catppuccin.css`

**Layout:**
- Left pill: `hyprland/workspaces` — workspace numbers, active = lavender pill
- Center pill: `clock` — time (`HH:MM`), click to toggle date
- Right pill: `network` · `pulseaudio` · `battery` · `tray`

**Design:**
- Height: 32px (thin)
- Margin: 6px top, 10px left/right (floating)
- Font: JetBrains Mono Nerd Font 13px bold
- Background: transparent window, `#1e1e2e` pills
- Left/right pills have 2px lavender left/right border accent
- Active workspace: lavender `#b4befe` background
- Battery: green → yellow (warning 30%) → red blinking (critical 15%)
- Volume: scroll up/down on icon to change volume, click to mute

**To restore JaKooLit's original bar:**
```bash
ln -sf "/home/dogukan/.config/waybar/configs/[TOP] Default Laptop" ~/.config/waybar/config
ln -sf "/home/dogukan/.config/waybar/style/[Catppuccin] Mocha.css" ~/.config/waybar/style.css
pkill waybar; waybar &
```

**All available styles:** `~/.config/waybar/style/` — 50+ themes including:
- `[Catppuccin] Mocha.css` ← currently active
- `[Catppuccin] Frappe.css`
- `[Transparent] Crystal Clear.css`
- `[Wallust] Colored.css` — matches wallpaper colors via wallust
- `[Colored] Translucent.css`
- and many more

**Other config files in `~/.config/waybar/`:**
| File/Dir | Purpose |
|---|---|
| `Modules` | Default module definitions |
| `ModulesWorkspaces` | Hyprland workspace module config |
| `ModulesCustom` | Custom scripts/modules |
| `ModulesGroups` | Grouped module configs |
| `UserModules` | User-added modules |

---

## Rofi App Launcher

**What it is:** rofi 2.0.0 — Wayland-native app launcher (installed via dnf). Comes with JaKooLit dotfiles with adi1090x's full theme pack.

**Launch command (used in hyprland.lua):**
```
rofi -show drun -theme ~/.config/rofi/launchers/type-2/catppuccin-mocha.rasi
```

**Theme file:** `~/.config/rofi/launchers/type-2/catppuccin-mocha.rasi` — custom Catppuccin Mocha theme built to match waybar exactly.

**Theme details:**
- Background: `#1e1e2e` (Catppuccin Mocha base — same as waybar)
- Input bar: `#313244` (same as waybar modules)
- Selection: `#b4befe` lavender with `#1e1e2e` text (same as waybar active)
- Border: 2px lavender, 14px radius
- Font: JetBrains Mono Nerd Font 11
- Icons: Papirus-Dark
- Width: 560px, 9 items visible, centered on screen

**All available theme types:** `~/.config/rofi/launchers/type-1` through `type-7`, each with up to 15 styles.

**Available color schemes:** `~/.config/rofi/colors/` — adapta, arc, black, catppuccin, cyberpunk, dracula, everforest, gruvbox, lovelace, navy, nord, onedark, paper, solarized, tokyonight, yousai

**Lessons learned about rofi:**
- The old `config.rasi` at `~/.config/rofi/config.rasi` is a fallback config — passing `-theme` on the command line overrides it completely.
- Must use `listview` directly as a child of `mainbox` (not wrapped in a `listbox` container) for apps to show up properly in rofi 2.0.0.
- `lines` controls visible app count — set to 9 for comfortable height.
- `fixed-height: true` on listview prevents the window from collapsing when search returns few results.

---

## Qt Apps Theming (Dolphin, etc.)

**Key lesson:** Dolphin and all KDE/Qt apps ignore GTK settings entirely. They read from `qt5ct` and `qt6ct` configs. gsettings changes have NO effect on them.

**Config files:**
- `~/.config/qt5ct/qt5ct.conf` — Qt5 apps (Dolphin)
- `~/.config/qt6ct/qt6ct.conf` — Qt6 apps

**Current settings:**
| Setting | Value |
|---|---|
| Font | Noto Sans 11 (readable, proportional — NOT monospace) |
| Icon theme | Papirus-Dark |
| Color scheme | Catppuccin-Mocha (from `colors/Catppuccin-Mocha.conf`) |
| Style | kvantum |

**To change Qt font:**
```bash
sed -i 's/^general=.*/general="Font Name,SIZE,-1,5,50,0,0,0,0,0,Regular"/' ~/.config/qt5ct/qt5ct.conf
sed -i 's/^general=.*/general="Font Name,SIZE,-1,5,500,0,0,0,0,0,0,0,0,0,0,1,Regular"/' ~/.config/qt6ct/qt6ct.conf
```
Then restart the app.

**To change Qt icon theme:**
```bash
sed -i 's/^icon_theme=.*/icon_theme=THEME/' ~/.config/qt5ct/qt5ct.conf
sed -i 's/^icon_theme=.*/icon_theme=THEME/' ~/.config/qt6ct/qt6ct.conf
```

**Pitfall:** Setting `QT_QPA_PLATFORMTHEME=qt5ct` in hyprland.lua makes Qt apps use qt5ct — this is correct. But it also means the font set in qt5ct applies to ALL Qt apps including Dolphin. If the font there is monospace (like Fira Code), all Qt apps will show monospace text.

---

## Icon Theme

**Current:** Papirus-Dark (installed via dnf `papirus-icon-theme`)

Applied to:
- gsettings: `gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'`
- GTK3: `~/.config/gtk-3.0/settings.ini` → `gtk-icon-theme-name=Papirus-Dark`
- GTK4: `~/.config/gtk-4.0/settings.ini` → `gtk-icon-theme-name=Papirus-Dark`
- Flatpak: `flatpak override --user --env=ICON_THEME=Papirus-Dark`

**Available variants:** `Papirus`, `Papirus-Dark`, `Papirus-Light`

**To change icon theme:**
```bash
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
sed -i 's/gtk-icon-theme-name=.*/gtk-icon-theme-name=Papirus/' ~/.config/gtk-3.0/settings.ini
sed -i 's/gtk-icon-theme-name=.*/gtk-icon-theme-name=Papirus/' ~/.config/gtk-4.0/settings.ini
```
Then restart the app.

---

## Night Mode / Eye Protection (hyprsunset)

**Tool:** `hyprsunset` v0.4.0 — Hyprland's official night mode, already installed via COPR.

**Current setting:** 4500K warm tone — auto-starts on every login via `hyprland.lua` autostart block.

**Toggle commands:**
```bash
# Turn off
pkill hyprsunset

# Turn on
hyprsunset -t 4500 &

# One-liner toggle (on if off, off if on)
pgrep hyprsunset && pkill hyprsunset || hyprsunset -t 4500 &
```

**Temperature guide:**
| Value | Effect |
|---|---|
| `3000K` | Very warm/orange — heavy night mode |
| `4500K` | Comfortable warm ← current |
| `5500K` | Slight warm tint |
| `6000K` | No change (default daylight) |

**To change temperature**, edit `~/.config/hypr/hyprland.lua` autostart block:
```lua
hl.exec_cmd("hyprsunset -t 4500")  -- change 4500 to desired value
```
Then `pkill hyprsunset && hyprsunset -t NEWVALUE &` to apply immediately.

**To disable permanently**, remove the `hyprsunset` line from the autostart block in `hyprland.lua`.

---

## Animations

**Current state:** Disabled globally for pure speed.

In `~/.config/hypr/hyprland.lua`:
```lua
animations = {
    enabled = false,  -- disabled for pure speed
},
```

**To re-enable** (smooth window open/close/fade effects), change to `enabled = true`. The individual animation curves and timings are already defined below that line and will take effect immediately.

**Individual animations defined (inactive while disabled):**
- `windows` / `windowsIn` / `windowsOut` — spring popin 87%
- `fadeIn` / `fadeOut` / `fade` — smooth fades
- `layers` / `layersIn` / `layersOut` — waybar/rofi slide
- `border` — border color transition

---

## Screenshot

**Tool:** `grim` + `slurp` (both installed via dnf)

| Key | Action |
|---|---|
| `PrtSc` | Draw a selection box → screenshot copied to clipboard |

**Paste it:** `Ctrl+V` in any app (Brave, Telegram, etc.)

**Script:** `~/.config/hypr/scripts/screenshot.sh`
The keybind calls this script — do NOT inline the command directly in `hyprland.lua` because `$(slurp)` subshell expansion breaks when Hyprland calls it inline. Always use the script wrapper.

**To save to file instead of clipboard:**
```bash
grim -g "$(slurp)" ~/Pictures/screenshot.png
```

---

## Clipboard History

**Tool:** `cliphist` (installed via dnf) + `wl-paste` + `rofi`

| Key | Action |
|---|---|
| `Super+V` | Open clipboard history picker in rofi → select to paste |

**How it works:** `wl-paste --watch cliphist store` runs as a daemon and records every copy event. `Super+V` opens a rofi dmenu showing all past clipboard entries — select one to put it back in clipboard, then paste with `Ctrl+V`.

**Daemon autostart:** added to `hyprland.lua` autostart block:
```lua
hl.exec_cmd("wl-paste --watch cliphist store")
```

**Manual start (if not running):**
```bash
nohup bash -c 'wl-paste --watch cliphist store' &
```

**Clear clipboard history:**
```bash
cliphist wipe
```

---

## Dark Theme

**Problem:** Apps defaulted to light theme on Hyprland because `gtk-theme-name=Breeze` (light) was set even though `prefer-dark=true`.

**Fix applied across 4 layers:**

| Layer | File/Command | Value |
|---|---|---|
| GTK3 | `~/.config/gtk-3.0/settings.ini` | `gtk-theme-name=Breeze-Dark` |
| gsettings | `gsettings set org.gnome.desktop.interface gtk-theme 'Breeze-Dark'` | `Breeze-Dark` |
| gsettings | `gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'` | `prefer-dark` |
| Flatpak apps (Brave) | `flatpak override --user --env=GTK_THEME=Breeze-Dark` | `Breeze-Dark` |
| Hyprland env | `hyprland.lua` hl.env lines | `GTK_THEME`, `QT_STYLE_OVERRIDE=kvantum`, `QT_QPA_PLATFORMTHEME=qt5ct` |

**To re-apply manually if something resets:**
```bash
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Breeze-Dark'
flatpak override --user --env=GTK_THEME=Breeze-Dark
```

**For stubborn apps:** run `nwg-look` (GTK theme manager installed by JaKooLit) → set to Breeze-Dark → Apply.

**Installed GTK themes:** `Breeze`, `Breeze-Dark` (in `/usr/share/themes/`)
**Installed icon themes:** `breeze`, `breeze-dark` (in `/usr/share/icons/`)

---

## SDDM Login Screen (detailed)

**Active theme:** `simple_sddm_2`
**Theme directory:** `/usr/share/sddm/themes/simple_sddm_2/`
**Main config:** `/usr/share/sddm/themes/simple_sddm_2/theme.conf` (needs `sudo` to edit)
**SDDM system config:** `/etc/sddm.conf` — `Current=simple_sddm_2`

### Background
**Current wallpaper:** NGE (`nge.jpg`) — same as desktop wallpaper
**Background file location:** `/usr/share/sddm/themes/simple_sddm_2/Backgrounds/default` (no extension)
**theme.conf setting:** `Background="Backgrounds/default"`

**To change SDDM background:**
```bash
sudo cp ~/Pictures/wallpapers/yourimage.jpg /usr/share/sddm/themes/simple_sddm_2/Backgrounds/default
```

### Text Colors
**All text colors set to white `#ffffff`** — header, date, time, login/password fields, session button, hover states.

**To change text colors**, edit `/usr/share/sddm/themes/simple_sddm_2/theme.conf` with sudo:
```bash
sudo nano /usr/share/sddm/themes/simple_sddm_2/theme.conf
# Key color settings:
# HeaderTextColor    — username/hostname at top
# DateTextColor      — date display
# TimeTextColor      — time display
# LoginFieldTextColor   — username input field text
# PasswordFieldTextColor — password input field text
# SessionButtonTextColor — session selector
# LoginButtonTextColor   — login button text
```

### Other SDDM themes installed
| Theme | Path |
|---|---|
| `simple_sddm_2` | `/usr/share/sddm/themes/simple_sddm_2/` ← active |
| `01-breeze-fedora` | `/usr/share/sddm/themes/01-breeze-fedora/` |
| `breeze` | `/usr/share/sddm/themes/breeze/` |

**To switch SDDM theme:**
```bash
sudo nano /etc/sddm.conf
# Change: Current=simple_sddm_2 → Current=01-breeze-fedora
```

### How to preview SDDM without logging out
```bash
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/simple_sddm_2
```

---

## Desktop Wallpaper

**Tool used:** `swww` (installed at `/usr/bin/swww`) — smooth animated wallpaper daemon for Wayland.
Also has `hyprpaper` installed but swww is what JaKooLit's scripts use.

**Wallpaper directory:** `~/Pictures/wallpapers/`

**Current wallpaper:** `~/Pictures/wallpapers/nge.jpg` (Neon Genesis Evangelion)
**All wallpapers saved to:** `~/Pictures/wallpapers/`

### How to change wallpaper

**Step 1 — Copy your image to the wallpapers folder:**
```bash
cp ~/Downloads/yourimage.jpg ~/Pictures/wallpapers/
```

**Step 2 — Set it live immediately:**
```bash
swww img ~/Pictures/wallpapers/yourimage.jpg --transition-type fade --transition-duration 1
```

**Step 3 — Make it persist after reboot** — edit `~/.config/hypr/hyprland.lua`, find the autostart block and change the filename:
```lua
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("swww-daemon")
    hl.exec_cmd("swww img " .. os.getenv("HOME") .. "/Pictures/wallpapers/yourimage.jpg --transition-type fade --transition-duration 1")
end)
```

**Available transition types:** `fade`, `wipe`, `wave`, `grow`, `center`, `outer`, `random`

**JaKooLit's wallpaper script** (also updates rofi/waybar colors from wallpaper via wallust):
```bash
~/.config/hypr/scripts/WallustSwww.sh ~/Pictures/wallpapers/yourimage.jpg
```

**How per-wallpaper color theming works (full pipeline):**
1. `Super+F` → pick wallpaper → `WallpaperSelect.sh` calls `WallustSwww.sh`
2. `wallust run <image>` analyzes the image → generates 16-color palette
3. Writes to `~/.config/waybar/wallust/colors-waybar.css` as `@foreground`, `@background`, `@color0`-`@color15`
4. Waybar CSS (`minimal-catppuccin.css`) imports that file and maps variable names:
   - `@base → @background`, `@text → @foreground`, `@lavender/@blue → @color4`
   - `@surface0 → @background-alt`, `@surface1 → @color8`, `@overlay1 → @color7`
   - `@red → @color1`, `@green → @color2`, `@yellow → @color3`
5. `SIGUSR2` sent to waybar → colors reload live without full restart

**Key fix applied:** Added `@import url("~/.config/waybar/wallust/colors-waybar.css")` to top of `minimal-catppuccin.css` — without this, waybar never read the wallust-generated colors. Also replaced hardcoded Catppuccin hex values with wallust variable references.

**JaKooLit wallpaper selector** (rofi-based picker from your wallpaper folder):
- Keybind: `Super+F`
- Run directly: `~/.config/hypr/UserScripts/WallpaperSelect.sh`
- Theme file: `~/.config/rofi/config-wallpaper.rasi` — Catppuccin Mocha grid layout (4 cols, 3 rows)

**How to add a new wallpaper:**

1. **Quickest** — copy to wallpapers folder, then pick with `Super+F`:
   ```bash
   cp ~/Downloads/yourimage.jpg ~/Pictures/wallpapers/
   # Then press Super+F and select it
   ```

2. **Set immediately from terminal:**
   ```bash
   cp ~/Downloads/yourimage.jpg ~/Pictures/wallpapers/
   swww img ~/Pictures/wallpapers/yourimage.jpg --transition-type fade --transition-duration 0.8 --transition-fps 60 --transition-bezier .25,1,.25,1
   ```

3. **Make it default on login** — edit autostart in `~/.config/hypr/hyprland.lua`, change the filename in the swww img line.

**Supported formats:** jpg, jpeg, png, gif, bmp, tiff, webp, mp4, mkv, mov, webm
**Wallpapers folder:** `~/Pictures/wallpapers/`

**No flicker when changing wallpaper** — `Refresh.sh` no longer kills/restarts waybar.

---

## SDDM Login Screen Theme & Wallpaper

**SDDM theme currently active:** `simple_sddm_2`
**Theme location:** `/usr/share/sddm/themes/simple_sddm_2/`
**Theme config:** `/usr/share/sddm/themes/simple_sddm_2/theme.conf`
**Backgrounds folder:** `/usr/share/sddm/themes/simple_sddm_2/Backgrounds/`

**To change SDDM wallpaper:**
1. Copy your image to the Backgrounds folder:
```bash
sudo cp ~/Pictures/wallpapers/yourimage.jpg /usr/share/sddm/themes/simple_sddm_2/Backgrounds/
```
2. Edit theme.conf to set it:
```bash
sudo nano /usr/share/sddm/themes/simple_sddm_2/theme.conf
# Set: background=Backgrounds/yourimage.jpg
```

**JaKooLit's automated SDDM wallpaper script** (sets SDDM wallpaper to match desktop):
```bash
~/.config/hypr/scripts/sddm_wallpaper.sh
```
This script copies the current desktop wallpaper to the SDDM theme's Backgrounds folder automatically.

**Other SDDM themes installed:**
- `01-breeze-fedora` — KDE Plasma default
- `breeze` — basic breeze
- `simple_sddm_2` — currently active (set in `/etc/sddm.conf`)

**To switch SDDM theme:**
```bash
sudo nano /etc/sddm.conf
# Change: Current=simple_sddm_2  →  Current=01-breeze-fedora
```

---

## Known Issues / Lessons Learned

- **0.57 broke all .conf dotfiles** — JaKooLit hasn't updated for 0.57 Lua yet. All keybind/setting fixes must go in `hyprland.lua` directly.
- **`hyprctl eval hl.bind()`** accumulates — it adds binds, doesn't replace. Use `hyprctl reload` after editing `hyprland.lua` instead of eval for permanent changes.
- **sdegler/hyprland COPR is broken** for Fedora 43 as of Nov 2026 — use ashbuk/Hyprland-Fedora instead.
- **Brave Flatpak** is at `com.brave.Browser` — the executable is `flatpak run com.brave.Browser`.
