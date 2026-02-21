#!/bin/bash
# Transmission Remote GTK Installation Script
set -e

# Check if already installed
if pacman -Qi transmission-remote-gtk &>/dev/null; then
    echo "transmission-remote-gtk is already installed!"
    exit 0
fi

# Cache sudo credentials upfront (only 1 prompt)
sudo -v
# Keep sudo alive throughout the script
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPER=$!

echo "Installing transmission-remote-gtk..."
sudo pacman -S transmission-remote-gtk --noconfirm
kill $SUDO_KEEPER 2>/dev/null
echo "transmission-remote-gtk installed successfully!"
