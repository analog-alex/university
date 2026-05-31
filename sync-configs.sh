#!/bin/bash

# Config Sync Script
# Detects changes in system configuration files and syncs them to the repository

set -e

# Repository root (robust: prefers git toplevel, falls back to script dir; works when symlinked)
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || (cd "$(dirname "${BASH_SOURCE[0]}")" && pwd))"

# Dry-run mode (preview only, no filesystem mutations)
DRY_RUN=false

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Directory mappings for complete directory sync: system_dir:repo_dir
DIRECTORY_MAPPINGS=(
    "$HOME/.agents|.agents"
    "$HOME/.config/nvim|editors/nvim"
    "$HOME/.config/opencode|editors/opencode"
    "$HOME/.config/aerospace|window-managers/aerospace"
    "$HOME/.config/ghostty|terminals/ghostty"
    "$HOME/.config/fastfetch|system/fastfetch"
    "$HOME/.config/sketchybar|status-bars/sketchybar"
    "$HOME/.config/zed|editors/zed"
    "$HOME/.config/kitty|terminals/kitty"
)

# Individual file mappings for specific files: system_path:repo_path
CONFIG_MAPPINGS=(
    "$HOME/Library/Application Support/Cursor/User/keybindings.json|editors/cursor/keybindings.json"
)

# Oh My Posh files now live in ~/.config/oh-my-posh
OMP_SYSTEM_DIR="$HOME/.config/oh-my-posh"
OMP_REPO_DIR="terminals/oh-my-posh"

# Function to check if file exists and is readable
check_file_exists() {
    local file_path="$1"
    if [[ ! -f "$file_path" ]]; then
        return 1
    fi
    if [[ ! -r "$file_path" ]]; then
        print_warning "File exists but is not readable: $file_path"
        return 1
    fi
    return 0
}

# Function to ensure directory exists
ensure_directory() {
    local dir_path="$1"
    if [[ ! -d "$dir_path" ]]; then
        if [[ $DRY_RUN == true ]]; then
            print_status "[DRY-RUN] Would create directory: $dir_path"
        else
            print_status "Creating directory: $dir_path"
            mkdir -p "$dir_path"
        fi
    fi
}

# Safe wrappers that respect DRY_RUN (no mutations when dry-running)
safe_cp() {
    local src="$1"
    local dst="$2"
    if [[ $DRY_RUN == true ]]; then
        print_status "[DRY-RUN] Would copy: $src -> $dst"
    else
        cp "$src" "$dst"
    fi
}

safe_rm() {
    local path="$1"
    if [[ $DRY_RUN == true ]]; then
        print_status "[DRY-RUN] Would remove: $path"
    else
        rm "$path"
    fi
}

# Function to sync a single file
sync_file() {
    local system_file="$1"
    local repo_file="$2"
    local changes_detected=false

    if ! check_file_exists "$system_file"; then
        print_warning "System file not found: $system_file"
        return 1
    fi

    # Ensure the repository directory exists
    ensure_directory "$(dirname "$repo_file")"

    # Check if repo file exists
    if [[ ! -f "$repo_file" ]]; then
        print_status "New config file detected: $system_file"
        safe_cp "$system_file" "$repo_file"
        if [[ $DRY_RUN != true ]]; then print_success "Copied new file: $repo_file"; fi
        changes_detected=true
    else
        # Compare files
        if ! cmp -s "$system_file" "$repo_file"; then
            print_status "Changes detected in: $system_file"
            
            # Show diff
            echo "--- Repository version: $repo_file"
            echo "+++ System version: $system_file"
            diff -u "$repo_file" "$system_file" || true
            echo ""
            
            # Copy the updated file
            safe_cp "$system_file" "$repo_file"
            if [[ $DRY_RUN != true ]]; then print_success "Updated: $repo_file"; fi
            changes_detected=true
        fi
    fi

    return $([ "$changes_detected" = true ] && echo 0 || echo 1)
}

# Function to sync entire directory recursively
sync_directory() {
    local system_dir="$1"
    local repo_dir="$2"
    local changes_detected=false
    local dir_name="$(basename "$system_dir")"

    if [[ ! -d "$system_dir" ]]; then
        print_warning "$dir_name directory not found: $system_dir"
        return 1
    fi

    ensure_directory "$repo_dir"

    # Find all files in the system directory (excluding .git and other version control)
    while IFS= read -r -d '' system_file; do
        # Get relative path from the system directory
        local rel_path="${system_file#$system_dir/}"
        local repo_file="$repo_dir/$rel_path"
        
        # Skip version control directories and common temporary files
        if [[ "$rel_path" == .git/* ]] || [[ "$rel_path" == .svn/* ]] || [[ "$rel_path" == .hg/* ]] || [[ "$rel_path" == node_modules/* ]] || [[ "$rel_path" == */node_modules/* ]] || [[ "$rel_path" == *~ ]] || [[ "$rel_path" == *.bak ]] || [[ "$rel_path" == */.DS_Store ]]; then
            continue
        fi
        
        # Ensure the directory exists in repo
        ensure_directory "$(dirname "$repo_file")"
        
        if [[ ! -f "$repo_file" ]] || ! cmp -s "$system_file" "$repo_file"; then
            if [[ ! -f "$repo_file" ]]; then
                print_status "New $dir_name file: $rel_path"
            else
                print_status "Changes detected in $dir_name file: $rel_path"
                echo "--- Repository version: $repo_file"
                echo "+++ System version: $system_file"
                diff -u "$repo_file" "$system_file" || true
                echo ""
            fi
            
            safe_cp "$system_file" "$repo_file"
            if [[ $DRY_RUN != true ]]; then print_success "Updated: $repo_file"; fi
            changes_detected=true
        fi
    done < <(find "$system_dir" -type f -print0)

    return $([ "$changes_detected" = true ] && echo 0 || echo 1)
}

