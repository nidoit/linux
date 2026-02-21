#!/bin/bash
# Rust Installation Script
set -e

# Check if already installed
if command -v rustc &> /dev/null; then
    echo "rust is already installed!"
    rustc --version
    exit 0
fi

echo "Installing rust via rustup..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
echo "rust installed successfully!"
echo "Please restart your shell or run 'source ~/.cargo/env' to use rust."
