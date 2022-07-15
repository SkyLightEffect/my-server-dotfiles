#!/bin/bash
DOT=~/.dotfiles
TMP=$DOT/.temp
ZSH_PLUGINS=~/.zsh/plugins

if [ `whoami` = root ]; then
  ./install.sh
fi

mkdir -p $TMP

# zsh

chsh -s /bin/zsh

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_PLUGINS/zsh-syntax-highlighting/
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_PLUGINS/zsh-autosuggestions

# install vim onedark theme

mkdir -p $DOT/.vim/autoload 2>/dev/null
mkdir -p $DOT/.vim/colors 2>/dev/null

mkdir -p $TMP/onedark

git clone https://github.com/joshdick/onedark.vim.git $TMP/onedark

mv $TMP/onedark/autoload/onedark.vim $DOT/.vim/autoload/
mv $TMP/onedark/colors/onedark.vim $DOT/.vim/colors/

mkdir -p ~/.vim/autoload 2>/dev/null
mkdir -p ~/.vim/colors 2>/dev/null

ln -sf $DOT/.vim/colors/onedark.vim ~/.vim/colors/onedark.vim
ln -sf $DOT/.vim/autoload/onedark.vim ~/.vim/autoload/onedark.vim

# softlinks

ln -sf $DOT/.zshrc ~/.zshrc
ln -sf $DOT/.gitconfig ~/.gitconfig
ln -sf $DOT/.vimrc ~/.vimrc
ln -sf $DOT/.tmux.conf ~/.tmux.conf

rm -rf $TMP
