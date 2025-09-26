# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS, managed with GNU Stow for symlink management. The dotfiles are organized in a modular package structure where each tool has its own directory.

## Commands

### Installation and Setup
```bash
# Full installation (installs Homebrew packages and creates symlinks)
./install.sh

# Manual symlink management with Stow
cd ~/dotfiles
stow alacritty    # Symlink Alacritty config
stow bash         # Symlink Bash configs
stow git          # Symlink Git configs
stow --restow alacritty bash git  # Re-stow all packages

# Remove symlinks
stow -D alacritty
stow -D bash
stow -D git
```

### Adding New Packages
```bash
# Create new package directory following home directory structure
mkdir -p ~/dotfiles/package-name
# For ~/.config/app/config:
mkdir -p ~/dotfiles/app/.config/app
# Then stow the package
stow app
```

## Architecture

The repository uses GNU Stow to manage symlinks. Each package directory mirrors the home directory structure:
- Files in `bash/` like `.bashrc` get symlinked to `~/.bashrc`
- Files in `alacritty/` like `.alacritty.toml` get symlinked to `~/.alacritty.toml`
- Nested structures are preserved (e.g., `mise/.config/mise/` → `~/.config/mise/`)

Key components:
- **install.sh**: Automated installer that installs Homebrew, essential packages, and runs Stow
- **Package directories**: Each tool has its own directory with configs that mirror the home directory structure
- **Local customization**: Supports `~/.bashrc.local` for machine-specific configurations not tracked in git

## Important Notes

- This is a macOS-specific configuration (installer checks for Darwin)
- The installer backs up existing dotfiles to `~/.dotfiles_backup/` before creating symlinks
- Homebrew packages are automatically installed including: stow, bash, mise, alacritty, bat, eza, ripgrep, fd, gh, jq
- Custom scripts can be added to the `bin/` directory which is automatically added to PATH via `.bashrc`