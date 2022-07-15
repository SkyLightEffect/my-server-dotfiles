#!/bin/bash
DOT='~/.dotfiles'
chmod -R u+x $DOT/scripts
sh $DOT/scripts/install-packages.sh
sh $DOT/scripts/vim-onedark-installer.sh
sh $DOT/scripts/links.sh
sh $DOT/scripts/zsh-installer.sh
zsh
