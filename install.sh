#!/bin/bash
DOT=~/.dotfiles
SCRIPTS=$DOT/scripts
chmod -R u+x $SCRIPTS
sh $SCRIPTS/install-packages.sh $SCRIPTS
sh $SCRIPTS/scripts/vim-onedark-installer.sh
sh $SCRIPTS/scripts/links.sh
sh $SCRIPTS/scripts/zsh-installer.sh
zsh
