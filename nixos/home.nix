{ config, pkgs, ... }:

let
  dotfiles = "home/rlllok/.dotfiles";
in
{
  home.username = "rlllok";
  home.homeDirectory = "/home/rlllok";

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    blender
  ];

  xdg.configFile.helix = {
    source = "${dotfiles}/helix";
    recursive = true;
  };
}
