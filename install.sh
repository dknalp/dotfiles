#!/usr/bin/env bash
# dknalp/dotfiles — installer
# One-liner: bash <(curl -s https://raw.githubusercontent.com/dknalp/dotfiles/main/install.sh)
set -euo pipefail

REPO="https://github.com/dknalp/dotfiles"
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

GRN="\033[0;32m"; YLW="\033[1;33m"; RED="\033[0;31m"; BLU="\033[0;34m"; NC="\033[0m"; BLD="\033[1m"
info()    { echo -e "${GRN}  ✓${NC} $1"; }
warn()    { echo -e "${YLW}  !${NC} $1"; }
err()     { echo -e "${RED}  ✗${NC} $1"; exit 1; }
step()    { echo -e "\n${BLD}${BLU}==> $1${NC}"; }
confirm() { read -rp "    $1 [y/N] " ans; [[ "$ans" =~ ^[Yy]$ ]]; }

clear
echo -e "\n  ${BLD}dknalp/dotfiles${NC}"
echo -e "  Speed-first Hyprland + Catppuccin Mocha"
echo -e "  ${BLU}${REPO}${NC}\n"

# ── Distro detection ──────────────────────────────────────────────────────────
step "Detecting system"
DISTRO="unknown"
[ -f /etc/os-release ] && { . /etc/os-release; DISTRO="${ID:-unknown}"; }
info "Distro: $DISTRO"

pkg_hint() {
  local pkg="$1"
  case "$DISTRO" in
    fedora)                   echo "sudo dnf install $pkg" ;;
    arch|manjaro|endeavouros) echo "sudo pacman -S $pkg  # or: yay -S $pkg" ;;
    ubuntu|debian|pop)        echo "sudo apt install $pkg" ;;
    *)                        echo "install '$pkg' via your package manager" ;;
  esac
}

# ── Hyprland version check ────────────────────────────────────────────────────
step "Checking Hyprland"
if ! command -v hyprctl &>/dev/null; then
  err "Hyprland not found. Install it first, then re-run this script.
  Fedora:  https://github.com/JaKooLit/Fedora-Hyprland
  Arch:    https://github.com/JaKooLit/Arch-Hyprland
  Ubuntu:  https://github.com/JaKooLit/Ubuntu-Hyprland"
fi

HYPR_VER=$(hyprctl version 2>/dev/null | grep -oP 'v\K[\d.]+' | head -1 || echo "unknown")
info "Hyprland $HYPR_VER"
if [[ "$HYPR_VER" != "unknown" ]]; then
  MINOR=$(echo "$HYPR_VER" | cut -d. -f2)
  if (( MINOR < 50 || MINOR > 59 )); then
    warn "Tested on Hyprland 0.50-0.59. Version $HYPR_VER may have config syntax differences."
    warn "See ISSUES.md #3 for details."
    confirm "Continue anyway?" || { echo "Aborted."; exit 0; }
  fi
fi

# ── Prereq binary check ───────────────────────────────────────────────────────
step "Checking prerequisites"

REQUIRED=(waybar rofi kitty swww grim slurp wl-copy cliphist hyprsunset hypridle swaync brightnessctl playerctl wallust python3)
MISSING=()
for bin in "${REQUIRED[@]}"; do
  if command -v "$bin" &>/dev/null; then
    info "$bin"
  else
    warn "$bin  NOT FOUND  ->  $(pkg_hint "$bin")"
    MISSING+=("$bin")
  fi
done

