#!/bin/bash

CONFIG_FILE="$HOME/.config/aerospace/aerospace.toml"
SCREEN_PADDINGS_FILE="$HOME/.config/aerospace/screen_paddings.toml"

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

# Function to apply padding configuration
apply_padding() {
    local section="$1"
    read_padding_values "$section"
    
    sed -i '' "s/inner\.horizontal.*= [0-9]*/inner.horizontal = $inner_horizontal/" "$CONFIG_FILE"
    sed -i '' "s/inner\.vertical.*= [0-9]*/inner.vertical   = $inner_vertical/" "$CONFIG_FILE"
    sed -i '' "s/outer\.left.*= [0-9]*/outer.left       = $outer_left/" "$CONFIG_FILE"
    sed -i '' "s/outer\.bottom.*= [0-9]*/outer.bottom     = $outer_bottom/" "$CONFIG_FILE"
    sed -i '' "s/outer\.top.*= [0-9]*/outer.top        = $outer_top/" "$CONFIG_FILE"
    sed -i '' "s/outer\.right.*= [0-9]*/outer.right      = $outer_right/" "$CONFIG_FILE"
}

# Function to detect current size based on outer.left value
get_current_size() {
    local current_left=$(grep "outer.top" "$CONFIG_FILE" | awk '{print $3}')
    case "$current_left" in
        "20") echo "small" ;;
        "25") echo "medium" ;;
        "100") echo "large" ;;
        *) echo "small" ;;
    esac
}

# Get current size and toggle to next
current_size=$(get_current_size)

# Three-way toggle: small -> medium -> large -> small
case "$current_size" in
    "small")
        apply_padding "medium"
        ;;
    "medium")
        apply_padding "large"
        ;;
    "large")
        apply_padding "small"
        ;;
    *)
        # Unknown state, default to small
        apply_padding "small"
        ;;
esac

# Reload AeroSpace configuration
aerospace reload-config
