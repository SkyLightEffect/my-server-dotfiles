#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status

DOT=~/.dotfiles
ZSH_PLUGINS=~/.zsh/plugins

echo "Starting user setup..."

# 1. Safely change the default shell to zsh
if [ "$SHELL" != "/usr/bin/zsh" ] && [ "$SHELL" != "/bin/zsh" ]; then
  echo "Changing default shell to zsh..."
  sudo chsh -s /usr/bin/zsh "$(whoami)"
fi

# 2. Clone Zsh plugins (idempotent, checks if directory already exists)
mkdir -p "$ZSH_PLUGINS"
if [ ! -d "$ZSH_PLUGINS/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGINS/zsh-syntax-highlighting"
fi
if [ ! -d "$ZSH_PLUGINS/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_PLUGINS/zsh-autosuggestions"
fi

# 3. Setup Vim Plugin Manager (vim-plug) and directories
mkdir -p ~/.vim/autoload ~/.vim/backups ~/.vim/undodir
if [ ! -f ~/.vim/autoload/plug.vim ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
# Install vim plugins (ignoring errors if plugins fail to install initially)
vim -es -u "$DOT/.vimrc" -i NONE -c "PlugInstall" -c "qa" || true

# 4. Setup Tmux Plugin Manager (TPM)
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# 5. Install fzf
if [ ! -d ~/.fzf ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all --key-bindings --completion --no-update-rc
fi

# 6. Create symlinks for dotfiles
echo "Creating symlinks..."
ln -sf "$DOT/.zshrc" ~/.zshrc
ln -sf "$DOT/.gitconfig" ~/.gitconfig
ln -sf "$DOT/.vimrc" ~/.vimrc
ln -sf "$DOT/.tmux.conf" ~/.tmux.conf

mkdir -p ~/.config/lsd
ln -sf "$DOT/.config/lsd/config.yaml" ~/.config/lsd/config.yaml
ln -sf "$DOT/.config/lsd/colors.yaml" ~/.config/lsd/colors.yaml

echo "User setup completed!"
echo "========================================"
echo "Starting system configuration (sudo required)..."

# 7. Install packages (called specifically with sudo)
sudo bash "$DOT/install.sh"

# 8. Safely optimize pacman.conf
if command -v pacman > /dev/null; then
  echo "Optimizing pacman.conf..."
  
  # Backup the original configuration
  sudo cp /etc/pacman.conf /etc/pacman.conf.bak

  # Enable parallel downloads, colors, and verbose package lists
  sudo sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf
  sudo sed -i 's/#Color/Color/' /etc/pacman.conf
  sudo sed -i 's/#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
  
  # Safely inject ILoveCandy right below the 'Color' option if it doesn't exist
  if ! grep -q '^ILoveCandy' /etc/pacman.conf; then
    sudo sed -i '/^Color/a ILoveCandy' /etc/pacman.conf
  fi

  echo "Pacman configuration optimized."
fi

# 9. Setup a highly visible red warning prompt for the root user
echo "Setting up root warning prompt..."
ROOT_BASHRC="/root/.bashrc"
# This prompt will be bright red and clearly state [ROOT user@hostname directory]#
WARNING_PROMPT="PS1='\[\e[1;31m\][ROOT \u@\h \W]# \[\e[0m\]'"

# Check if the warning prompt is already in root's bashrc, if not, append it safely
if ! sudo grep -q "ROOT " "$ROOT_BASHRC" 2>/dev/null; then
  echo "$WARNING_PROMPT" | sudo tee -a "$ROOT_BASHRC" > /dev/null
fi

echo "All done! Initialization complete."
