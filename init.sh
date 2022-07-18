#!/bin/bash
DOT=~/.dotfiles
TMP=$DOT/.temp
ZSH_PLUGINS=~/.zsh/plugins

if [ `whoami` = root ]; then
  $DOT/install.sh
fi

mkdir -p $TMP

# zsh

chsh -s /bin/zsh

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_PLUGINS/zsh-syntax-highlighting/
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_PLUGINS/zsh-autosuggestions

# vim plugin manager
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -es -u $DOT/.vimrc -i NONE -c "PlugInstall" -c "qa"

# tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


# softlinks

ln -sf $DOT/.zshrc ~/.zshrc
ln -sf $DOT/.gitconfig ~/.gitconfig
ln -sf $DOT/.vimrc ~/.vimrc
ln -sf $DOT/.tmux.conf ~/.tmux.conf

rm -rf $TMP

zsh 2>/dev/null
