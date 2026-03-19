#!/usr/bin/env bash
# HyprPanel config preservation script
# This runs before HyprPanel starts to preserve user configuration

HYPRPANEL_CONFIG_DIR="$HOME/.config/hyprpanel"
HYPRPANEL_CONFIG_FILE="$HYPRPANEL_CONFIG_DIR/config.json"
HYPRPANEL_BACKUP="$HYPRPANEL_CONFIG_DIR/config.json.user"

# Create config directory if it doesn't exist
mkdir -p "$HYPRPANEL_CONFIG_DIR"

# If we have a user backup, restore it
if [ -f "$HYPRPANEL_BACKUP" ]; then
    cp "$HYPRPANEL_BACKUP" "$HYPRPANEL_CONFIG_FILE"
    chmod u+w "$HYPRPANEL_CONFIG_FILE"
    exit 0
fi

# If config.json is a symlink, convert it to a real file
if [ -L "$HYPRPANEL_CONFIG_FILE" ]; then
    cp -L "$HYPRPANEL_CONFIG_FILE" "$HYPRPANEL_CONFIG_FILE.tmp"
    rm "$HYPRPANEL_CONFIG_FILE"
    mv "$HYPRPANEL_CONFIG_FILE.tmp" "$HYPRPANEL_CONFIG_FILE"
    chmod u+w "$HYPRPANEL_CONFIG_FILE"
    # Create initial backup
    cp "$HYPRPANEL_CONFIG_FILE" "$HYPRPANEL_BACKUP"
elif [ -f "$HYPRPANEL_CONFIG_FILE" ]; then
    # Create backup from existing file
    cp "$HYPRPANEL_CONFIG_FILE" "$HYPRPANEL_BACKUP"
    chmod u+w "$HYPRPANEL_CONFIG_FILE"
fi
