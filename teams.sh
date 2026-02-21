#!/bin/bash
# Teams for Linux Installation Script
set -e

# Check if already installed
if pacman -Qi teams-for-linux-bin &>/dev/null; then
    echo "teams-for-linux-bin is already installed!"
    exit 0
fi

# Cache sudo credentials upfront (only 1 prompt)
sudo -v
# Keep sudo alive throughout the script
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPER=$!

echo "Installing teams-for-linux-bin..."
if ! command -v yay &> /dev/null; then
    echo "Installing yay first..."
    BUILDDIR=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$BUILDDIR/yay-bin"
    cd "$BUILDDIR/yay-bin"
    makepkg -si --noconfirm
    cd /
    rm -rf "$BUILDDIR"
fi
yay -S teams-for-linux-bin --noconfirm
kill $SUDO_KEEPER 2>/dev/null
echo "teams-for-linux-bin installed successfully!"