if (( ${#MISSING[@]} > 0 )); then
  echo ""
  warn "${#MISSING[@]} missing tool(s). Keybinds that use them will silently do nothing."
  warn "See packages.txt for the full per-distro install list."
  confirm "Continue anyway?" || { echo "Aborted. Install missing tools first."; exit 0; }
fi

# ── Clone / update ────────────────────────────────────────────────────────────
step "Getting dotfiles"
if [ -d "$DOTFILES_DIR/.git" ]; then
  info "Already cloned at $DOTFILES_DIR — pulling latest"
  git -C "$DOTFILES_DIR" pull --ff-only
else
  info "Cloning to $DOTFILES_DIR"
  git clone "$REPO" "$DOTFILES_DIR"
fi

# ── Confirm ───────────────────────────────────────────────────────────────────
echo -e "\n  ${YLW}This will back up and replace:${NC}"
echo -e "    ~/.config/hypr  ~/.config/waybar  ~/.config/rofi"
echo -e "    ~/.config/kitty ~/.config/wallust\n"
confirm "Proceed with installation?" || { echo "Aborted."; exit 0; }

# ── Backup ────────────────────────────────────────────────────────────────────
step "Backing up existing configs"
BACKUP="$HOME/.config-backup-$(date +%Y%m%d_%H%M)"
mkdir -p "$BACKUP"
for d in hypr waybar rofi kitty wallust; do
  [ -d "$CONFIG_DIR/$d" ] && cp -r "$CONFIG_DIR/$d" "$BACKUP/" && info "backed up $d"
done
warn "Backup saved to $BACKUP"

# ── Install configs ───────────────────────────────────────────────────────────
step "Installing configs"
for d in hypr waybar rofi kitty wallust; do
  if [ -d "$DOTFILES_DIR/.config/$d" ]; then
    rm -rf "$CONFIG_DIR/$d"
    cp -r "$DOTFILES_DIR/.config/$d" "$CONFIG_DIR/"
    info "$d"
  fi
done

# ── wallust first run ─────────────────────────────────────────────────────────
step "Seeding wallust colors"
SEED_WALL=""
for dir in "$HOME/Pictures/Wallpapers" "$HOME/Pictures" "$HOME/.local/share/wallpapers"; do
  SEED_WALL=$(find "$dir" -maxdepth 2 -type f \( -iname "*.jpg" -o -iname "*.png" \) 2>/dev/null | head -1 || true)
  [ -n "$SEED_WALL" ] && break
done

mkdir -p "$HOME/Pictures/wallpapers"

if command -v wallust &>/dev/null && [ -n "$SEED_WALL" ]; then
  wallust run "$SEED_WALL" 2>/dev/null && info "wallust colors generated from $SEED_WALL" || warn "wallust run failed — theme may look unstyled"
elif command -v wallust &>/dev/null; then
  warn "No wallpaper found. Add one to ~/Pictures/wallpapers and run:  wallust run <path>"
else
  warn "wallust not installed — colors won't be generated"
fi

# ── monitors.conf reminder ────────────────────────────────────────────────────
step "Monitor config"
warn "monitors.conf uses generic 'preferred,auto,1' defaults."
warn "If your monitor shows wrong resolution or refresh rate, run:"
warn "  hyprctl monitors"
warn "Then edit: ~/.config/hypr/monitors.conf"

# ── SDDM (optional) ───────────────────────────────────────────────────────────
if [ -f "$DOTFILES_DIR/sddm/theme.conf" ]; then
  echo ""
  if confirm "Install SDDM login screen theme? (requires sudo)"; then
    sudo cp "$DOTFILES_DIR/sddm/theme.conf" /usr/share/sddm/themes/simple_sddm_2/theme.conf 2>/dev/null \
      && info "SDDM theme installed" \
      || warn "SDDM theme not installed (simple_sddm_2 may not be present — install it first)"
  fi
fi

# ── Reload ────────────────────────────────────────────────────────────────────
step "Finishing up"
if pgrep -x Hyprland &>/dev/null; then
  hyprctl reload && info "Hyprland reloaded"
else
  warn "Hyprland not running — configs will apply on next login"
fi

echo -e "\n  ${GRN}${BLD}Done!${NC}"
echo -e "  Quick keybinds:"
echo -e "    ${BLD}Super+Enter${NC}  Terminal    ${BLD}Super+D${NC}  Launcher"
echo -e "    ${BLD}Super+F${NC}      Wallpapers  ${BLD}Super+.${NC}  Cheat sheet"
echo -e "\n  ${YLW}Something broken?${NC} See ISSUES.md\n"
