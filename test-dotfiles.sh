#!/usr/bin/env bash
# Build the Ubuntu test image and verify that scripts/install.sh produces
# real files (not symlinks) and that mise / Ruby / Node / oh-my-posh work.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_step()    { echo -e "${BLUE}==>${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}!${NC} $1"; }
print_error()   { echo -e "${RED}✗${NC} $1"; }

print_step "Building Docker image..."
docker build -t dotfiles-ubuntu-test .
print_success "Image built"
echo

echo "Choose an option:"
echo "  1) Run interactive bash shell (default)"
echo "  2) Run verification tests"
echo "  3) Both (verify, then drop to shell)"
echo
read -p "Enter choice [1-3] (default: 1): " choice
choice=${choice:-1}

VERIFY_CMD='
    set -e
    echo "Verifying dotfiles install..."
    # Must be real files, not symlinks
    for f in .bashrc .bash_profile .bash_init .bash_aliases .gitconfig; do
        if [ -L "$HOME/$f" ]; then
            echo "✗ $f is a SYMLINK (should be real file)"; exit 1
        fi
        if [ ! -f "$HOME/$f" ]; then
            echo "✗ $f is missing"; exit 1
        fi
        echo "✓ $f is a real file"
    done

    source ~/.bashrc

    if command -v mise &>/dev/null; then echo "✓ mise: $(mise --version)"; else echo "✗ mise missing"; exit 1; fi
    if command -v ruby &>/dev/null; then echo "✓ ruby: $(ruby --version)"; else echo "✗ ruby missing"; exit 1; fi
    if command -v node &>/dev/null; then echo "✓ node: $(node --version)"; else echo "✗ node missing"; exit 1; fi

    if command -v oh-my-posh &>/dev/null; then echo "✓ oh-my-posh: $(oh-my-posh --version)"; else echo "! oh-my-posh missing (optional)"; fi

    echo "All tests passed."
'

case "$choice" in
    1)
        print_step "Starting interactive shell..."
        docker run -it --rm \
            -v "$(pwd)/linux:/root/dotfiles/linux" \
            -v "$(pwd)/scripts:/root/dotfiles/scripts" \
            dotfiles-ubuntu-test
        ;;
    2)
        print_step "Running verification..."
        docker run --rm \
            -v "$(pwd)/linux:/root/dotfiles/linux" \
            -v "$(pwd)/scripts:/root/dotfiles/scripts" \
            dotfiles-ubuntu-test \
            /bin/bash -c "$VERIFY_CMD"
        print_success "Verification complete"
        ;;
    3)
        print_step "Running verification..."
        docker run --rm \
            -v "$(pwd)/linux:/root/dotfiles/linux" \
            -v "$(pwd)/scripts:/root/dotfiles/scripts" \
            dotfiles-ubuntu-test \
            /bin/bash -c "$VERIFY_CMD"
        print_success "Verification complete"
        echo
        print_step "Starting interactive shell..."
        docker run -it --rm \
            -v "$(pwd)/linux:/root/dotfiles/linux" \
            -v "$(pwd)/scripts:/root/dotfiles/scripts" \
            dotfiles-ubuntu-test
        ;;
    *)
        print_error "Invalid choice"
        exit 1
        ;;
esac
