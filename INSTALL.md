# Installation Guide

This document provides installation instructions for all tools configured in this repository.

## Prerequisites

Ensure you have [Homebrew](https://brew.sh/) installed:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Core Tools Installation

### AeroSpace Window Manager

```bash
# Install AeroSpace
brew install --cask nikitabobko/tap/aerospace

# Install aerospace-borders for visual window borders
brew tap FelixKratz/formulae
brew install borders
```

### Terminal Tools

#### Kitty Terminal
```bash
# Option 1: Via Homebrew (recommended)
brew install --cask kitty

# Option 2: Manual installation (if brew version has issues)
# Download from: https://sw.kovidgoyal.net/kitty/binary/
# Follow the installation instructions on the website
```

#### Oh My Posh (Prompt Theme Engine)
```bash
brew install jandedobbeleer/oh-my-posh/oh-my-posh
```

### Development Tools

#### Neovim with NvChad
```bash
# Install Neovim
brew install neovim

# Install dependencies for NvChad
brew install git curl
brew install ripgrep fd # For telescope.nvim
brew install node npm   # For LSP servers and formatters

# Install NvChad (after backing up existing config)
mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null || true
git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
```

#### Code Editors

##### Cursor (VS Code Fork)
```bash
brew install --cask cursor
```

##### Zed Editor
```bash
brew install --cask zed
```

### Fonts

Install a programming font with ligatures support:

```bash
# JetBrains Mono (recommended)
brew install --cask font-jetbrains-mono

# Alternative options
brew install --cask font-fira-code
brew install --cask font-cascadia-code
brew install --cask font-hack-nerd-font
```

## Post-Installation Setup

### 1. Configure AeroSpace
Copy the configuration file:
```bash
mkdir -p ~/.config/aerospace
cp window-managers/aerospace/aerospace.toml ~/.config/aerospace/
```

Start aerospace-borders service:
```bash
brew services start borders
```

### 2. Configure Kitty
```bash
mkdir -p ~/.config/kitty
cp terminals/kitty/kitty.conf ~/.config/kitty/
cp terminals/kitty/current-theme.conf ~/.config/kitty/
```

### 3. Configure Oh My Posh
```bash
mkdir -p ~/Documents/oh-my-posh
cp terminals/oh-my-posh/* ~/Documents/oh-my-posh/
```

### 4. Configure Neovim
```bash
# If you installed NvChad using the command above, copy custom configurations
cp -r editors/nvim/lua/custom/* ~/.config/nvim/lua/custom/ 2>/dev/null || true
cp editors/nvim/init.lua ~/.config/nvim/ 2>/dev/null || true

# Alternative: If you want to use the complete configuration from this repo
# mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null || true
# cp -r editors/nvim ~/.config/
```

### 5. Configure Editors

#### Cursor
```bash
mkdir -p "~/Library/Application Support/Cursor/User"
cp editors/cursor/keybindings.json "~/Library/Application Support/Cursor/User/"
```

#### Zed
```bash
mkdir -p ~/.config/zed
cp editors/zed/keymap.json ~/.config/zed/
```

## Verification

After installation, verify each tool:

```bash
# Check AeroSpace
aerospace --version

# Check borders
borders --version

# Check Kitty
kitty --version

# Check Oh My Posh
oh-my-posh --version

# Check Neovim
nvim --version

# Check Cursor
/Applications/Cursor.app/Contents/MacOS/Cursor --version

# Check Zed
zed --version
```

## Usage Notes

- Restart your terminal after installing Oh My Posh
- Log out and log back in after installing AeroSpace for it to take effect
- The aerospace-borders service provides visual borders around windows when using AeroSpace
- Neovim uses NvChad framework - see https://nvchad.com/docs/quickstart/install for detailed setup
- If using the repo's nvim config, it's based on NvChad v2.5 with custom configurations
- Font configuration in Kitty may require terminal restart to take effect