# Function to sync Oh My Posh files
sync_omp_themes() {
    local changes_detected=false

    if [[ ! -d "$OMP_SYSTEM_DIR" ]]; then
        print_warning "Oh My Posh directory not found: $OMP_SYSTEM_DIR"
        return 1
    fi

    ensure_directory "$OMP_REPO_DIR"

    # Sync top-level .omp.json files and the theme switcher script
    while IFS= read -r -d '' system_file; do
        local filename="$(basename "$system_file")"
        local repo_file="$OMP_REPO_DIR/$filename"
        
        if [[ ! -f "$repo_file" ]] || ! cmp -s "$system_file" "$repo_file"; then
            if [[ ! -f "$repo_file" ]]; then
                print_status "New Oh My Posh file: $filename"
            else
                print_status "Changes detected in Oh My Posh file: $filename"
                echo "--- Repository version: $repo_file"
                echo "+++ System version: $system_file"
                diff -u "$repo_file" "$system_file" || true
                echo ""
            fi
            
            safe_cp "$system_file" "$repo_file"
            if [[ $DRY_RUN != true ]]; then print_success "Updated: $repo_file"; fi
            changes_detected=true
        fi
    done < <(find "$OMP_SYSTEM_DIR" -maxdepth 1 -type f \( -name "*.omp.json" -o -name "switch-theme.sh" \) -print0)

    # Remove repo files that were deleted from ~/.config/oh-my-posh
    while IFS= read -r -d '' repo_file; do
        local filename="$(basename "$repo_file")"

        if [[ ! -f "$OMP_SYSTEM_DIR/$filename" ]]; then
            print_status "Removed Oh My Posh file: $filename"
            safe_rm "$repo_file"
            if [[ $DRY_RUN != true ]]; then print_success "Deleted: $repo_file"; fi
            changes_detected=true
        fi
    done < <(find "$OMP_REPO_DIR" -maxdepth 1 -type f \( -name "*.omp.json" -o -name "switch-theme.sh" \) -print0)

    return $([ "$changes_detected" = true ] && echo 0 || echo 1)
}

# Main execution
main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            -h|--help)
                echo "Usage: $(basename "$0") [--dry-run]"
                echo "  --dry-run   Preview changes without modifying any files"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Usage: $(basename "$0") [--dry-run]"
                exit 1
                ;;
        esac
    done

    cd "$REPO_ROOT" || { print_error "Failed to cd to repo root: $REPO_ROOT"; exit 1; }

    if [[ $DRY_RUN == true ]]; then
        print_status "Starting configuration sync (DRY RUN - no files will be modified)..."
    else
        print_status "Starting configuration sync..."
    fi
    local total_changes=false

    # Sync complete directories
    for mapping in "${DIRECTORY_MAPPINGS[@]}"; do
        system_dir="${mapping%|*}"
        repo_dir="${mapping#*|}"
        if sync_directory "$system_dir" "$repo_dir"; then
            total_changes=true
        fi
    done

    # Sync individual config files
    for mapping in "${CONFIG_MAPPINGS[@]}"; do
        system_file="${mapping%|*}"
        repo_file="${mapping#*|}"
        if sync_file "$system_file" "$repo_file"; then
            total_changes=true
        fi
    done

    # Sync Oh My Posh themes
    if sync_omp_themes; then
        total_changes=true
    fi

    # Summary
    echo ""
    if [[ $DRY_RUN == true ]]; then
        if [[ $total_changes == true ]]; then
            print_status "Dry run complete. Planned changes detected (nothing written)."
            print_status "Review planned changes with: git status && git diff"
        else
            print_status "Dry run complete. No changes would be made."
        fi
    else
        if [[ $total_changes == true ]]; then
            print_success "Configuration sync complete! Changes detected and updated."
            print_status "Review changes with: git status && git diff"
            print_status "To commit changes: git add . && git commit -m 'update configuration files'"
        else
            print_success "Configuration sync complete! No changes detected."
        fi
    fi
}

# Run main function
main "$@"
