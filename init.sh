#!/bin/bash
set -e

# Automatically detect the directory where this script is located
DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== 1. System Configuration (sudo) ==="
if [ -f "$DOT/install.sh" ]; then
    sudo bash "$DOT/install.sh"
fi

# Pacman Optimization
if command -v pacman > /dev/null; then
  echo "Optimizing pacman.conf..."
  sudo sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf
  sudo sed -i 's/#Color/Color/' /etc/pacman.conf
  grep -q "ILoveCandy" /etc/pacman.conf || sudo sed -i '/^Color/a ILoveCandy' /etc/pacman.conf
fi

echo "=== 2. Git Trust & Zinit ==="
# Trust GitHub automatically to prevent SSH clone errors for plugins on fresh systems
mkdir -p ~/.ssh
ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null

# Zinit Plugin Manager
ZINIT_HOME="${HOME}/.local/share/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    echo "Installing Zinit..."
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Change default shell to zsh (for user)
[ "$SHELL" != "$(command -v zsh)" ] && sudo chsh -s "$(command -v zsh)" "$(whoami)"

# Vim Plugin Manager & TPM & FZF
mkdir -p ~/.vim/autoload ~/.vim/backups ~/.vim/undodir
[ ! -f ~/.vim/autoload/plug.vim ] && curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
[ ! -d ~/.tmux/plugins/tpm ] && git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
[ ! -d ~/.fzf ] && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all --key-bindings --completion --no-update-rc

echo "=== 3. Symlinks & Root Setup ==="
ln -sf "$DOT/.zshrc" ~/.zshrc
ln -sf "$DOT/.tmux.conf" ~/.tmux.conf
ln -sf "$DOT/.vimrc" ~/.vimrc
ln -sf "$DOT/.gitconfig" ~/.gitconfig

# Switch root to ZSH and link config (for the red prompt)
sudo chsh -s "$(command -v zsh)" root
sudo ln -sf "$HOME/.zshrc" /root/.zshrc
sudo ln -sf "$HOME/.tmux.conf" /root/.tmux.conf

echo "Initialization complete! Run 'exec zsh' now."
