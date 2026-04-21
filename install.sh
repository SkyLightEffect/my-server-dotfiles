#!/bin/bash
set -e

# lsd ist wieder drin!
PACKAGES="sudo zsh vim make curl tmux progress fd wget lsd"

echo "Checking system requirements and permissions..."

if [ "$(id -u)" -ne 0 ]; then
  echo "Error: This script must be run as root (or via sudo)."
  exit 1
fi

if command -v pacman > /dev/null; then
  echo "Detected Arch Linux. Installing packages via pacman..."
  pacman -Sy --noconfirm
  pacman -S --noconfirm $PACKAGES gping fd
elif command -v apt > /dev/null; then
  echo "Detected Debian/Ubuntu. Installing packages via apt..."
  apt-get update -y
  apt-get install -y $PACKAGES gping fd-find
  if [ ! -L /usr/local/bin/fd ] && [ -f /usr/lib/cargo/bin/fd ]; then
    ln -s /usr/lib/cargo/bin/fd /usr/local/bin/fd || true
  fi
else
  echo "No supported package manager found."
  exit 1
fi

echo "Installing pfetch directly..."
curl -sL "https://raw.githubusercontent.com/dylanaraps/pfetch/master/pfetch" -o /usr/local/bin/pfetch
chmod +x /usr/local/bin/pfetch

echo "Package installation complete!"
