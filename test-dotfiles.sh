#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "======================================"
echo "Dotfiles Docker Test Environment"
echo "======================================"
echo ""

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Build the Docker image
print_step "Building Docker image..."
docker build -t dotfiles-ubuntu-test .
print_success "Docker image built successfully"
echo ""

# Ask user what they want to do
echo "Choose an option:"
echo "  1) Run interactive bash shell (default)"
echo "  2) Run tests and verification"
echo "  3) Both (verify then drop to shell)"
echo ""
read -p "Enter choice [1-3] (default: 1): " choice
choice=${choice:-1}

case $choice in
    1)
        print_step "Starting interactive shell..."
        docker run -it --rm \
            -v "$(pwd)/linux:/root/dotfiles/linux" \
            dotfiles-ubuntu-test
        ;;
    2)
        print_step "Running verification tests..."
        docker run --rm \
            -v "$(pwd)/linux:/root/dotfiles/linux" \
            dotfiles-ubuntu-test \
            /bin/bash -c '
                echo "Testing dotfiles configuration..."
                echo ""

                # Check if stow created symlinks
                echo "Checking symlinks..."
                if [ -L ~/.bashrc ]; then
                    echo "✓ .bashrc is symlinked"
                else
                    echo "✗ .bashrc is NOT symlinked"
                    exit 1
                fi

                if [ -L ~/.inputrc ]; then
                    echo "✓ .inputrc is symlinked"
                else
                    echo "✗ .inputrc is NOT symlinked"
                    exit 1
                fi

                # Source bashrc and check mise
                echo ""
                echo "Checking mise installation..."
                source ~/.bashrc
                if command -v mise &> /dev/null; then
                    echo "✓ mise is available"
                    mise --version
                else
                    echo "✗ mise is NOT available"
                    exit 1
                fi

                # Check Ruby
                echo ""
                echo "Checking Ruby installation..."
                if command -v ruby &> /dev/null; then
                    echo "✓ Ruby is installed"
                    ruby --version
                else
                    echo "✗ Ruby is NOT installed"
                    exit 1
                fi

                # Check Node
                echo ""
                echo "Checking Node installation..."
                if command -v node &> /dev/null; then
                    echo "✓ Node is installed"
                    node --version
                else
                    echo "✗ Node is NOT installed"
                    exit 1
                fi

                # Check oh-my-posh
                echo ""
                echo "Checking oh-my-posh..."
                if command -v oh-my-posh &> /dev/null; then
                    echo "✓ oh-my-posh is installed"
                    oh-my-posh --version
                else
                    echo "! oh-my-posh is NOT installed (optional)"
                fi

                # Test bash aliases
                echo ""
                echo "Checking bash aliases..."
                source ~/.bash_aliases 2>/dev/null || true
                if alias ll &> /dev/null; then
                    echo "✓ Aliases loaded successfully"
                else
                    echo "! Aliases may not be loaded"
                fi

                echo ""
                echo "========================================"
                echo "All tests passed! ✓"
                echo "========================================"
            '
        print_success "Verification complete!"
        ;;
    3)
        print_step "Running verification tests..."
        docker run --rm \
            -v "$(pwd)/linux:/root/dotfiles/linux" \
            dotfiles-ubuntu-test \
            /bin/bash -c '
                source ~/.bashrc
                echo "Mise version: $(mise --version)"
                echo "Ruby version: $(ruby --version)"
                echo "Node version: $(node --version)"
                echo ""
                echo "All tools verified!"
            '
        print_success "Verification complete!"
        echo ""
        print_step "Starting interactive shell..."
        docker run -it --rm \
            -v "$(pwd)/linux:/root/dotfiles/linux" \
            dotfiles-ubuntu-test
        ;;
    *)
        print_error "Invalid choice"
        exit 1
        ;;
esac
