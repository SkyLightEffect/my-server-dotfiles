#!/bin/bash

DOT=~/.dotfiles
SCRIPTS=$DOT/scripts
TMP=$DOT/.temp

mkdir -p $TMP 2> /dev/null

if [ `whoami` = root ]; then
  pacman --version 1> /dev/null 2> /dev/null
  if [ $? -ne 0 ]; then
    echo "No pacman installer detected."
    apt --version 1> /dev/null 2> /dev/null
    if [ $? -ne 0 ]; then
      echo "No apt installer detected. Skipping package installation..."
      exit
    else
      chmod u+x $DOT/.apt.sh && $DOT/.apt.sh
      # install vivid
      wget "https://github.com/sharkdp/vivid/releases/download/v0.8.0/vivid_0.8.0_amd64.deb"
      dpkg -i vivid_0.8.0_amd64.deb
      rm vivid_0.8.0_amd64.deb
    fi
  else
    echo "Install arch packages via pacman..."
    chmod u+x $DOT/.pacman.sh && $DOT/.pacman.sh
  fi
  # install pfetch
  chmod u+x $DOT/.pfetch.sh && $DOT/.pfetch.sh $TMP
else
  echo Skipping package installation due to lack of permissions.
fi

rm -rf $TMP 2> /dev/null
