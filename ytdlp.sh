#!/bin/bash
# yt-dlp Installation Script
set -e

# Check if already installed
if pacman -Qi yt-dlp &>/dev/null; then
    echo "yt-dlp is already installed!"
    exit 0
fi

# Cache sudo credentials upfront (only 1 prompt)
sudo -v
# Keep sudo alive throughout the script
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPER=$!

echo "Installing yt-dlp..."
sudo pacman -S yt-dlp --noconfirm
kill $SUDO_KEEPER 2>/dev/null
echo "yt-dlp installed successfully!"
