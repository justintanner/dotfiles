#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/dotfiles"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}→${NC} $1"
}

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    print_error "This installer is for macOS only"
    exit 1
fi

print_info "Starting dotfiles installation..."

# Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    print_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for this session
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    print_success "Homebrew already installed"
fi

# Update Homebrew
print_info "Updating Homebrew..."
brew update

# Install essential packages
print_info "Installing essential packages..."

PACKAGES=(
    "stow"           # Symlink manager
    "git"            # Version control
    "bash"           # Latest bash
    "bash-completion" # Bash completions
    "mise"           # Runtime version manager
    "alacritty"      # Terminal emulator
    "bat"            # Better cat
    "eza"            # Better ls
    "ripgrep"        # Better grep
    "fd"             # Better find
    "gh"             # GitHub CLI
    "jq"             # JSON processor
    "tree"           # Directory tree
    "wget"           # Download utility
    "curl"           # Transfer utility
)

for package in "${PACKAGES[@]}"; do
    if brew list "$package" &>/dev/null; then
        print_success "$package already installed"
    else
        print_info "Installing $package..."
        brew install "$package"
        print_success "$package installed"
    fi
done

# Install fonts
print_info "Installing JetBrains Mono Nerd Font..."
brew tap homebrew/cask-fonts 2>/dev/null || true
if brew list --cask font-jetbrains-mono-nerd-font &>/dev/null; then
    print_success "JetBrains Mono Nerd Font already installed"
else
    brew install --cask font-jetbrains-mono-nerd-font
    print_success "JetBrains Mono Nerd Font installed"
fi

# Clone or update dotfiles repository
if [[ ! -d "$DOTFILES_DIR" ]]; then
    print_error "Dotfiles directory not found at $DOTFILES_DIR"
    print_info "Please clone the dotfiles repository first:"
    echo "  git clone <your-dotfiles-repo> $DOTFILES_DIR"
    exit 1
fi

# Backup existing dotfiles
print_info "Backing up existing dotfiles..."
mkdir -p "$HOME/.dotfiles_backup"

backup_file() {
    local file="$1"
    if [[ -e "$HOME/$file" && ! -L "$HOME/$file" ]]; then
        mv "$HOME/$file" "$HOME/.dotfiles_backup/$(basename $file).$(date +%Y%m%d_%H%M%S)"
        print_info "Backed up $file"
    fi
}

# Backup common dotfiles
backup_file ".bashrc"
backup_file ".bash_profile"
backup_file ".bash_aliases"
backup_file ".gitconfig"
backup_file ".gitignore_global"
backup_file ".alacritty.toml"

# Use GNU Stow to create symlinks
print_info "Creating symlinks with Stow..."

cd "$DOTFILES_DIR"

# Stow packages
STOW_PACKAGES=("alacritty" "bash" "git")

for package in "${STOW_PACKAGES[@]}"; do
    if [[ -d "$package" ]]; then
        print_info "Stowing $package..."
        stow -v --restow --target="$HOME" "$package"
        print_success "$package stowed"
    else
        print_error "Package directory $package not found"
    fi
done

# Stow mise if directory exists
if [[ -d "mise" ]]; then
    print_info "Stowing mise configuration..."
    mkdir -p "$HOME/.config"
    stow -v --restow --target="$HOME/.config" --dir="$DOTFILES_DIR/mise" .
    print_success "mise configuration stowed"
fi

# Add bin directory to PATH if it exists
if [[ -d "$DOTFILES_DIR/bin" ]]; then
    print_success "bin directory found - will be added to PATH via .bashrc"
fi

# Set up default shell
print_info "Setting up default shell..."
BREW_BASH="/opt/homebrew/bin/bash"
if [[ -f "$BREW_BASH" ]]; then
    # Add Homebrew bash to allowed shells if not already there
    if ! grep -q "$BREW_BASH" /etc/shells; then
        print_info "Adding $BREW_BASH to /etc/shells..."
        echo "$BREW_BASH" | sudo tee -a /etc/shells > /dev/null
    fi

    # Ask if user wants to change default shell
    read -p "Do you want to set $BREW_BASH as your default shell? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        chsh -s "$BREW_BASH"
        print_success "Default shell changed to $BREW_BASH"
    fi
else
    print_error "Homebrew bash not found at $BREW_BASH"
fi

print_success "Dotfiles installation complete!"
print_info "Please restart your terminal or run: source ~/.bashrc"

# Final instructions
echo ""
echo "Next steps:"
echo "1. Configure git with your name and email:"
echo "   git config --global user.name \"Your Name\""
echo "   git config --global user.email \"your.email@example.com\""
echo ""
echo "2. Install Ruby using mise:"
echo "   mise use --global ruby@3.3"
echo ""
echo "3. Customize your local settings by creating:"
echo "   ~/.bashrc.local"