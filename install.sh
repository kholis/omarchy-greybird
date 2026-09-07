#!/usr/bin/env bash
# Greybird for Omarchy - the Xubuntu look:
#   Greybird GTK theme (GTK2/3/4 + Qt5/Qt6), Noto Sans Regular 9,
#   elementary-xfce icons, dark terminals + light everything else.
#
# Run from a terminal on a stock Omarchy machine:
#   ./install.sh
set -euo pipefail

REPO_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
STAMP=$(date +%Y%m%d%H%M%S)

backup() {
  if [[ -e $1 ]]; then
    cp -a "$1" "$1.bak.$STAMP"
    echo "    backed up: $1 -> $1.bak.$STAMP"
  fi
}

echo "==> 1/7 Installing AUR packages (password prompts are normal)"
omarchy pkg aur add greybird-gtk-theme gtk2 gtk-engine-murrine \
  elementary-xfce-icons qt5-styleplugins qt6gtk2

echo "==> 2/7 GTK settings (theme, icons, font, RGB subpixel rendering)"
backup ~/.gtkrc-2.0
cp "$REPO_DIR/config/gtkrc-2.0" ~/.gtkrc-2.0
mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0
backup ~/.config/gtk-3.0/settings.ini
cp "$REPO_DIR/config/gtk-3.0-settings.ini" ~/.config/gtk-3.0/settings.ini
backup ~/.config/gtk-4.0/settings.ini
cp "$REPO_DIR/config/gtk-4.0-settings.ini" ~/.config/gtk-4.0/settings.ini

echo "==> 3/7 fontconfig (Noto Sans wins every default; JetBrainsMono mono stays)"
mkdir -p ~/.config/fontconfig
backup ~/.config/fontconfig/fonts.conf
cp "$REPO_DIR/config/fontconfig-fonts.conf" ~/.config/fontconfig/fonts.conf

echo "==> 4/7 Greybird with greyish base color (#e8e8e8 instead of #fcfcfc)"
mkdir -p ~/.local/share/themes ~/.themes
rm -rf ~/.local/share/themes/Greybird
cp -r /usr/share/themes/Greybird ~/.local/share/themes/Greybird
sed -i 's/#fcfcfc/#e8e8e8/gI; s/#f9f9f9/#e3e3e3/gI' \
  ~/.local/share/themes/Greybird/gtk-3.0/gtk.css \
  ~/.local/share/themes/Greybird/gtk-4.0/gtk.css
sed -i 's/base_color:#fcfcfc/base_color:#e8e8e8/' \
  ~/.local/share/themes/Greybird/gtk-2.0/gtkrc
ln -sfn ~/.local/share/themes/Greybird ~/.themes/Greybird

echo "==> 5/7 Omarchy theme: Greybird (dark terminals, light GUI, Tokyo Night wallpapers)"
mkdir -p ~/.config/omarchy/themes/greybird/backgrounds
cp "$REPO_DIR"/theme/greybird/{colors.toml,icons.theme,foot.ini,alacritty.toml,kitty.conf,ghostty.conf} \
  ~/.config/omarchy/themes/greybird/
# Wallpapers ship with Omarchy's stock Tokyo Night theme - reuse them.
cp /usr/share/omarchy/themes/tokyo-night/backgrounds/* \
  ~/.config/omarchy/themes/greybird/backgrounds/

echo "==> 6/7 theme-set hook (keeps Greybird applied across Omarchy theme switches)"
omarchy hook install theme-set "$REPO_DIR/config/greybird-theme-set-hook.sh"

echo "==> 7/7 Qt platform theme env (appended once to hyprland config)"
LOOKNFEEL=~/.config/hypr/looknfeel.lua
if ! grep -q "QT_QPA_PLATFORMTHEME" "$LOOKNFEEL" 2>/dev/null; then
  cat "$REPO_DIR/config/qt-platform-theme.lua" >> "$LOOKNFEEL"
fi

echo "==> Applying GTK/gsettings now"
bash ~/.config/omarchy/hooks/theme-set.d/greybird-theme-hook.sh || true
QT_QPA_PLATFORMTHEME=gtk2 dbus-update-activation-environment --systemd QT_QPA_PLATFORMTHEME || true

cat <<'EOF'

Done. Finish with:
  1. omarchy theme set greybird   (applies the theme; restarts terminals)
  2. Re-login so Hyprland exports QT_QPA_PLATFORMTHEME=gtk2 to everything

Verify with:
  fc-match sans-serif            -> Noto Sans
  fc-match "Adwaita Sans"        -> Noto Sans
  gtk-query-settings | grep -E "theme-name|font-name|xft"
  omarchy theme list             -> shows Greybird
EOF
