{ pkgs, ... }:
{
  imports = [
    ./activation-scripts
    ./programs
  ];

  home = {
    username = "necropheus";
    homeDirectory = "/home/necropheus";
    stateVersion = "25.11";

    pointerCursor = import ./pointer-cursor.nix { inherit pkgs; };
  };
}
