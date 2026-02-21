#!/bin/bash
# Steam Installation Script
set -e

# Check if already installed
if pacman -Qi steam &>/dev/null; then
    echo "steam is already installed!"
    exit 0
fi

# Cache sudo credentials upfront (only 1 prompt)
sudo -v
# Keep sudo alive throughout the script
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPER=$!

echo "Installing steam..."
sudo pacman -S steam --noconfirm
kill $SUDO_KEEPER 2>/dev/null
echo "steam installed successfully!"
