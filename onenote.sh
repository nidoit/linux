#!/bin/bash
# P3X OneNote Installation Script
set -e

# Check if already installed
if pacman -Qi p3x-onenote-bin &>/dev/null; then
    echo "p3x-onenote-bin is already installed!"
    exit 0
fi

# Cache sudo credentials upfront (only 1 prompt)
sudo -v
# Keep sudo alive throughout the script
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPER=$!

echo "Installing p3x-onenote-bin..."
if ! command -v yay &> /dev/null; then
    echo "Installing yay first..."
    BUILDDIR=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$BUILDDIR/yay-bin"
    cd "$BUILDDIR/yay-bin"
    makepkg -si --noconfirm
    cd /
    rm -rf "$BUILDDIR"
fi
yay -S p3x-onenote-bin --noconfirm
kill $SUDO_KEEPER 2>/dev/null
echo "p3x-onenote-bin installed successfully!"
