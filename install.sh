#!/usr/bin/env bash
# dknalp/dotfiles — installer
# One-liner: bash <(curl -s https://raw.githubusercontent.com/dknalp/dotfiles/main/install.sh)

set -e

REPO="https://github.com/dknalp/dotfiles"
RAW="https://raw.githubusercontent.com/dknalp/dotfiles/main"
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

# Colors
GRN="\033[0;32m" YLW="\033[1;33m" RED="\033[0;31m" BLU="\033[0;34m" NC="\033[0m" BLD="\033[1m"

info()    { echo -e "${GRN}  ✓${NC} $1"; }
warn()    { echo -e "${YLW}  !${NC} $1"; }
err()     { echo -e "${RED}  ✗${NC} $1"; exit 1; }
step()    { echo -e "\n${BLD}${BLU}==> $1${NC}"; }
confirm() { read -rp "    $1 [y/N] " ans; [[ "$ans" =~ ^[Yy]$ ]]; }

# ── Banner ─────────────────────────────────────────────────────────────────────
clear
echo -e ""
echo -e "  ${BLD}dknalp/dotfiles${NC}"
echo -e "  Speed-first Hyprland + Catppuccin Mocha on Fedora"
echo -e "  ${BLU}${REPO}${NC}"
echo -e ""
echo -e "  Stack: Hyprland 0.57 · Waybar · Rofi · Kitty · swww · swaync"
echo -e ""

# ── Prereq checks ──────────────────────────────────────────────────────────────
step "Checking prerequisites"

command -v hyprctl >/dev/null 2>&1 || err "Hyprland not found. Install via JaKooLit: https://github.com/JaKooLit/Fedora-Hyprland"
info "Hyprland found: $(hyprctl version 2>/dev/null | head -1 || echo 'ok')"

command -v waybar >/dev/null 2>&1 && info "Waybar found" || warn "Waybar not found — bar won't work"
command -v rofi >/dev/null 2>&1   && info "Rofi found"   || warn "Rofi not found — launcher won't work"
command -v kitty >/dev/null 2>&1  && info "Kitty found"  || warn "Kitty not found — terminal won't work"
command -v swww >/dev/null 2>&1   && info "swww found"   || warn "swww not found — wallpaper won't work"
command -v grim >/dev/null 2>&1   && info "grim found"   || warn "grim not found — screenshots won't work"

# ── Clone or update ────────────────────────────────────────────────────────────
step "Getting dotfiles"

if [ -d "$DOTFILES_DIR/.git" ]; then
    info "Repo already exists at $DOTFILES_DIR — pulling latest"
    git -C "$DOTFILES_DIR" pull --ff-only
else
    info "Cloning to $DOTFILES_DIR"
    git clone "$REPO" "$DOTFILES_DIR"
fi

# ── Confirm ────────────────────────────────────────────────────────────────────
echo -e ""
echo -e "  ${YLW}This will back up and replace:${NC}"
echo -e "    ~/.config/hypr   ~/.config/waybar   ~/.config/rofi"
echo -e "    ~/.config/kitty  ~/.config/wallust"
echo -e ""

confirm "Proceed with installation?" || { echo "Aborted."; exit 0; }

# ── Backup ─────────────────────────────────────────────────────────────────────
step "Backing up existing configs"
BACKUP="$HOME/.config-backup-$(date +%Y%m%d_%H%M)"
mkdir -p "$BACKUP"
for d in hypr waybar rofi kitty wallust; do
    [ -d "$CONFIG_DIR/$d" ] && cp -r "$CONFIG_DIR/$d" "$BACKUP/" && info "  backed up $d"
done
warn "Backup saved to $BACKUP"

# ── Install configs ────────────────────────────────────────────────────────────
step "Installing configs"
for d in hypr waybar rofi kitty wallust; do
    if [ -d "$DOTFILES_DIR/.config/$d" ]; then
        rm -rf "$CONFIG_DIR/$d"
        cp -r "$DOTFILES_DIR/.config/$d" "$CONFIG_DIR/"
        info "$d"
    fi
done

# ── SDDM (optional) ────────────────────────────────────────────────────────────
if [ -f "$DOTFILES_DIR/sddm/theme.conf" ]; then
    echo -e ""
    if confirm "Install SDDM login screen theme? (requires sudo)"; then
        sudo cp "$DOTFILES_DIR/sddm/theme.conf" /usr/share/sddm/themes/simple_sddm_2/theme.conf 2>/dev/null && info "sddm" || warn "SDDM theme not installed (simple_sddm_2 may not be present)"
    fi
fi

# ── Wallpaper ──────────────────────────────────────────────────────────────────
step "Setting up wallpaper directory"
mkdir -p "$HOME/Pictures/wallpapers"
info "Wallpaper directory ready at ~/Pictures/wallpapers"
warn "Add your wallpapers there and press Super+F to pick one"

# ── Reload ─────────────────────────────────────────────────────────────────────
step "Reloading Hyprland"
if pgrep -x Hyprland >/dev/null 2>&1; then
    hyprctl reload && info "Hyprland reloaded"
else
    warn "Hyprland not running — configs will apply on next login"
fi

# ── Done ───────────────────────────────────────────────────────────────────────
echo -e ""
echo -e "  ${GRN}${BLD}Installation complete!${NC}"
echo -e ""
echo -e "  Quick keybinds:"
echo -e "    ${BLD}Super + Enter${NC}  Terminal"
echo -e "    ${BLD}Super + D${NC}      App launcher"
echo -e "    ${BLD}Super + W${NC}      Brave browser"
echo -e "    ${BLD}Super + .${NC}      Full keybind cheat sheet"
echo -e ""
echo -e "  Docs: ${BLU}${REPO}${NC}"
echo -e ""
