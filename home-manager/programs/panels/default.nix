{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.hyprpanel = import ./hyprpanel.nix { inherit config lib; };

  # HyprPanel (GLib/Vala) can't resolve Nix store symlink chains (ELOOP).
  # settings is mkForce'd to {} so HM creates no symlink.
  # Instead, copy the config as a real writable file.
  home.activation.hyprpanelConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    configDir="$HOME/.config/hyprpanel"
    configFile="$configDir/config.json"
    mkdir -p "$configDir"
    rm -f "$configFile"
    cp "${./hyprpanel-settings.json}" "$configFile"
    chmod u+w "$configFile"
  '';

  home.packages = with pkgs; [
    (pkgs.python3.withPackages (python-pkgs: [
      ## Used for Tracking GPU Usage in your Dashboard (NVidia only)
      python-pkgs.gpustat

      ## TODO: Move these to another file
      python-pkgs.pip
    ]))

    ## To record screen through the dashboard record shortcut
    wf-recorder

    ## To enable the eyedropper color picker with the default snapshot shortcut in the dashboard
    hyprpicker

    ## To enable hyprland's very own blue light filter
    hyprsunset

    ## To click resource/stat bars in the dashboard and open btop
    btop

    ## To enable matugen based color theming
    matugen

    ## To enable matugen based color theming and setting wallpapers
    swww
  ];
}
