#!/bin/bash
set -e

DOT=~/.dotfiles
ZSH_PLUGINS=~/.zsh/plugins

echo "========================================"
echo "1. Starting system configuration (sudo required)..."
echo "========================================"

# Install packages FIRST
sudo bash "$DOT/install.sh"

# Safely optimize pacman.conf if on Arch Linux
if command -v pacman > /dev/null; then
  echo "Optimizing pacman.conf..."
  sudo cp /etc/pacman.conf /etc/pacman.conf.bak

  sudo sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf
  sudo sed -i 's/#Color/Color/' /etc/pacman.conf
  sudo sed -i 's/#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
  
  if ! grep -q '^ILoveCandy' /etc/pacman.conf; then
    sudo sed -i '/^Color/a ILoveCandy' /etc/pacman.conf
  fi
  echo "Pacman optimized."
fi

echo ""
echo "========================================"
echo "2. Starting user setup..."
echo "========================================"

# Safely change the default shell to zsh using command -v instead of which
if [[ "$SHELL" != */zsh ]]; then
  echo "Changing default shell to zsh..."
  sudo chsh -s "$(command -v zsh)" "$(whoami)"
fi

# Clone Zsh plugins
mkdir -p "$ZSH_PLUGINS"
if [ ! -d "$ZSH_PLUGINS/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGINS/zsh-syntax-highlighting"
fi
if [ ! -d "$ZSH_PLUGINS/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_PLUGINS/zsh-autosuggestions"
fi

# Setup Vim Plugin Manager (vim-plug)
mkdir -p ~/.vim/autoload ~/.vim/backups ~/.vim/undodir
if [ ! -f ~/.vim/autoload/plug.vim ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Install vim plugins
vim -es -u "$DOT/.vimrc" -i NONE -c "PlugInstall" -c "qa" || true

# Setup Tmux Plugin Manager (TPM)
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install fzf
if [ ! -d ~/.fzf ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all --key-bindings --completion --no-update-rc
fi

# Create symlinks
echo "Creating symlinks..."
ln -sf "$DOT/.zshrc" ~/.zshrc
ln -sf "$DOT/.gitconfig" ~/.gitconfig
ln -sf "$DOT/.vimrc" ~/.vimrc
ln -sf "$DOT/.tmux.conf" ~/.tmux.conf

mkdir -p ~/.config/lsd
[ -f "$DOT/.config/lsd/config.yaml" ] && ln -sf "$DOT/.config/lsd/config.yaml" ~/.config/lsd/config.yaml
[ -f "$DOT/.config/lsd/colors.yaml" ] && ln -sf "$DOT/.config/lsd/colors.yaml" ~/.config/lsd/colors.yaml

echo ""
echo "========================================"
echo "3. Setting up root warning prompt..."
echo "========================================"
ROOT_BASHRC="/root/.bashrc"
WARNING_PROMPT="PS1='\[\e[1;31m\][ROOT \u@\h \W]# \[\e[0m\]'"

if ! sudo grep -q "ROOT " "$ROOT_BASHRC" 2>/dev/null; then
  echo "$WARNING_PROMPT" | sudo tee -a "$ROOT_BASHRC" > /dev/null
fi

echo "All done! Initialization complete."
