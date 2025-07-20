# AeroSpace Configuration

This folder contains configuration files for AeroSpace, a tiling window manager for macOS.

## Files

- `aerospace.toml` - Main AeroSpace configuration file
- `screen_paddings.toml` - Different padding configurations for different screens
- `toggle-padding.sh` - Script to toggle between padding configurations

## Features

### Dynamic Padding Toggle
Press `Alt+B` to cycle between two padding configurations:
- **Configuration "one"**: Larger padding (100px left/top/bottom, 50px right)
- **Configuration "two"**: Smaller padding (30px left/top/bottom, 15px right)

### Floating Applications
- **Finder** is configured to always open in floating mode

### Key Bindings
- `Alt+B` - Toggle between padding configurations
- Standard AeroSpace navigation and window management keys are configured

## Setup on Another Machine

### 1. Install AeroSpace
```bash
brew install --cask nikitabobko-tap/cask/aerospace
```

### 2. Copy Configuration Files
```bash
# Create config directory
mkdir -p ~/.config/aerospace

# Copy all files from this directory to ~/.config/aerospace/
cp aerospace.toml ~/.config/aerospace/
cp screen_paddings.toml ~/.config/aerospace/
cp toggle-padding.sh ~/.config/aerospace/
```

### 3. Set Permissions
```bash
# Make the toggle script executable
chmod +x ~/.config/aerospace/toggle-padding.sh
```

### 4. Grant Accessibility Permissions
1. Open **System Preferences** → **Security & Privacy** → **Privacy**
2. Select **Accessibility** from the left sidebar
3. Click the lock icon and enter your password
4. Click the **+** button and add **AeroSpace**
5. Ensure AeroSpace is checked in the list

### 5. Start AeroSpace
```bash
# Start AeroSpace
open -a AeroSpace

# Or enable auto-start (optional)
# Edit aerospace.toml and set: start-at-login = true
```

### 6. Test Configuration
- Press `Alt+B` to test padding toggle
- Open Finder to verify it opens in floating mode
- Use `Alt+;` then `Esc` to reload configuration if needed

## Troubleshooting

- If key bindings don't work, ensure AeroSpace has Accessibility permissions
- If the toggle script fails, check that the script is executable: `ls -la toggle-padding.sh`
- Use `Alt+; Esc` to reload configuration after making changes