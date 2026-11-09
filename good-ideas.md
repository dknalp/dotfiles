# Good Ideas from Professional Dotfiles Repos

Analyzed: end-4/dots-hyprland (16.6k stars), prasanthrangan/hyprdots (HyDE), JaKooLit/Fedora-Hyprland

---

## Structure

### end-4/dots-hyprland
- `dots/.config/` — all configs under a standard XDG path, easy to stow/rsync
- `dots-extra/` — optional extras separated from core
- `sdata/` — supplementary data, dep lists, install steps
- `.github/` — CI, assets, community files
- Single `setup` entrypoint with subcommands: `install`, `uninstall`, `checkdeps`
- Install steps numbered: `0.greeting.sh` → `1.deps.sh` → `2.setups.sh` → `3.files.sh`
- **Key idea:** configs live under `dots/.config/` mirroring `~/.config/` exactly → `cp -r dots/.config/* ~/.config/` just works

### prasanthrangan/hyprdots (HyDE)
- `Configs/` — all config files
- `Scripts/` — all automation separated from configs
- `Source/assets/` — screenshots, banners, media
- `.github/` — CONTRIBUTING.md, COMMIT_MESSAGE_GUIDELINES.md
- Topics tags act as a feature manifest: `theme-switcher`, `waybar`, `rofi`, `modular`
- **Key idea:** separate scripts from configs clearly

---

## README Best Practices
- Banner image at top (shows what it looks like immediately)
- Badge row: stars, license, discord, last commit
- Short description + feature list
- Screenshots/GIFs showing the DE in action
- Stack table (WM, bar, launcher, terminal, etc.)
- Keybinds table
- Install instructions (one-liner preferred)
- Credits / acknowledgements section
- **Key idea:** README = landing page, not a text wall

---

## Install Script Best Practices
- Single entrypoint (`setup` or `install.sh`)
- Show commands before executing ("transparent install")
- Skippable steps via env vars (`SKIP_DEPS=1`)
- Numbered steps so users know progress
- Dependency check command (`./setup checkdeps`)
- Sudo keepalive for long installs
- **Key idea:** lower onboarding friction to zero

---

## Git / Commit Conventions
- Conventional commits: `feat:`, `fix:`, `docs:`, `style:`, `refactor:`
- Separate commits per component, not one giant commit
- COMMIT_MESSAGE_GUIDELINES.md for contributors
- Dedicated branches for major versions/generations
- **Key idea:** git history = changelog

---

## Misc Pro Touches
- `.gitignore` that excludes secrets, caches, large media
- `LICENSE` file (GPL-3.0 or MIT)
- `CONTRIBUTING.md`
- Topics/tags on GitHub repo
- Screenshots in `assets/` or `.github/assets/`
- Wiki or dedicated docs site
- Discord/community link in README
- Deprecation notices when sunsetting

---

## Applied to This Repo (parsherr/dotfiles)

### What we have ✅
- Clean commit history (8 semantic commits)
- .gitignore
- README with stack + keybinds table
- Separate dirs per tool

### What to add 🔜
- [ ] Mirror XDG structure: rename dirs to match `~/.config/` paths
- [ ] `install.sh` — symlink or copy configs to correct locations
- [ ] `assets/` — screenshot of the DE
- [ ] LICENSE file (MIT)
- [ ] GitHub repo topics: `hyprland`, `catppuccin`, `fedora`, `dotfiles`, `wayland`, `rofi`, `waybar`
- [ ] Banner/screenshot in README
- [ ] `CONTRIBUTING.md` (optional, for future)
</content>
