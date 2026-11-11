#!/bin/bash
# Current defaults — inner gap fixed at 15, outer 0
SETTINGS="$HOME/.config/omniwm/settings.toml"

sed -i '' \
  -e 's/^edgeGaps = .*/edgeGaps = false/' \
  -e 's/^fullscreenUsesOuterGaps = .*/fullscreenUsesOuterGaps = true/' \
  -e 's/^size = .*/size = 15.0/' \
  -e 's/^left = .*/left = 0.0/' \
  -e 's/^right = .*/right = 0.0/' \
  -e 's/^top = .*/top = 0.0/' \
  -e 's/^bottom = .*/bottom = 0.0/' \
  "$SETTINGS"
echo "gaps → default (inner 15, outer 0)"
