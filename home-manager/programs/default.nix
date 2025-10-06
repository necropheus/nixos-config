{ pkgs, ... }:
let
  work = import ./work.nix { inherit pkgs; };
in
{
  imports = [
    ./direnv.nix
    ./file-explorer
    ./git.nix
    ./gtk
    ./obs-studio
    ./panels
    ./stylix
    ./terminal-emulator
    ./text-editor
    ./window-manager
  ];

  home.packages =
    with pkgs;
    [
      alsa-tools
      gcc
      google-chrome
      gparted
      kdePackages.wacomtablet
      lsof
      obsidian
      pavucontrol
      pulseaudio
      spotify
      vesktop
      vlc
      zip
    ]
    ++ work;
}
