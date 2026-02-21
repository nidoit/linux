#!/bin/bash
# VLC Installation Script
set -e

# Check if already installed
if pacman -Qi vlc &>/dev/null; then
    echo "vlc is already installed!"
    exit 0
fi

# Cache sudo credentials upfront (only 1 prompt)
sudo -v
# Keep sudo alive throughout the script
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPER=$!

echo "Installing vlc..."
sudo pacman -S vlc --noconfirm
kill $SUDO_KEEPER 2>/dev/null
echo "vlc installed successfully!"
