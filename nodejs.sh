#!/bin/bash
# Node.js Installation Script
set -e

# Check if already installed
if pacman -Qi nodejs &>/dev/null; then
    echo "nodejs is already installed!"
    exit 0
fi

# Cache sudo credentials upfront (only 1 prompt)
sudo -v
# Keep sudo alive throughout the script
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPER=$!

echo "Installing nodejs and npm..."
sudo pacman -S nodejs npm --noconfirm
kill $SUDO_KEEPER 2>/dev/null
echo "nodejs installed successfully!"
