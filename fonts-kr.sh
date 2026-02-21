#!/bin/bash
# Korean Fonts Installation Script
set -e

# Cache sudo credentials upfront (only 1 prompt)
sudo -v
# Keep sudo alive throughout the script
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
SUDO_KEEPER=$!

echo "Installing Korean fonts..."
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
  spoqa-han-sans \
  ttf-d2coding \
  ttf-nanum \
  ttf-kopub \
  otf-kopub \
  otf-pretendard \
  adobe-source-han-sans-kr-fonts \
  adobe-source-han-serif-kr-fonts \
  noto-fonts-cjk
kill $SUDO_KEEPER 2>/dev/null

echo "Refreshing font cache..."
fc-cache -fv

echo "Verifying Korean fonts are available..."
fc-list :lang=ko

echo "Korean fonts installed successfully!"
