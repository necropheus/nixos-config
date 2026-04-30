[
  # Window management
  "$mod, c, killactive,"

  # Moving focus
  "$mod, left,  movefocus, l"
  "$mod, right, movefocus, r"
  "$mod, up,    movefocus, u"
  "$mod, down,  movefocus, d"

  # Moving windows
  "$mod SHIFT, left,  swapwindow, l"
  "$mod SHIFT, right, swapwindow, r"
  "$mod SHIFT, up,    swapwindow, u"
  "$mod SHIFT, down,  swapwindow, d"

  # Window resizing
  "$mod CTRL, left,  resizeactive, -60 0"
  "$mod CTRL, right, resizeactive,  60 0"
  "$mod CTRL, up,    resizeactive,  0 -60"
  "$mod CTRL, down,  resizeactive,  0  60"

  # Scroll through existing workspaces with mod + scroll
  "$mod, mouse_down, workspace, e+1"
  "$mod, mouse_up, workspace, e-1"

  # Volume and Media Control
  ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+"
  ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"
  ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
  ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
  ", XF86AudioPlay, exec, playerctl play-pause"
  ", XF86AudioNext, exec, playerctl next"
  ", XF86AudioPrev, exec, playerctl previous"

  # Screenshots
  ",Print, exec, grim -g \"$(slurp -d)\" - | wl-copy"

  # Screen recording (toggle)
  "SHIFT, Print, exec, toggle-screen-record"

  # Layout toggle
  "$mod, space, exec, hyprctl keyword general:layout $(hyprctl getoption general:layout -j | grep -q dwindle && echo master || echo dwindle)"

  # Apps
  "$mod, Return, exec, $terminal"
  "$mod, P, exec, $menu"
  "$mod, B, exec, $browser"
]
++ (
  # workspaces
  # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
  builtins.concatLists (
    builtins.genList (
      i:
      let
        ws = i + 1;
      in
      [
        "$mod, code:1${toString i}, workspace, ${toString ws}"
        "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
      ]
    ) 9
  )
)
