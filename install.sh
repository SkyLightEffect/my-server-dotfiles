#!/bin/bash
DOT=~/.dotfiles
SCRIPTS=$DOT/scripts
chmod -R u+x $SCRIPTS
sh $SCRIPTS/install-packages.sh $SCRIPTS
sh $SCRIPTS/vim-onedark-installer.sh
sh $SCRIPTS/links.sh
sh $SCRIPTS/zsh-installer.sh
zsh
