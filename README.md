# parsherr/dotfiles

My personal Hyprland setup on Fedora 43.

## Setup

Based on [JaKooLit's Fedora-Hyprland](https://github.com/JaKooLit/Fedora-Hyprland) with heavy customization.

## Stack

| Component | App |
|---|---|
| WM | Hyprland 0.57 |
| Bar | Waybar (minimal Catppuccin Mocha) |
| Launcher | Rofi (Wayland) |
| Terminal | Kitty |
| Browser | Brave (Flatpak) |
| File Manager | Thunar |
| Screenshot | grim + slurp |
| Clipboard | cliphist + wl-clipboard |
| Wallpaper | swww |
| Night Light | hyprsunset |
| Notifications | swaync |
| Login | SDDM (simple_sddm_2 theme) |
| Theme | Catppuccin Mocha |
| Icons | Papirus-Dark |
| Font | JetBrains Mono Nerd Font |

## Keybinds

| Key | Action |
|---|---|
| `Super + Enter` | Terminal (kitty) |
| `Super + Q` | Close window |
| `Super + D / Space` | App launcher |
| `Super + W` | Brave browser |
| `Super + C` | VS Code |
| `Super + E` | File manager (Thunar) |
| `Super + F` | Wallpaper picker |
| `Super + V` | Clipboard history |
| `Super + .` | Keybind cheat sheet |
| `Super + 1-6` | Switch workspace |
| `Super+Shift+1-6` | Move window to workspace |
| `Super + arrows` | Focus window |
| `Super+Shift+Up/Down` | Brightness ±5% |
| `Super+Shift+Left/Right` | Volume ±5% |
| `Print` | Screenshot (select area → clipboard) |

## Structure

```
dotfiles/
├── hypr/          # Hyprland config (hyprland.lua, UserConfigs, UserScripts)
├── waybar/        # Bar config and minimal Catppuccin CSS
├── rofi/          # App launcher + wallpaper picker + cheatsheet themes
├── kitty/         # Terminal config
└── sddm/          # Login screen theme config
```

## Notes

Full setup notes at `~/Desktop/hyprland-setup-notes.md`.
