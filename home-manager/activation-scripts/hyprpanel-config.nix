{ config, lib, pkgs, ... }:

{
  # Copy the preservation script to home directory
  home.file.".local/bin/hyprpanel-preserve.sh" = {
    source = ./hyprpanel-preserve.sh;
    executable = true;
  };

  home.activation.hyprpanelConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # HyprPanel config workaround for NixOS
    # This script preserves manual configuration changes made through the HyprPanel UI
    
    HYPRPANEL_CONFIG_DIR="$HOME/.config/hyprpanel"
    HYPRPANEL_CONFIG_FILE="$HYPRPANEL_CONFIG_DIR/config.json"
    HYPRPANEL_BACKUP="$HYPRPANEL_CONFIG_DIR/config.json.user"
    
    # Create config directory if it doesn't exist
    $DRY_RUN_CMD mkdir -p "$HYPRPANEL_CONFIG_DIR"
    
    # If config.json is a symlink or doesn't exist, replace it with a real file
    if [ -L "$HYPRPANEL_CONFIG_FILE" ] || [ ! -f "$HYPRPANEL_CONFIG_FILE" ]; then
      $VERBOSE_ECHO "HyprPanel: Converting symlink to real file to preserve manual changes"
      
      # Read the content from the symlink target (or default config from nixpkgs)
      if [ -L "$HYPRPANEL_CONFIG_FILE" ]; then
        $DRY_RUN_CMD cp -L "$HYPRPANEL_CONFIG_FILE" "$HYPRPANEL_CONFIG_FILE.tmp"
        $DRY_RUN_CMD rm "$HYPRPANEL_CONFIG_FILE"
        $DRY_RUN_CMD mv "$HYPRPANEL_CONFIG_FILE.tmp" "$HYPRPANEL_CONFIG_FILE"
        $DRY_RUN_CMD chmod u+w "$HYPRPANEL_CONFIG_FILE"
      else
        # If no config exists at all, create an empty one (HyprPanel will initialize it)
        $VERBOSE_ECHO "HyprPanel: No config found, will be initialized on first run"
      fi
    else
      $VERBOSE_ECHO "HyprPanel: Config file already exists as regular file, preserving manual changes"
      # Ensure the file is writable
      $DRY_RUN_CMD chmod u+w "$HYPRPANEL_CONFIG_FILE"
    fi
    
    # Create backup if it doesn't exist
    if [ -f "$HYPRPANEL_CONFIG_FILE" ] && [ ! -f "$HYPRPANEL_BACKUP" ]; then
      $VERBOSE_ECHO "HyprPanel: Creating initial backup"
      $DRY_RUN_CMD cp "$HYPRPANEL_CONFIG_FILE" "$HYPRPANEL_BACKUP"
    fi
  '';
}
