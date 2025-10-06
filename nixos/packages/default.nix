{ pkgs, neovimNightly, ... }:
let
  fonts = import ./fonts.nix { inherit pkgs; };
  secrets = import ./secrets.nix { inherit pkgs; };
  sound = import ./sound.nix { inherit pkgs; };
  wayland = import ./wayland.nix { inherit pkgs; };
in
{
  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.steam = {
    enable = true; # Master switch, already covered in installation
    remotePlay.openFirewall = true; # For Steam Remote Play
    dedicatedServer.openFirewall = true; # For Source Dedicated Server hosting
  };

  environment.systemPackages =
    with pkgs;
    [
      git
      home-manager
      kitty
      gnumake
      neovimNightly
      ripgrep
      xclip
    ]
    ++ secrets
    ++ sound
    ++ wayland;

  fonts.packages = fonts;
}
