#!/bin/bash
set -e

DOT=~/.dotfiles
SCRIPTS=$DOT/scripts
TMP=$(mktemp -d)

# Check for root
if [ "$(id -u)" -ne 0 ]; then
  echo "Skipping package installation due to lack of permissions."
  exit 1
fi

# Check for package manager
if command -v pacman > /dev/null; then
  echo "Install arch packages via pacman..."
  chmod u+x "$DOT/.pacman.sh" && "$DOT/.pacman.sh"
elif command -v apt > /dev/null; then
  echo "Install apt packages..."
  chmod u+x "$DOT/.apt.sh" && "$DOT/.apt.sh"
  
  # install lsd
  curl -fLo "$TMP/lsd.deb" --create-dirs "https://github.com/Peltoche/lsd/releases/download/0.22.0/lsd_0.22.0_amd64.deb"
  dpkg -i "$TMP/lsd.deb"
  rm "$TMP/lsd.deb"
else
  echo "No supported package manager found. Exiting..."
  exit 1
fi

# install pfetch
chmod u+x "$DOT/.pfetch.sh" && "$DOT/.pfetch.sh" "$TMP"

rm -rf "$TMP"
