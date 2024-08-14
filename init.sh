#!/bin/bash

DOT=~/.dotfiles
TMP=$DOT/.temp
ZSH_PLUGINS=~/.zsh/plugins

# Execute install.sh if run as root
if [ "$(id -u)" -eq 0 ]; then
  $DOT/install.sh
fi

mkdir -p "$TMP"

# zsh setup
if [ "$SHELL" != "/bin/zsh" ]; then
  chsh -s /bin/zsh
fi

# Install Zsh plugins
mkdir -p "$ZSH_PLUGINS"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGINS/zsh-syntax-highlighting/"
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_PLUGINS/zsh-autosuggestions"

# Vim plugin manager
mkdir -p ~/.vim/autoload
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -es -u $DOT/.vimrc -i NONE -c "PlugInstall" -c "qa"

mkdir -p ~/.vim/backups
mkdir -p ~/.vim/undodir

# Tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Create symlinks for dotfiles
ln -sf $DOT/.zshrc ~/.zshrc
ln -sf $DOT/.gitconfig ~/.gitconfig
ln -sf $DOT/.vimrc ~/.vimrc

mkdir -p ~/.config/lsd
ln -sf $DOT/.config/lsd/config.yaml ~/.config/lsd/config.yaml
# ln -sf $DOT/.config/lsd/themes/mytheme.yaml ~/.config/lsd/themes/mytheme.yaml
ln -sf $DOT/.config/lsd/colors.yaml ~/.config/lsd/colors.yaml

ln -sf $DOT/.tmux.conf ~/.tmux.conf
tmux source ~/.tmux.conf

# Clean up
rm -rf "$TMP"

# Pacman configuration optimization if running on Arch Linux
if command -v pacman > /dev/null; then
  echo "Optimizing pacman configuration..."

  # Prompt for root password if not running as root
  if [ "$(id -u)" -ne 0 ]; then
    echo "This script requires root privileges to modify pacman.conf. Please enter your password."
    exec sudo bash "$0" "$@"
  fi

  # Backup original pacman.conf
  cp /etc/pacman.conf /etc/pacman.conf.bak

  # Add/modify settings in pacman.conf
  sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf
  sed -i 's/#Color/Color/' /etc/pacman.conf
  sed -i 's/#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
  sed -i 's/# TotalDownload = 0/TotalDownload = 1/' /etc/pacman.conf
  
  # Ensure ILoveCandy is present
  if grep -q '^ILoveCandy' /etc/pacman.conf; then
    sed -i 's/^#\?ILoveCandy/ILoveCandy/' /etc/pacman.conf
  else
    echo "ILoveCandy" >> /etc/pacman.conf
  fi

  echo "Pacman configuration optimized with ILoveCandy."
fi
