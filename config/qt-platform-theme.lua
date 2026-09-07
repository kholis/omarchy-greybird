-- Greybird for Omarchy: make Qt5/Qt6 apps follow the Greybird GTK2 theme
-- (real GTK2 widget rendering, not just the palette). Overrides Omarchy's
-- default `QT_QPA_PLATFORMTHEME=gtk3` from envs.lua, which loads before
-- personal config files. Requires qt5-styleplugins (Qt5) and qt6gtk2 (Qt6)
-- from the AUR; both read ~/.gtkrc-2.0.
hl.env("QT_QPA_PLATFORMTHEME", "gtk2")
