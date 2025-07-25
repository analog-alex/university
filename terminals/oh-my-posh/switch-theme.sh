#!/bin/bash

# Oh My Posh Theme Switcher
# Usage: ./switch-theme.sh <theme-name>
# Example: ./switch-theme.sh h10

if [ $# -eq 0 ]; then
    echo "Usage: $0 <theme-name>"
    echo "Available themes:"
    for theme in *.omp.json; do
        if [ "$theme" != "local.omp.json" ]; then
            basename "$theme" .omp.json
        fi
    done
    exit 1
fi

THEME_NAME="$1"
THEME_FILE="${THEME_NAME}.omp.json"
LOCAL_FILE="local.omp.json"

if [ ! -f "$THEME_FILE" ]; then
    echo "Error: Theme file '$THEME_FILE' not found"
    echo "Available themes:"
    for theme in *.omp.json; do
        if [ "$theme" != "local.omp.json" ]; then
            basename "$theme" .omp.json
        fi
    done
    exit 1
fi

echo "Switching to theme: $THEME_NAME"
cp "$THEME_FILE" "$LOCAL_FILE"

if [ $? -eq 0 ]; then
    echo "Theme switched successfully to: $THEME_NAME"
else
    echo "Error: Failed to switch theme"
    exit 1
fi