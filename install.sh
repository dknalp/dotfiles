#!/usr/bin/env bash
# parsherr/dotfiles — install script
# Symlinks or copies configs to ~/.config/

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()    { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
confirm() { read -rp "$1 [y/N] " ans; [[ "$ans" =~ ^[Yy]$ ]]; }

echo ""
echo "  parsherr/dotfiles installer"
echo "  Hyprland + Catppuccin Mocha on Fedora"
echo ""

if ! confirm "This will overwrite existing configs in ~/.config/. Continue?"; then
    echo "Aborted."
    exit 0
fi

# Backup existing configs
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d_%H%M)"
info "Backing up existing configs to $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
for dir in hypr waybar rofi kitty wallust; do
    if [ -d "$CONFIG_DIR/$dir" ]; then
        cp -r "$CONFIG_DIR/$dir" "$BACKUP_DIR/" 2>/dev/null || true
    fi
done

# Copy configs
info "Installing configs..."
for dir in hypr waybar rofi kitty wallust; do
    if [ -d "$DOTFILES_DIR/.config/$dir" ]; then
        cp -r "$DOTFILES_DIR/.config/$dir" "$CONFIG_DIR/"
        info "  ✓ $dir"
    fi
done

# SDDM (requires sudo)
if [ -d "$DOTFILES_DIR/sddm" ] && confirm "Install SDDM theme config? (requires sudo)"; then
    sudo cp "$DOTFILES_DIR/sddm/theme.conf" /usr/share/sddm/themes/simple_sddm_2/theme.conf
    info "  ✓ sddm"
fi

echo ""
info "Done! Reload Hyprland with Super+Shift+R or log out and back in."
echo ""
warn "Backup saved to: $BACKUP_DIR"
