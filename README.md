# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Installation

### Prerequisites

Install GNU Stow:
```bash
# macOS (via Homebrew)
brew install stow

# Linux (Debian/Ubuntu)
apt-get install stow

# Linux (Fedora)
dnf install stow
```

### Setup

1. Clone repository to home directory:
```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. Create symlinks:
```bash
stow .
```

That's it! All dotfiles are now symlinked to your home directory.

## Usage

### Managing Dotfiles

```bash
# Create all symlinks
stow .

# Remove all symlinks
stow -D .

# Restow (refresh) all symlinks
stow --restow .

# Dry run (preview changes)
stow -n -v .

# Adopt existing files into repo
stow --adopt .
```

### Adding New Dotfiles

1. Copy your dotfile to the repository:
```bash
cp ~/.vimrc ~/dotfiles/.vimrc
```

2. Restow to create symlink:
```bash
cd ~/dotfiles
stow --restow .
```

3. Commit changes:
```bash
git add .vimrc
git commit -m "Add .vimrc"
```

## Structure

All dotfiles are placed directly in the repository root:

```
dotfiles/
├── .alacritty.toml
├── .bashrc
├── .bash_profile
├── .bash_aliases
├── .gitconfig
├── .gitignore_global
├── scripts/         # Helper scripts (not stowed)
├── README.md        # This file (not stowed)
└── CLAUDE.md        # AI instructions (not stowed)
```

## Troubleshooting

### Check for conflicts
```bash
stow -n -v . 2>&1 | grep -E 'CONFLICT|WARNING'
```

### Force adoption of existing files
```bash
stow --adopt .
```

### Clean and restow
```bash
stow -D . && stow .
```

## Notes

- Dotfiles are symlinked directly from the repository root to `~`
- Non-dotfiles (README, scripts, etc.) are automatically ignored by Stow
- Use `.stow-local-ignore` to exclude additional files if needed
