#!/bin/bash
# GitHub CLI Installation Script
set -e

# Check if already installed
if pacman -Qi github-cli &>/dev/null; then
    echo "github-cli is already installed!"
    exit 0
fi

# Cache sudo credentials upfront (only 1 prompt)
sudo -v
# Keep sudo alive throughout the script
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPER=$!

echo "Installing github-cli..."
sudo pacman -S github-cli --noconfirm
kill $SUDO_KEEPER 2>/dev/null
echo "github-cli installed successfully!"
