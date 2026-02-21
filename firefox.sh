#!/bin/bash
# Firefox Developer Edition (Korean) Installation Script
set -e

# Check if already installed
if pacman -Qi firefox-developer-edition-i18n-ko &>/dev/null; then
    echo "firefox-developer-edition-i18n-ko is already installed!"
    exit 0
fi

# Cache sudo credentials upfront (only 1 prompt)
sudo -v
# Keep sudo alive throughout the script
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPER=$!

echo "Installing firefox-developer-edition-i18n-ko..."
sudo pacman -S firefox-developer-edition-i18n-ko --noconfirm
kill $SUDO_KEEPER 2>/dev/null
echo "firefox-developer-edition-i18n-ko installed successfully!"
