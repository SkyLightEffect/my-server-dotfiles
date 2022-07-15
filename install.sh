#!/bin/bash
DOT=~/.dotfiles
SCRIPTS=$DOT/scripts
TMP=$DOT/.temp
chmod -R u+x $SCRIPTS
sh $SCRIPTS/install-packages.sh $SCRIPTS
sh $SCRIPTS/vim-onedark-installer.sh
sh $SCRIPTS/links.sh
sh $SCRIPTS/zsh-installer.sh
rm -rd $TMP
zsh
