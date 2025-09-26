# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Cross-platform dotfiles repository managed with GNU Stow, supporting both macOS and Linux with platform-specific directories.

## GNU Stow Commands

### Platform-Specific Installation

```bash
# Navigate to dotfiles directory
cd ~/dotfiles

# For macOS
stow mac

# For Linux
stow linux

# Remove symlinks
stow -D mac    # macOS
stow -D linux  # Linux

# Restow (refresh) symlinks
stow --restow mac    # macOS
stow --restow linux  # Linux
```

### Advanced Options

```bash
# Dry run (preview changes)
stow -n -v mac
stow -n -v linux

# Verbose output
stow -v mac
stow -v linux

# Adopt existing files
stow --adopt mac
stow --adopt linux
```

## Repository Structure

```
~/dotfiles/
├── mac/                      # macOS-specific dotfiles
│   ├── .alacritty.toml      → ~/.alacritty.toml
│   ├── .bashrc              → ~/.bashrc
│   ├── .bash_profile        → ~/.bash_profile
│   ├── .bash_aliases        → ~/.bash_aliases
│   ├── .gitconfig           → ~/.gitconfig
│   └── .gitignore_global    → ~/.gitignore_global
├── linux/                    # Linux-specific dotfiles
│   ├── .alacritty.toml      → ~/.alacritty.toml
│   ├── .bashrc              → ~/.bashrc
│   ├── .bash_aliases        → ~/.bash_aliases
│   ├── .gitconfig           → ~/.gitconfig
│   └── .gitignore_global    → ~/.gitignore_global
├── scripts/                  # Helper scripts (not stowed)
├── README.md                 # Documentation (not stowed)
└── CLAUDE.md                 # This file (not stowed)
```

## Platform Differences

### macOS Directory (`mac/`)
- Contains `.bash_profile` for Terminal.app
- `.bashrc` includes Homebrew configuration
- Uses macOS-specific `LSCOLORS`

### Linux Directory (`linux/`)
- No `.bash_profile` (most Linux systems use `.bashrc` directly)
- `.bashrc` uses dircolors for color support
- No Homebrew references

## Adding New Dotfiles

### For macOS
```bash
cp ~/.newconfig ~/dotfiles/mac/.newconfig
cd ~/dotfiles
stow --restow mac
```

### For Linux
```bash
cp ~/.newconfig ~/dotfiles/linux/.newconfig
cd ~/dotfiles
stow --restow linux
```

## Automatic Platform Detection

Use this snippet for automatic platform detection:
```bash
cd ~/dotfiles
if [[ "$OSTYPE" == "darwin"* ]]; then
    stow mac
else
    stow linux
fi
```

## Best Practices

- Keep platform-specific configurations separate
- Test changes with `stow -n` before applying
- Use `stow --adopt` to incorporate existing dotfiles
- Maintain parity between platforms where possible
- Document platform-specific differences clearly