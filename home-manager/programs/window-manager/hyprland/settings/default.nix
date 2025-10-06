{
  "$mod" = "SUPER";
  "$terminal" = "kitty";
  "$browser" = "google-chrome-stable";
  "$menu" = "wofi --show drun";

  general = import ./general.nix;
  bind = import ./key-bindings.nix;

  exec-once = [ "hyprpanel" ];

  windowrulev2 = [
    "fullscreen,class:(steam_app_.*)"
    "noborder,class:(steam_app_.*)"
    "noanim,class:(steam_app_.*)"
    "suppressevent fullscreen,class:(steam_app_.*)"
  ];

  monitor = [
    # TV Sony, left, highest res
    "desc:Sony SONY TV 0x01010101, 1920x1080@60, -1920x0, 1"

    # Main Monitor TMN, in front, highest res
    "desc:TMN MK24X7100 000000000000, 1920x1080@60, 0x0, 1"
  ];

  input = {
    follow_mouse = 2;
    repeat_delay = 300;

    # TODO: Try to move this to home-manager
    kb_layout = "us";
    kb_variant = "altgr-intl";
    kb_options = [ "lv3:ralt_switch" ]; # AltGr enabled
  };
}
