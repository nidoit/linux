#!/bin/bash
# Samba Installation Script
set -e

# Check if already installed
if pacman -Qi samba &>/dev/null; then
    echo "samba is already installed!"
    exit 0
fi

# Cache sudo credentials upfront (only 1 prompt)
sudo -v
# Keep sudo alive throughout the script
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPER=$!

echo "Installing samba..."
sudo pacman -S samba --noconfirm
sudo systemctl enable --now smb nmb
kill $SUDO_KEEPER 2>/dev/null
echo "samba installed and enabled successfully!"
