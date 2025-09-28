# AGENTS.md

Guidance for coding agents working with this dotfiles repository.

## Commands

- **Setup:** `stow mac` (macOS) or `stow linux` (Linux) - Symlink platform-specific dotfiles
- **Uninstall:** `stow -D mac` or `stow -D linux` - Remove symlinks
- **Restow:** `stow --restow mac` or `stow --restow linux` - Refresh symlinks
- **Preview:** `stow -n -v mac` or `stow -n -v linux` - Dry run with verbose output
- **Adopt:** `stow --adopt mac` or `stow --adopt linux` - Incorporate existing files
- **Full install:** `scripts/install.sh` (macOS only) - Complete environment setup

## Repository Structure

- `mac/` - macOS-specific dotfiles (.bashrc, .bash_profile, .alacritty.toml, .gitconfig, etc.)
- `linux/` - Linux-specific dotfiles (.bashrc, .alacritty.toml, .gitconfig, etc.)
- `scripts/` - Helper scripts including full macOS installation script
- `CLAUDE.md` - Detailed documentation for Claude Code usage

## Code Style

- Shell scripts use `#!/usr/bin/env bash` shebang
- Variables in ALL_CAPS for constants, lowercase for locals
- Use double quotes for variables, single quotes for literal strings
- Platform detection with `if [[ "$OSTYPE" == "darwin"* ]]`
- Files follow standard dotfile conventions (hidden files starting with `.`)
