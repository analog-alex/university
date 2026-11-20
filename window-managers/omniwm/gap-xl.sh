#!/bin/bash
# Extra-large padding — inner gap fixed at 15, outer 150 — propagates via OmniWM's live settings.toml reload
SETTINGS="$HOME/.config/omniwm/settings.toml"

sed -i '' \
  -e 's/^edgeGaps = .*/edgeGaps = false/' \
  -e 's/^fullscreenUsesOuterGaps = .*/fullscreenUsesOuterGaps = true/' \
  -e 's/^size = .*/size = 15.0/' \
  -e 's/^left = .*/left = 150.0/' \
  -e 's/^right = .*/right = 150.0/' \
  -e 's/^top = .*/top = 150.0/' \
  -e 's/^bottom = .*/bottom = 150.0/' \
  "$SETTINGS"
echo "gaps → xl (inner 15, outer 150)"
