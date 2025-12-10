#!/usr/bin/env bash
# theme-toggle — one command to rule them all
# Toggles between Sakura Dawn (light) and Moonlit Night (dark) across your entire rice

set -euo pipefail

# ── Config ─────────────────────────────────────────────────────
LIGHT="sakura-dawn"
DARK="moonlit-night"

CURRENT=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null || echo "$LIGHT")
CURRENT=${CURRENT//\'/}

if [[ "$CURRENT" == *"$LIGHT"* ]] || [[ "$CURRENT" == "default" ]]; then
    TARGET="$DARK"
    echo "Switching to DARK theme: Moonlit Night"
else
    TARGET="$LIGHT"
    echo "Switching to LIGHT theme: Sakura Dawn"
fi

# ── 1. Neovim ─────────────────────────────────────────────────
if command -v nvim >/dev/null; then
    if [[ $TARGET == "$LIGHT" ]]; then
        echo "colorscheme sakura-dawn-hc" > "$HOME/.config/nvim/current-theme.lua"
        nvim --headless -c "lua vim.cmd('colorscheme sakura-dawn-hc')" -c "qa" 2>/dev/null || true
    else
        echo "colorscheme moonlit-night" > "$HOME/.config/nvim/current-theme.lua"
        nvim --headless -c "lua vim.cmd('colorscheme moonlit-night')" -c "qa" 2>/dev/null || true
    fi
fi

# ── 2. Alacritty ──────────────────────────────────────────────
ALACRITTY_CONFIG="$HOME/.config/alacritty/alacritty.toml"
if [[ -f "$ALACRITTY_CONFIG" ]]; then
    if [[ $TARGET == "$LIGHT" ]]; then
        ln -sf "$HOME/.config/alacritty/themes/sakura-dawn.toml" "$HOME/.config/alacritty/current-theme.toml"
    else
        ln -sf "$HOME/.config/alacritty/themes/moonlit-night.toml" "$HOME/.config/alacritty/current-theme.toml"
    fi
    # Force reload if Alacritty is running
    pkill -USR1 alacritty 2>/dev/null || true
fi

# ── 3. Waybar ─────────────────────────────────────────────────
if command -v waybar >/dev/null; then
    if [[ $TARGET == "$LIGHT" ]]; then
        cp "$HOME/.config/waybar/style-light.css" "$HOME/.config/waybar/style.css"
    else
        cp "$HOME/.config/waybar/style-dark.css" "$HOME/.config/waybar/style.css"
    fi
    pkill -SIGUSR2 waybar || true
fi

# ── 4. Rofi ───────────────────────────────────────────────────
if [[ $TARGET == "$LIGHT" ]]; then
    ln -sf "$HOME/.config/rofi/sakura-dawn.rasi" "$HOME/.config/rofi/current.rasi"
else
    ln -sf "$HOME/.config/rofi/moonlit-night.rasi" "$HOME/.config/rofi/current.rasi"
fi

# ── 5. Hyprland borders & wallpaper ──────────────────────────
if command -v hyprctl >/dev/null; then
    if [[ $TARGET == "$LIGHT" ]]; then
        hyprctl keyword general:col.active_border "rgba(FF8A95FF) rgba(E68A91FF) 45deg"
        hyprctl keyword general:col.inactive_border "rgba(E5E1DB88)"
        hyprpaper --config ~/.config/hypr/hyprpaper-light.conf &
    else
        hyprctl keyword general:col.active_border "rgba(B49FCCFF) rgba(95B8D1FF) 45deg"
        hyprctl keyword general:col.inactive_border "rgba(1A1D2688)"
        hyprpaper --config ~/.config/hypr/hyprpaper-dark.conf &
    fi
    pkill hyprpaper; hyprpaper &>/dev/null &
fi

# ── 6. GTK / Qt (optional – for file managers, etc.) ──────────
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-${TARGET//-/}" 2>/dev/null || true
gsettings set org.gnome.desktop.interface color-scheme "prefer-${TARGET%%-*}" 2>/dev/null || true

echo "Theme switched to $TARGET! Done."
