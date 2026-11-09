#!/usr/bin/env bash
printf '%s\n' \
    "Super + Enter    →  Terminal" \
    "Super + Q        →  Close window" \
    "Super + D        →  App launcher" \
    "Super + W        →  Brave browser" \
    "Super + C        →  VS Code" \
    "Super + E        →  File manager" \
    "Super + F        →  Wallpaper picker" \
    "Super + V        →  Clipboard history" \
    "Super + 1-6      →  Switch workspace" \
    "Super+Shift+1-6  →  Move to workspace" \
    "Super + arrows   →  Focus window" \
    "Super+Shift+UD   →  Brightness ±5%" \
    "Super+Shift+LR   →  Volume ±5%" \
    "Print            →  Screenshot area" \
    "Super + M        →  Exit Hyprland" \
    "Super + .        →  This cheat sheet" \
| rofi -dmenu -i -p "  Keybinds" -theme ~/.config/rofi/cheatsheet.rasi -no-custom
