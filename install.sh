#!/bin/bash

DOT=~/.dotfiles
SCRIPTS=$DOT/scripts
TMP=$DOT/.temp

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
    fi
  else
    echo "Install arch packages via pacman..."
    chmod u+x $DOT/.pacman.sh && $DOT/.pacman.sh
  fi
else
  echo Skipping package installation due to lack of permissions.
fi

