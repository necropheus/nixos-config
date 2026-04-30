{ pkgs, ... }:
let
  toggle-screen-record = pkgs.writeShellScriptBin "toggle-screen-record" ''
    RECORDINGS_DIR="$HOME/Videos/Recordings"
    mkdir -p "$RECORDINGS_DIR"

    if pgrep -x wf-recorder > /dev/null; then
      pkill -INT wf-recorder
    else
      GEOMETRY=$(${pkgs.slurp}/bin/slurp 2>/dev/null)
      FILENAME="$RECORDINGS_DIR/recording-$(date +%Y%m%d-%H%M%S).mp4"

      if [ -n "$GEOMETRY" ]; then
        ${pkgs.wf-recorder}/bin/wf-recorder -g "$GEOMETRY" -f "$FILENAME"
      else
        ${pkgs.wf-recorder}/bin/wf-recorder -f "$FILENAME"
      fi
    fi
  '';
in
{
  wayland.windowManager.hyprland = import ./hyprland;

  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    toggle-screen-record
  ];
}
