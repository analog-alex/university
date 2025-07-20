#!/bin/bash

CONFIG_FILE="$HOME/.config/aerospace/aerospace.toml"
SCREEN_PADDINGS_FILE="$HOME/.config/aerospace/screen_paddings.toml"

# Check current gaps configuration in aerospace.toml
current_left=$(grep "outer.left" "$CONFIG_FILE" | awk '{print $3}')

if [ "$current_left" = "30" ]; then
    # Switch to "one" configuration (larger padding)
    sed -i '' 's/outer\.left.*= 30/outer.left       = 100/' "$CONFIG_FILE"
    sed -i '' 's/outer\.bottom.*= 30/outer.bottom     = 100/' "$CONFIG_FILE"
    sed -i '' 's/outer\.top.*= 30/outer.top        = 100/' "$CONFIG_FILE"
    sed -i '' 's/outer\.right.*= 15/outer.right      = 50/' "$CONFIG_FILE"
else
    # Switch to "two" configuration (smaller padding)
    sed -i '' 's/outer\.left.*= 100/outer.left       = 30/' "$CONFIG_FILE"
    sed -i '' 's/outer\.bottom.*= 100/outer.bottom     = 30/' "$CONFIG_FILE"
    sed -i '' 's/outer\.top.*= 100/outer.top        = 30/' "$CONFIG_FILE"
    sed -i '' 's/outer\.right.*= 50/outer.right      = 15/' "$CONFIG_FILE"
fi

# Reload AeroSpace configuration
aerospace reload-config