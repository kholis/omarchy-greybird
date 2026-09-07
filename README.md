# Greybird for Omarchy

The Xubuntu look on [Omarchy](https://omarchy.org): Greybird GTK theme across
**GTK2, GTK3, GTK4, Qt5 and Qt6**, **Noto Sans Regular 9** as the interface
font, **elementary-xfce** icons — with **dark terminals and light everything
else**, and Tokyo Night wallpapers. Omarchy's own font (JetBrainsMono) and its
stock fontconfig monospace/serif defaults are left untouched.

```
 GTK2/3/4 + Qt5/Qt6 apps .... Greybird, Noto Sans Regular 9, elementary-xfce
 base color ................. #e8e8e8 (greyish, instead of near-white #fcfcfc)
 Qt rendering ............... real GTK2 widgets via QT_QPA_PLATFORMTHEME=gtk2
 terminals (foot/alacritty/
 kitty/ghostty) ............. dark: authentic Greybird-dark + Tango palette
 bar, menus, notifications,
 GTK apps, browser frame .... light Greybird greys + #398ee7 accent
 font rendering ............. anti-aliasing on, slight hinting, RGB subpixel
 wallpapers ................ . Tokyo Night collection (copied from stock theme)
```

## Install

From a terminal on a stock Omarchy machine:

```bash
git clone <this-repo> && cd omarchy-greybird
./install.sh
omarchy theme set greybird   # restarts terminals by design
```

Then re-login once so Hyprland exports the Qt environment everywhere.

## What it installs

| Piece | Where | Purpose |
|---|---|---|
| AUR packages | `greybird-gtk-theme gtk2 gtk-engine-murrine elementary-xfce-icons qt5-styleplugins qt6gtk2` | theme, GTK2 engine, icons, Qt5/Qt6 gtk2 platform themes |
| `config/gtkrc-2.0` | `~/.gtkrc-2.0` | GTK2 + Qt (via gtk2 platform theme) settings |
| `config/gtk-3.0-settings.ini` / `gtk-4.0-settings.ini` | `~/.config/gtk-{3,4}.0/` | GTK3/GTK4 settings incl. font rendering |
| `config/fontconfig-fonts.conf` | `~/.config/fontconfig/fonts.conf` | Noto Sans beats Liberation Sans / Adwaita Sans / Cantarell in fontconfig; RGB subpixel, slight hinting |
| shadowed Greybird | `~/.local/share/themes/Greybird` (+ `~/.themes` symlink) | greyish base color; user copy survives package updates |
| `theme/greybird/` | `~/.config/omarchy/themes/greybird/` | Omarchy theme: light colors.toml, **dark terminal configs** (the generator keeps theme-owned files), icons.theme |
| `config/greybird-theme-set-hook.sh` | installed via `omarchy hook install theme-set` | re-applies Greybird GTK settings whenever Omarchy switches themes |
| `config/qt-platform-theme.lua` | appended to `~/.config/hypr/looknfeel.lua` | `QT_QPA_PLATFORMTHEME=gtk2` for Qt5/Qt6 |

## Notes

- **Dark terminals / light GUI**: Omarchy's template generator never
  overwrites configs a theme ships itself, so `theme/greybird/*.conf|ini`
  pin the four terminals to Greybird-dark while `colors.toml` keeps every
  other surface light. To revert, delete those four files from the theme
  dir and re-select the theme.
- **Base color**: `#e8e8e8` lives in three files under
  `~/.local/share/themes/Greybird/` (see `install.sh` step 4); `install.sh`
  regenerates it from the freshly installed package, so updates to
  `greybird-gtk-theme` are picked up on re-install.
- **adwaita-fonts cannot be removed** (gtk3/gtk4 depend on it) — fontconfig
  makes it unreachable instead.
- **Chromium** picks fonts from fontconfig; to also pin them in an existing
  profile (with Chromium closed):
  ```bash
  P=~/.config/chromium/Default/Preferences
  cp "$P" "$P.bak" && jq '.webkit.webprefs.fonts.standard="Noto Sans"|.webkit.webprefs.fonts.sansserif="Noto Sans"' "$P" > "$P.tmp" && mv "$P.tmp" "$P"
  ```
- **Fractional scaling** + RGB subpixel can cause slight color fringing; if
  that bothers you, switch `font-antialiasing` to `grayscale` in the hook and
  settings files.
- Wallpapers are copied from Omarchy's stock Tokyo Night theme at install
  time, keeping this repo binary-free. Swap in your own under
  `~/.config/omarchy/themes/greybird/backgrounds/`.
