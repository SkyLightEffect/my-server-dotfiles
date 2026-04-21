#!/bin/bash
set -e

# Define common server packages (Removed 'lsd' to avoid Nerd-Font rendering issues over SSH)
PACKAGES="sudo zsh vim make curl tmux progress fd wget"

echo "Checking system requirements and permissions..."

# Check if script is run as root (It should be, as init.sh calls it via sudo)
if [ "$(id -u)" -ne 0 ]; then
  echo "Error: This script must be run as root (or via sudo)."
  exit 1
fi

# Detect package manager and install packages
if command -v pacman > /dev/null; then
  echo "Detected Arch Linux. Installing packages via pacman..."
  
  # Update databases first to prevent 404 errors on fresh containers
  pacman -Sy --noconfirm
  
  # Install common packages + Arch specific ones (like gping, fd)
  pacman -S --noconfirm $PACKAGES gping fd

elif command -v apt > /dev/null; then
  echo "Detected Debian/Ubuntu. Installing packages via apt..."
  
  # Update lists
  apt-get update -y
  
  # Install common packages + Debian specific naming (fd-find)
  apt-get install -y $PACKAGES gping fd-find
  
  # Ensure fd is available as 'fd' on Debian
  if [ ! -L /usr/local/bin/fd ] && [ -f /usr/lib/cargo/bin/fd ]; then
    ln -s /usr/lib/cargo/bin/fd /usr/local/bin/fd || true
  fi

else
  echo "No supported package manager (pacman/apt) found. Exiting..."
  exit 1
fi

echo "Installing pfetch directly..."
# pfetch is just a simple bash script. No need to clone the whole repo and run make.
curl -sL "https://raw.githubusercontent.com/dylanaraps/pfetch/master/pfetch" -o /usr/local/bin/pfetch
chmod +x /usr/local/bin/pfetch

echo "Package installation complete!"
