#!/bin/bash

CONFIG_FILE="$HOME/.config/aerospace/aerospace.toml"
SCREEN_PADDINGS_FILE="$HOME/.config/aerospace/screen_paddings.toml"

# Function to read values from screen_paddings.toml for current size
get_current_size() {
    local current_left=$(grep "outer.left" "$CONFIG_FILE" | awk '{print $3}')
    case "$current_left" in
        "15") echo "small" ;;
        "30") echo "medium" ;;
        "100") echo "large" ;;
        *) echo "medium" ;;
    esac
}

# Function to read values from screen_paddings.toml
read_padding_values() {
    local section="$1"
    eval $(awk -v section="[$section]" '
    $0 == section { in_section = 1; next }
    /^\[/ && in_section { in_section = 0 }
    in_section && /=/ {
        gsub(/[ \t]/, "")
        gsub(/\./, "_")
        print $0
    }' "$SCREEN_PADDINGS_FILE")
}

# Get current size configuration
current_size=$(get_current_size)
read_padding_values "$current_size"

# Check which side has the smallest value (where dock is)
current_left=$(grep "outer.left" "$CONFIG_FILE" | awk '{print $3}')
current_right=$(grep "outer.right" "$CONFIG_FILE" | awk '{print $3}')
current_bottom=$(grep "outer.bottom" "$CONFIG_FILE" | awk '{print $3}')

# Determine current dock position and rotate to next
if [ "$current_right" -lt "$current_left" ] && [ "$current_right" -lt "$current_bottom" ]; then
    # Dock is on right, move to bottom
    new_left=$outer
    new_right=$outer
    new_bottom=$outer_smaller
elif [ "$current_bottom" -lt "$current_left" ] && [ "$current_bottom" -lt "$current_right" ]; then
    # Dock is on bottom, move to left
    new_left=$outer_smaller
    new_right=$outer
    new_bottom=$outer
else
    # Dock is on left (or default), move to right
    new_left=$outer
    new_right=$outer_smaller
    new_bottom=$outer
fi

# Apply new orientation
sed -i '' "s/outer\.left.*= [0-9]*/outer.left       = $new_left/" "$CONFIG_FILE"
sed -i '' "s/outer\.bottom.*= [0-9]*/outer.bottom     = $new_bottom/" "$CONFIG_FILE"
sed -i '' "s/outer\.top.*= [0-9]*/outer.top        = $outer/" "$CONFIG_FILE"
sed -i '' "s/outer\.right.*= [0-9]*/outer.right      = $new_right/" "$CONFIG_FILE"

# Reload AeroSpace configuration
aerospace reload-config