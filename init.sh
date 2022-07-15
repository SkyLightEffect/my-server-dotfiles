#!/bin/bash
DOT=~/.dotfiles
#SCRIPTS=$DOT/scripts
TMP=$DOT/.temp
ZSH_PLUGINS=~/.zsh/plugins

if [ `whoami` = root ]; then
  ./install.sh
fi

# zsh

chsh -s /bin/zsh

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_PLUGINS/zsh-syntax-highlighting/
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_PLUGINS/zsh-autosuggestions

# install vim onedark theme

mkdir -p ~/.dotfiles/.vim/autoload 2>/dev/null
mkdir -p ~/.dotfiles/.vim/colors 2>/dev/null

git clone https://github.com/joshdick/onedark.vim/blob/main/autoload/onedark.vim ~/.dotfiles/.vim/autoload
git clone https://github.com/joshdick/onedark.vim/blob/main/colors/onedark.vim ~/.dotfiles/.vim/colors

mkdir -p ~/.vim/autoload 2>/dev/null
mkdir -p ~/.vim/colors 2>/dev/null

ln -sf ~/.dotfiles/.vim/colors/onedark.vim ~/.vim/colors/onedark.vim
ln -sf ~/.dotfiles/.vim/autoload/onedark.vim ~/.vim/autoload/onedark.vim

# softlinks

ln -sf ~/.dotfiles/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/.vimrc ~/.vimrc
ln -sf ~/.dotfiles/.tmux.conf ~/.tmux.conf
