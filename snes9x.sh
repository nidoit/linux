#!/bin/bash
# SNES9X Installation Script
set -e

# Check if already installed
if pacman -Qi snes9x-gtk &>/dev/null; then
    echo "snes9x-gtk is already installed!"
    exit 0
fi

# Cache sudo credentials upfront (only 1 prompt)
sudo -v
# Keep sudo alive throughout the script
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPER=$!

echo "Installing snes9x-gtk..."
sudo pacman -S snes9x-gtk --noconfirm
kill $SUDO_KEEPER 2>/dev/null
echo "snes9x-gtk installed successfully!"
