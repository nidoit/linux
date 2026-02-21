#!/bin/bash
# Bluetooth Installation Script
set -e

# Check if already installed
if pacman -Qi bluez &>/dev/null; then
    echo "bluez is already installed!"
    exit 0
fi

# Cache sudo credentials upfront (only 1 prompt)
sudo -v
# Keep sudo alive throughout the script
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPER=$!

echo "Installing bluez and bluez-utils..."
sudo pacman -S bluez bluez-utils --noconfirm
sudo systemctl enable --now bluetooth
kill $SUDO_KEEPER 2>/dev/null
echo "bluetooth installed and enabled successfully!"
