#!/bin/bash
# Nerd Fonts Installation Script
set -e

# Cache sudo credentials upfront (only 1 prompt)
sudo -v
# Keep sudo alive throughout the script
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPER=$!

echo "Installing Nerd Fonts..."
if ! command -v yay &> /dev/null; then
    echo "Installing yay first..."
    BUILDDIR=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$BUILDDIR/yay-bin"
    cd "$BUILDDIR/yay-bin"
    makepkg -si --noconfirm
    cd /
    rm -rf "$BUILDDIR"
fi
yay -S --needed --noconfirm \
  ttf-nerd-fonts-symbols-mono \
  ttf-roboto \
  ttf-roboto-mono-nerd \
  noto-fonts-cjk
kill $SUDO_KEEPER 2>/dev/null

echo "Refreshing font cache..."
fc-cache -fv

echo "Nerd Fonts installed successfully!"
