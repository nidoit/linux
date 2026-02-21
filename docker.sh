#!/bin/bash
# Docker Installation Script
set -e

# Check if already installed
if pacman -Qi docker &>/dev/null; then
    echo "docker is already installed!"
    exit 0
fi

# Cache sudo credentials upfront (only 1 prompt)
sudo -v
# Keep sudo alive throughout the script
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPER=$!

echo "Installing docker and docker-compose..."
sudo pacman -S docker docker-compose --noconfirm
sudo systemctl enable --now docker
kill $SUDO_KEEPER 2>/dev/null
echo "docker installed successfully!"
echo "Please log out and log back in for group changes to take effect."
