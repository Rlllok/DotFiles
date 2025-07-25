{ config, pkgs, ... }:

{ home.username = "rlllok"; home.homeDirectory = "/home/rlllok";

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    wezterm
    helix
    yazi # Shell File Manager

    bibata-cursors
    hyprpaper
    waybar
    wofi
    wl-clipboard

    blender mpv

    renderdoc

    firefox
  ];

}
