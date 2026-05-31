# University

A personal documentation repository containing text-based tutorials, cheat sheets, and configuration files for programming languages, development tools, and system utilities.

## Purpose

This repository serves as a centralized knowledge base and quick reference collection, providing:
- **Quick refreshers** on programming languages and frameworks
- **Cheat sheets** for commonly used commands and procedures
- **Configuration files** for development tools and system utilities
- **Documentation** organized in a laboratory-style structure for easy navigation

## Repository Structure

```
university/
├── sync-configs.sh           # Sync live system configs into the repo
├── .agents/                  # Agent skills and tooling (synced)
├── editors/                  # Cursor, Zed, Neovim (NvChad), opencode
├── fonts/                    # Recommended fonts + list.md
├── git/                      # Git cheat sheet
├── keyboards/                # Dygma / hardware keyboard configs
├── laboratory/               # Language cheat sheets (Zig, Rust, TS, Kotlin, ...)
├── LICENSE
├── status-bars/              # SketchyBar items + plugins
├── system/                   # Fastfetch and other system tools
├── terminals/                # Kitty, Ghostty, Oh My Posh themes + switcher
├── themes/                   # General theming notes
├── window-managers/          # AeroSpace config + helpers
└── INSTALL.md                # Tool installation & setup instructions
```

## Key Features

- **Language References**: Cheat sheets for Zig, Rust, TypeScript, Kotlin, and more
- **Development Tools**: Git, multiple editors, and terminal setups
- **macOS System Config**: AeroSpace, SketchyBar, Fastfetch, keyboard firmware
- **Config Syncing**: `sync-configs.sh` (now supports `--dry-run`)
- **Agent-Friendly**: `AGENTS.md` defines validation commands per file type

## Validation Quick Checks

Run these before committing (matches AGENTS.md expectations):

```bash
# Shell scripts
bash -n sync-configs.sh

# Neovim Lua (if changed)
stylua --check editors/nvim/init.lua editors/nvim/lua

# Strict JSON (Oh My Posh themes)
python3 -m json.tool terminals/oh-my-posh/*.omp.json >/dev/null

# Whitespace / conflict markers
git diff --check

# Dry-run sync to preview what would change
./sync-configs.sh --dry-run
```

Backup policy: `*.bak` files are globally ignored and never synced (existing tracked ones were removed).

## Usage

Navigate to the relevant directory for the language or tool you need. Each section contains:
- Syntax examples and code snippets
- Command references and shortcuts
- Configuration files ready for deployment
- Links to official documentation for deeper learning

This repository is designed for developers who want quick access to reference materials and proven configurations without searching through extensive documentation.
