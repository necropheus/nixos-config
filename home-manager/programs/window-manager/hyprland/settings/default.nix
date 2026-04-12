{
  "$mod" = "SUPER";
  "$terminal" = "kitty";
  "$browser" = "google-chrome-stable";
  "$menu" = "wofi --show drun";

  general = import ./general.nix;
  bind = import ./key-bindings.nix;

  windowrule = [
    "match:class (steam_app_.*), fullscreen on"
    "match:class (steam_app_.*), border_size 0"
    "match:class (steam_app_.*), no_anim on"
    "match:class (steam_app_.*), suppress_event fullscreen"
  ];

  monitor = [
    # TV Sony, left, highest res
    "desc:Sony SONY TV 0x01010101, 1920x1080@60, -1920x0, 1"

    # Main Monitor TMN, in front, highest res
    "desc:TMN MK24X7100 000000000000, 1920x1080@60, 0x0, 1"
  ];

  # cursor = {
  #   no_hardware_cursors = true;
  # };

  input = {
    follow_mouse = 2;
    repeat_delay = 300;

    # TODO: Try to move this to home-manager
    kb_layout = "us";
    kb_variant = "altgr-intl";
    kb_options = [ "lv3:ralt_switch" ]; # AltGr enabled
  };

  animation = [
    "workspaces, 0"
  ];
}
