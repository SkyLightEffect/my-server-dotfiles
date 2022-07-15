#!/bin/sh

PLUGINS=~/.zsh/plugins/

sudo chsh -s /bin/zsh

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $PLUGINS/zsh-syntax-highliting/
git clone https://github.com/zsh-users/zsh-autosuggestions.git $PLUGINS/zsh-autosuggestions
