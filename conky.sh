#!/bin/bash
# Conky Installation Script
set -e

# Check if already installed
if pacman -Qi conky &>/dev/null; then
    echo "conky is already installed!"
    exit 0
fi

# Cache sudo credentials upfront (only 1 prompt)
sudo -v
# Keep sudo alive throughout the script
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPER=$!

echo "Installing conky..."
sudo pacman -S conky --noconfirm
kill $SUDO_KEEPER 2>/dev/null
echo "conky installed successfully!"
