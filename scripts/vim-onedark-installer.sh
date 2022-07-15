#!/bin/bash
mkdir ~/.dotfiles/.temp
git clone https://github.com/joshdick/onedark.vim.git ~/.dotfiles/.temp/onedark

mkdir -p ~/.dotfiles/.vim/autoload
mkdir -p ~/.dotfiles/.vim/colors

mv ~/.dotfiles/.temp/onedark/autoload/onedark.vim ~/.dotfiles/.vim/autoload/
mv ~/.dotfiles/.temp/onedark/colors/onedark.vim ~/.dotfiles/.vim/colors/

mkdir -p ~/.vim/autoload
mkdir -p ~/.vim/colors

ln -s ~/.dotfiles/.vim/autoload/onedark.vim
ln -s ~/.dotfiles/.vim/colors/onedark.vim


