#!/bin/bash
# KIME Installation Script
set -e

# Check if already installed
if pacman -Qi kime-git &>/dev/null; then
    echo "kime-git is already installed!"
    echo "Please log out and log back in if you haven't already."
    exit 0
fi

# Cache sudo credentials upfront (only 1 prompt)
sudo -v
# Keep sudo alive throughout the script
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPER=$!

echo "Installing kime-git..."
if ! command -v yay &> /dev/null; then
    echo "Installing yay first..."
    BUILDDIR=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$BUILDDIR/yay-bin"
    cd "$BUILDDIR/yay-bin"
    makepkg -si --noconfirm
    cd /
    rm -rf "$BUILDDIR"
fi
yay -S --noconfirm --needed kime-git
kill $SUDO_KEEPER 2>/dev/null
echo "kime-git installed successfully!"
echo "Please log out and log back in for changes to take effect."
