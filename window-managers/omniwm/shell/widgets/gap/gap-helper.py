#!/usr/bin/env python3
"""gap-helper: OmniShell provider for the `gap` bar widget.

Cycles the outer padding presets in ~/.config/omniwm/settings.toml:
medium (50) -> large (100) -> default (0) -> medium ...

Speaks the OmniShell provider protocol: JSON arrays, one per line, on
stdin/stdout. Handles one action, "cycle", and publishes state topic "mode".
"""

import json
import os
import re
import sys

SETTINGS = os.path.expanduser("~/.config/omniwm/settings.toml")
ORDER = ["medium", "large", "default"]
OUTER = {"medium": 50.0, "large": 100.0, "default": 0.0}


def emit(frame):
    sys.stdout.write(json.dumps(frame) + "\n")
    sys.stdout.flush()


def read_settings():
    with open(SETTINGS, "r", encoding="utf-8") as f:
        return f.read()


def write_settings(text):
    tmp = SETTINGS + ".tmp"
    with open(tmp, "w", encoding="utf-8") as f:
        f.write(text)
    os.replace(tmp, SETTINGS)


def current_mode(text):
    m = re.search(r"^left = ([0-9.]+)", text, re.M)
    if not m:
        return None
    val = float(m.group(1))
    for name, preset in OUTER.items():
        if abs(preset - val) < 0.01:
            return name
    return "custom"


def cycle():
    text = read_settings()
    mode = current_mode(text)
    try:
        nxt = ORDER[(ORDER.index(mode) + 1) % len(ORDER)]
    except ValueError:
        # custom or unknown value -> fall back to the first preset
        nxt = "medium"
    val = OUTER[nxt]

    def sub(m):
        return f"{m.group(1)} = {val}"

    new_text = re.sub(r"^(left|right|top|bottom) = [0-9.]+", sub, text, flags=re.M)
    if new_text == text:
        return None, "no gap lines matched"
    write_settings(new_text)
    return nxt, None


def main():
    # Direct CLI mode: `gap-helper.py cycle` does one cycle and exits.
    if len(sys.argv) > 1 and sys.argv[1] == "cycle":
        mode, err = cycle()
        if err:
            print(f"error: {err}", file=sys.stderr)
            sys.exit(1)
        print(f"gaps → {mode} (outer {OUTER[mode]:g})")
        return

    text = read_settings()
    mode = current_mode(text)
    if mode:
        emit(["state", "mode", mode])
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            frame = json.loads(line)
        except json.JSONDecodeError:
            continue
        if not isinstance(frame, list) or len(frame) < 3 or frame[0] != "action":
            continue
        rid, name = frame[1], frame[2]
        if name == "cycle":
            mode, err = cycle()
            if err:
                emit(["result", rid, False, err])
            else:
                emit(["result", rid, True, {"mode": mode}])
                emit(["state", "mode", mode])
        else:
            emit(["result", rid, False, f"unknown action: {name}"])


if __name__ == "__main__":
    main()
