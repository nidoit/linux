#!/bin/bash
# LibreOffice Fresh (Korean) Installation Script
set -e

# Check if already installed
if pacman -Qi libreoffice-fresh &>/dev/null; then
    echo "libreoffice-fresh is already installed!"
    exit 0
fi

# Cache sudo credentials upfront (only 1 prompt)
sudo -v
# Keep sudo alive throughout the script
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPER=$!

echo "Installing libreoffice-fresh and libreoffice-fresh-ko..."
sudo pacman -S libreoffice-fresh libreoffice-fresh-ko --noconfirm
kill $SUDO_KEEPER 2>/dev/null
echo "libreoffice-fresh installed successfully!"
