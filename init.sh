#!/bin/bash
set -e

# Automatically detect the directory where this script is located
DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== 1. System Configuration (sudo) ==="
if [ -f "$DOT/install.sh" ]; then
    sudo bash "$DOT/install.sh"
fi

# Pacman Optimization (Idempotent approach)
if command -v pacman > /dev/null; then
  echo "Optimizing pacman.conf..."
  # Only replace if the commented version exists, preventing double-edits
  sudo sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf
  sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
  sudo sed -i 's/^#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
  grep -q "^ILoveCandy" /etc/pacman.conf || sudo sed -i '/^Color/a ILoveCandy' /etc/pacman.conf
fi

echo "=== 2. Git Trust & Zinit ==="
mkdir -p ~/.ssh
# Idempotent SSH Keyscan: Only add if not already present
if ! ssh-keygen -F github.com >/dev/null 2>&1; then
    ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null
fi

ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    echo "Installing Zinit..."
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

echo "=== 3. User Environment Setup ==="
# Change shell only if needed
[ "$SHELL" != "$(command -v zsh)" ] && sudo chsh -s "$(command -v zsh)" "$(whoami)"

# Vim, Tmux & FZF Setup
mkdir -p ~/.vim/autoload ~/.vim/backups ~/.vim/undodir
[ ! -f ~/.vim/autoload/plug.vim ] && curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
[ ! -d ~/.tmux/plugins/tpm ] && git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
[ ! -d ~/.fzf ] && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all --key-bindings --completion --no-update-rc

# Symlinks for the current user
ln -sf "$DOT/.zshrc" ~/.zshrc
ln -sf "$DOT/.tmux.conf" ~/.tmux.conf
ln -sf "$DOT/.vimrc" ~/.vimrc
ln -sf "$DOT/.gitconfig" ~/.gitconfig

echo "=== 4. Secure Root Setup ==="
# Make root use ZSH
sudo chsh -s "$(command -v zsh)" root

# BEST PRACTICE: Copy instead of Symlink!
# This isolates root. If the user breaks their config, root is safe.
sudo cp "$DOT/.zshrc" /root/.zshrc
sudo cp "$DOT/.tmux.conf" /root/.tmux.conf

# Auto-install Tmux plugins in the background
~/.tmux/plugins/tpm/bin/install_plugins

# Fix permissions for root just to be safe
sudo chown root:root /root/.zshrc /root/.tmux.conf

echo "Initialization complete! Run 'exec zsh' now."
