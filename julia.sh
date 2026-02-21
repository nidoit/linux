#!/bin/bash
# Julia Installation Script
set -e

# Check if already installed
if command -v julia &> /dev/null; then
    echo "julia is already installed!"
    julia --version
    exit 0
fi

echo "Installing julia..."
curl -fsSL https://install.julialang.org | sh -s -- -y
echo "julia installed successfully!"
echo "Please restart your shell or source your profile for julia to be available."
