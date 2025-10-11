#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

IMAGE_NAME="dotfiles-ubuntu-test"

echo "======================================"
echo "Building Dotfiles Test Image"
echo "======================================"
echo ""

# Build the Docker image
echo "Building Docker image..."
docker build -t "$IMAGE_NAME" .

echo ""
echo "======================================"
echo "Build complete!"
echo "======================================"
echo ""
echo "To run the container:"
echo "  docker run -it --rm $IMAGE_NAME"
echo ""
echo "To run with live volume mounting:"
echo "  docker run -it --rm -v \"\$(pwd)/linux:/root/dotfiles/linux\" $IMAGE_NAME"
echo ""
