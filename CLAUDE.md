# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles repository managed with GNU Stow. All configuration files are placed directly in the repository root and stowed to the home directory.

## GNU Stow Commands

### Basic Usage

```bash
# Navigate to dotfiles directory
cd ~/dotfiles

# Create all symlinks
stow .

# Remove all symlinks
stow -D .

# Restow (refresh) all symlinks
stow --restow .
```

### Advanced Options

```bash
# Dry run (preview changes without making them)
stow -n -v .

# Verbose output (see what's being linked)
stow -v .

# Adopt existing files (move them into dotfiles)
stow --adopt .

# Ignore specific patterns
stow --ignore='scripts|README|CLAUDE' .
```

## Repository Structure

```
~/dotfiles/
├── .alacritty.toml   → ~/.alacritty.toml
├── .bashrc           → ~/.bashrc
├── .bash_profile     → ~/.bash_profile
├── .bash_aliases     → ~/.bash_aliases
├── .gitconfig        → ~/.gitconfig
├── .gitignore_global → ~/.gitignore_global
├── scripts/          (not stowed)
├── README.md         (not stowed)
└── CLAUDE.md         (not stowed)
```

## Adding New Dotfiles

1. Place the dotfile directly in `~/dotfiles/`:
```bash
cp ~/.vimrc ~/dotfiles/.vimrc
```

2. Stow to create the symlink:
```bash
cd ~/dotfiles
stow .
```

## Excluding Files from Stowing

Create a `.stow-local-ignore` file to exclude files:
```
# Exclude documentation and scripts
README.*
CLAUDE.*
scripts
\.git
\.idea
```

## Best Practices

- Keep all dotfiles in the repository root
- Use `.stow-local-ignore` to exclude non-dotfiles
- Run `stow -n .` to preview changes before applying
- Use `stow --adopt .` to incorporate existing dotfiles