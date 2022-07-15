if [ $# -lt 2 ]; then
  echo "Error - no argument. Please specify the script dir and temp dir!"
  exit
fi

if [ `whoami` = root ]; then
  pacman --version 1> /dev/null 2> /dev/null
  if [ $? -ne 0 ]; then
    echo "No pacman installer detected."
    apt --version 1> /dev/null 2> /dev/null
    if [ $? -ne 0 ]; then
      echo "No apt installer detected. Skipping package installation..."
      exit
    else
      $1/install-apt-packages.sh 
    fi
  else
    echo "Install arch packages via pacman..."
    $1/install-pacman-packages.sh
  fi
  # install pfetch
  $1/install-pfetch.sh $2
else
  echo Skipping package installation due to lack of permissions.
fi
