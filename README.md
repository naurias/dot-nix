# dot-nix — personal NixOS dotfiles

Companion dotfiles for the [`nixidite`](https://github.com/naurias/nixidite)
NixOS flake. Consumed as its `dotfiles` flake input (locked rev), so a new
machine resolving the same lockfile gets byte-identical inputs.

This README covers **post-install convergence on a new PC** — everything
needed after `nixos-rebuild switch` to reach 1:1 portability. OS install,
hardware config and host/user setup live in the nixidite README
(§Installation: adapt `systems/<host>/filesystem.nix` etc. to your
`hardware-configuration.nix`, then `nixos-rebuild switch --flake .#<host>`).

## Repo map

| Path | Purpose | How it reaches your `$HOME` |
|---|---|---|
| `common/doom/` | Doom Emacs base (`config.el`, `init.el`, `packages.el`, theme CSS, custom `themes/`) | auto-seeded on first activation; per-theme `style.el` is a live symlink managed by `theme-switch` |
| `gruvbox/noctalia/` | Noctalia `settings.toml` + Kvantum templates (single source; Kvantum themes are rendered from these at build time) | auto-seeded + generated; all 10 palettes installed, selected via `theme-switch` |
| `ohmyposh/` | Prompt configs (`main.toml`, `second.toml`) | auto-seeded; live prompt is the generated `active.toml` |
| `hypr/extra.lua` | Hyprland keybinds/animations/layout | symlinked by the flake (`~/.config/hypr/extra.lua`) |
| `fzftab/` | fzf-tab zsh plugin | symlinked by the flake |
| `mango/` (`autostart.sh`, `config.conf`), `niri/config.kdl` | MangoWC / Niri compositor configs | symlinked by the flake (aspects currently disabled = dormant) |
| `common/ghostty/config.ghostty` | Ghostty fonts (incl. Nerd-Font italics fix) | **manual copy** → `~/.config/ghostty/config.ghostty` |
| `common/pcmanfm-qt/default/settings.conf` | pcmanfm-qt settings (breeze icon fallback) | **manual copy** → `~/.config/pcmanfm-qt/default/settings.conf` |
| `common/gtk-2.0/gtkrc` | GTK2 cursor/font/icon/theme fallback | **manual copy** → `~/.gtkrc-2.0` |
| `common/dolphin/dolphinrc` | Dolphin view preferences (may carry old window geometry — harmless) | **manual copy** → `~/.config/dolphin/dolphinrc` |
| `catppuccin/`, `kanagawa/`, `kanagawa-dragon/`, `tokyonight/`, `rosepine/` | Per-theme files from the pre-dynamic-theming era | **legacy/reference only** — the flake now generates all per-theme configs from its central palette; only `gruvbox/noctalia/` is still consumed. Candidates for future cleanup, do not edit expecting effect. |
| `kitty/`, `kanata/`, `texmf/`, `config-mango`, `config.kbd` | Unused snapshots | ignored by the flake |

## Post-install sequence (new PC)

Assumes nixidite is switched and you are logged in as the configured user.

```sh
# 1. Manual-placement files (ones the flake does not manage):
mkdir -p ~/.config/ghostty ~/.config/pcmanfm-qt/default ~/.config/dolphin
cp common/ghostty/config.ghostty ~/.config/ghostty/config.ghostty
cp common/pcmanfm-qt/default/settings.conf ~/.config/pcmanfm-qt/default/settings.conf
cp common/gtk-2.0/gtkrc ~/.gtkrc-2.0
cp common/dolphin/dolphinrc ~/.config/dolphin/dolphinrc

# 2. Stateful restores (never in git — see below):
#    - ~/Pictures/Wallpapers/  (Noctalia references wallhaven-8gkdy2.jpg by absolute path)
#    - ~/.ssh/, browser profile (or Firefox Sync), ~/.config/nvim if you track it separately

# 3. Rebuild editor toolchains (caches, re-download automatically):
~/.config/emacs/bin/doom sync   # Doom straight packages
#    Neovim: open nvim once (lazy.nvim installs plugins; :Mason for LSPs as needed)

# 4. Re-login so session env (QT_QPA_PLATFORMTHEME, XDG_DATA_DIRS, cursor) applies,
#    then pick a theme and verify:
theme-switch --list
theme-switch kanagawa-dragon
```

Verify checklist: kitty + ghostty colors/fonts (open new windows), Hyprland borders
(`hyprctl reload` is automatic), Noctalia bar + palette, nvim `:colorscheme`,
Emacs `doom-theme`, yazi/bat/fzf in a new shell, GTK apps, Dolphin + pcmanfm-qt
icons (restart them once), `kvantumanager` preview for Qt.

## What does NOT transfer (do these by hand)

- `~/Pictures/Wallpapers/` — same absolute path required.
- `~/.ssh/`, GPG keys, passwords, browser logins (Firefox Sync).
- `~/.config/nvim` full tree (not a repo yet — track it separately if wanted).
- Shell history, flatpaks/containers, Noctalia login/session state.
- Anything under `~/.local/share` caches (nvim lazy/mason, Doom straight,
  Noctalia state) — intentionally rebuilt, not backed up.

## Notes / troubleshooting

- **Running apps don't re-theme**: Qt/GTK/terminal apps read theme at startup.
  After `theme-switch`, restart long-lived apps (or re-login for everything).
- **No rebuild needed to switch themes** — `theme-switch <name>` only flips
  symlinks + reloads; rebuilds are only for flake/dotfile *content* changes.
- `*.hm-backup` / `*.pre-theme-switch-bak` next to a config = Home Manager or
  the switcher preserved your pre-existing file there; diff and delete when happy.
- Doom issues? Run `~/.config/emacs/bin/doom doctor` first.
- After changing this repo: commit + push, then bump the `dotfiles` input in
  nixidite (`nix flake lock` / input update) so the flake resolves the new rev.
