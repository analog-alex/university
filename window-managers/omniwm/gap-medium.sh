#!/bin/bash
# Medium paddings — inner gap fixed at 15, outer 50 — propagates via OmniWM's live settings.toml reload
SETTINGS="$HOME/.config/omniwm/settings.toml"

sed -i '' \
  -e 's/^edgeGaps = .*/edgeGaps = false/' \
  -e 's/^fullscreenUsesOuterGaps = .*/fullscreenUsesOuterGaps = true/' \
  -e 's/^size = .*/size = 15.0/' \
  -e 's/^left = .*/left = 50.0/' \
  -e 's/^right = .*/right = 50.0/' \
  -e 's/^top = .*/top = 50.0/' \
  -e 's/^bottom = .*/bottom = 50.0/' \
  "$SETTINGS"
echo "gaps → medium (inner 15, outer 50)"
