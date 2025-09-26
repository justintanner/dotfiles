# Dotfiles

Personal dotfiles for macOS managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Features

- 🔗 Symlink management via GNU Stow
- 🍎 macOS optimized configuration
- 🚀 Simple installation script
- 📦 Modular package structure
- 🛠️ Developer-friendly tools and aliases

## Quick Start

1. Clone this repository:
```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. Run the installation script:
```bash
./install.sh
```

3. Restart your terminal or reload configuration:
```bash
source ~/.bashrc
```

## What's Included

### Packages

- **alacritty** - Modern terminal emulator configuration
- **bash** - Shell configuration, aliases, and prompt
- **git** - Global git configuration and aliases

### Tools Installed

The installation script will install these essential tools via Homebrew:

- `stow` - Symlink farm manager
- `bash` - Latest Bash shell
- `mise` - Runtime version manager (for Ruby, Node.js, etc.)
- `alacritty` - GPU-accelerated terminal
- `bat` - Better `cat` with syntax highlighting
- `eza` - Modern replacement for `ls`
- `ripgrep` - Fast text search
- `fd` - User-friendly alternative to `find`
- `gh` - GitHub CLI
- `jq` - Command-line JSON processor

## Directory Structure

```
dotfiles/
├── alacritty/          # Terminal emulator config
│   └── .alacritty.toml
├── bash/               # Shell configuration
│   ├── .bashrc
│   ├── .bash_profile
│   └── .bash_aliases
├── git/                # Git configuration
│   ├── .gitconfig
│   └── .gitignore_global
├── bin/                # Custom scripts (optional)
├── install.sh          # Installation script
└── README.md           # This file
```

## Manual Setup

If you prefer to set things up manually:

### 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Install GNU Stow

```bash
brew install stow
```

### 3. Stow individual packages

```bash
cd ~/dotfiles
stow alacritty
stow bash
stow git
```

## Customization

### Local Configuration

Create `~/.bashrc.local` for machine-specific configuration that won't be committed to the repository:

```bash
# ~/.bashrc.local
export PRIVATE_API_KEY="your-key-here"
alias work='cd ~/work/projects'
```

### Adding New Packages

1. Create a new directory for your package:
```bash
mkdir -p ~/dotfiles/package-name
```

2. Add configuration files following the home directory structure:
```bash
# For a file that should be at ~/.config/app/config
mkdir -p ~/dotfiles/app/.config/app
touch ~/dotfiles/app/.config/app/config
```

3. Stow the new package:
```bash
cd ~/dotfiles
stow app
```

### Modifying Existing Configurations

Edit files directly in the `~/dotfiles` directory. Changes will be immediately reflected since Stow creates symlinks.

## Uninstalling

To remove all symlinks:

```bash
cd ~/dotfiles
stow -D alacritty
stow -D bash
stow -D git
```

To completely uninstall, remove the symlinks first, then delete the dotfiles directory:

```bash
rm -rf ~/dotfiles
```

## Updating

Pull the latest changes and re-stow:

```bash
cd ~/dotfiles
git pull
stow --restow alacritty bash git
```

## Troubleshooting

### Stow Conflicts

If Stow reports conflicts, it means files already exist at the target location. You can:

1. Back up and remove the existing files:
```bash
mv ~/.bashrc ~/.bashrc.backup
```

2. Or force restow (overwrites existing symlinks):
```bash
stow --adopt package-name
```

### Permission Issues

If you encounter permission issues:

```bash
sudo chown -R $(whoami) ~/dotfiles
```

## Contributing

Feel free to fork and customize these dotfiles for your own use!

## License

MIT