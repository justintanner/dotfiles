# Dotfiles

Cross-platform dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/), supporting both macOS and Linux.

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

# Linux (Arch)
pacman -S stow
```

### Setup

1. Clone repository to home directory:
```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. Stow platform-specific configurations:

**For macOS:**
```bash
stow mac
```

**For Linux:**
```bash
stow linux
```

## Structure

```
dotfiles/
├── mac/                 # macOS-specific dotfiles
│   ├── .alacritty.toml
│   ├── .bashrc
│   ├── .bash_profile
│   ├── .bash_aliases
│   ├── .gitconfig
│   └── .gitignore_global
├── linux/               # Linux-specific dotfiles
│   ├── .alacritty.toml
│   ├── .bashrc
│   ├── .bash_aliases
│   ├── .gitconfig
│   └── .gitignore_global
├── scripts/             # Helper scripts
├── README.md
└── CLAUDE.md
```

## Usage

### Managing Dotfiles

```bash
# Stow platform configs
stow mac      # macOS
stow linux    # Linux

# Remove symlinks
stow -D mac
stow -D linux

# Restow (refresh) symlinks
stow --restow mac
stow --restow linux

# Dry run (preview changes)
stow -n -v mac
stow -n -v linux

# Adopt existing files
stow --adopt mac
stow --adopt linux
```

### Adding New Dotfiles

**For macOS:**
```bash
cp ~/.vimrc ~/dotfiles/mac/.vimrc
cd ~/dotfiles
stow --restow mac
```

**For Linux:**
```bash
cp ~/.vimrc ~/dotfiles/linux/.vimrc
cd ~/dotfiles
stow --restow linux
```

### Automatic Platform Detection

```bash
# Install based on detected OS
cd ~/dotfiles
if [[ "$OSTYPE" == "darwin"* ]]; then
    stow mac
else
    stow linux
fi
```

## Platform Differences

### macOS (`mac/`)
- Includes `.bash_profile` for Terminal.app compatibility
- Homebrew configuration in `.bashrc`
- macOS-specific color settings

### Linux (`linux/`)
- No `.bash_profile` (uses `.bashrc` directly)
- Linux-specific color support with dircolors
- No Homebrew configuration

## Troubleshooting

### Check for conflicts
```bash
stow -n -v mac 2>&1 | grep -E 'CONFLICT|WARNING'
stow -n -v linux 2>&1 | grep -E 'CONFLICT|WARNING'
```

### Force adoption of existing files
```bash
stow --adopt mac    # macOS
stow --adopt linux  # Linux
```

### Clean and restow
```bash
# macOS
stow -D mac && stow mac

# Linux
stow -D linux && stow linux
```
