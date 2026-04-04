# AGENTS.md

## Purpose
This repository is a personal documentation and configuration repo.
It is mostly Markdown, shell scripts, and tool config files.
There is no conventional app build, package manager, or automated test suite.
Agents should make minimal edits, preserve the current layout, and validate only the files they changed.

## Rule Sources
- Primary repo guidance: `CLAUDE.md`
- `.cursor/rules/`: not present
- `.cursorrules`: not present
- `.github/copilot-instructions.md`: not present
No extra Cursor or Copilot instruction files exist here today.

## Repo Snapshot
- Main branch: `master`
- Repo type: docs + dotfiles/configs
- No `package.json`, `Makefile`, `pyproject.toml`, `Cargo.toml`, `go.mod`, or CI config detected
- `editors/` contains Cursor, Zed, and Neovim config
- `terminals/` contains Kitty and Oh My Posh config
- `window-managers/` contains AeroSpace config
- `status-bars/` contains SketchyBar config/scripts
- `system/` contains system utility config such as Fastfetch
- `laboratory/` contains language cheat sheets and docs

## Build / Lint / Test Reality
- No project-wide build command exists
- No project-wide lint command exists
- No unit or integration test runner exists
- Validation here means syntax checks, format checks, and tool-specific smoke tests

## Core Commands
- Repo status: `git status --short`
- Whitespace/conflict check: `git diff --check`
- Sync live configs into the repo: `bash ./sync-configs.sh`
- If multiple files changed, run `git diff --check` before finishing

## Shell Commands
- Validate one script: `bash -n path/to/script.sh`
- Current examples:
- `bash -n ./sync-configs.sh`
- `bash -n ./terminals/oh-my-posh/switch-theme.sh`
- `bash -n ./window-managers/aerospace/toggle-padding.sh`
- Single-test equivalent for shell: run `bash -n` on the specific script you changed

## Lua / Neovim Commands
- Formatting is driven by `stylua`
- Source of truth: `editors/nvim/.stylua.toml`
- Formatter wiring: `editors/nvim/lua/configs/conform.lua`
- Check one file: `stylua --check editors/nvim/lua/configs/conform.lua`
- Check all tracked Neovim Lua: `stylua --check editors/nvim/init.lua editors/nvim/lua`
- Format in place: `stylua editors/nvim/init.lua editors/nvim/lua`
- Single-test equivalent for Lua: `stylua --check` on the changed file

## Strict JSON Commands
- Only some JSON files are strict JSON
- Oh My Posh themes are strict JSON and can be parser-validated
- Check one file: `python3 -m json.tool terminals/oh-my-posh/local.omp.json >/dev/null`
- Check all current themes:
- `python3 -m json.tool terminals/oh-my-posh/analog_nord.omp.json >/dev/null`
- `python3 -m json.tool terminals/oh-my-posh/local.omp.json >/dev/null`
- `python3 -m json.tool terminals/oh-my-posh/miguel.omp.json >/dev/null`
- Do not use `json.tool` on `editors/cursor/keybindings.json` or `editors/zed/keymap.json`
- Those files contain comments or trailing commas and behave like JSONC
- Single-test equivalent for strict JSON: validate only the changed file

## Tool Smoke Tests
- Run only if the relevant tool is installed
- Version checks: `oh-my-posh --version`, `nvim --version`, `kitty --version`, `aerospace --version`, `zed --version`
- AeroSpace reload after config edits: `aerospace reload-config`
- SketchyBar refresh after bar/plugin edits: `sketchybar --update`
- Docs-only changes usually need human review rather than a command

## How To Think About “Run One Test”
- Shell: `bash -n changed-script.sh`
- Lua: `stylua --check changed-file.lua`
- Strict JSON: `python3 -m json.tool changed-file.json >/dev/null`
- Markdown: review structure, code fences, links, and nearby style
- App config: reload or open the target app if feasible
- Pick the smallest validation command that matches the file you touched

## Code Style

## General
- Keep changes small and local
- Follow the structure already used in the target directory
- Prefer editing an existing file over adding a parallel file
- Do not add new tooling or frameworks unless explicitly asked
- Preserve existing behavior, shortcuts, and config layout unless the task requires change
- Do not rename unrelated files or reorganize directories casually
- Match nearby files before inventing a new pattern

## Markdown
- Use ATX headings: `#`, `##`, `###`
- Leave blank lines between headings, paragraphs, and fenced code blocks
- Use fenced code blocks with language tags when obvious
- Keep docs concise and reference-oriented
- Include official docs links when they help
- Put new content in the most specific existing folder possible
- Match nearby terminology and heading structure

## Lua / Neovim
- Follow `editors/nvim/.stylua.toml`
- 2-space indentation
- 120-column width
- Unix line endings
- Prefer the existing `require "module.path"` style
- Keep modules simple and return tables when that is the local pattern
- Use locals for helpers and short aliases only when reused
- Follow NvChad conventions already present in the repo

## Shell
- Preserve the existing shebang
- Quote variable expansions unless unquoted expansion is required
- Use uppercase names for script-level constants and environment-like variables
- Use `local` for function-scoped Bash variables
- Prefer small helper functions for repeated logic
- Check paths before copying, deleting, or mutating files
- Print clear status messages in sync/update scripts
- Match surrounding indentation instead of reformatting the whole file
- In this repo, larger Bash utilities often use 4 spaces; compact plugin scripts often use 2

## JSON / JSONC / TOML
- Match the target tool’s syntax expectations
- Do not strip comments from JSONC-style files
- Do not remove trailing commas if the surrounding file uses them
- Keep Oh My Posh themes as valid strict JSON
- Preserve existing quoting/alignment style in TOML
- In AeroSpace config, keep the established single-quoted command strings

## Naming and Layout
- Follow nearby filenames instead of inventing a new naming scheme
- Keep new docs or config files near the closest related file
- Use descriptive script names like `switch-theme.sh`
- Maintain the current category layout instead of adding broad top-level folders

## Error Handling and Safety
- Fail early in scripts when appropriate
- Emit actionable error and status messages
- Check existence/readability before syncing from system paths
- Avoid destructive changes unless explicitly required
- Do not overwrite unrelated user changes
- When changing sync logic, think about both new files and deleted files

## Git Notes
- `CLAUDE.md` is git-ignored in this repo
- `sync-configs.sh` is tracked and should change when sync behavior changes
- `editors/nvim/lazy-lock.json` should only change when plugin versions intentionally change
- Avoid incidental reformatting in unrelated files

## Agent Workflow
1. Read the target file and one nearby example
2. Make the smallest correct edit
3. Run the narrowest validation command for that file type
4. Use `git diff --check` if multiple files changed
5. Report what changed and what validation ran
