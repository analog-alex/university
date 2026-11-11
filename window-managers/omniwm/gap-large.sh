#!/bin/bash
# Large paddings — inner gap fixed at 15, outer 100 — propagates via OmniWM's live settings.toml reload
SETTINGS="$HOME/.config/omniwm/settings.toml"

sed -i '' \
  -e 's/^edgeGaps = .*/edgeGaps = false/' \
  -e 's/^fullscreenUsesOuterGaps = .*/fullscreenUsesOuterGaps = true/' \
  -e 's/^size = .*/size = 15.0/' \
  -e 's/^left = .*/left = 100.0/' \
  -e 's/^right = .*/right = 100.0/' \
  -e 's/^top = .*/top = 100.0/' \
  -e 's/^bottom = .*/bottom = 100.0/' \
  "$SETTINGS"
echo "gaps → large (inner 15, outer 100)"
