{ config, lib }:
{
  enable = true;

  # Prevent HM/Stylix from creating a symlink for config.json.
  # HyprPanel (GLib/Vala) can't resolve Nix store symlink chains (ELOOP).
  # Config is copied as a real file by the activation script in default.nix.
  settings = lib.mkForce { };
}
