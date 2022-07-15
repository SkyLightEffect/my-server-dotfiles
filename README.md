# My Dotfiles

## Initial step: Cache Token
```
git config --global credential.helper cache
```

## Clone repo into hidden directory
```
git clone https://github.com/SkyLightEffect/mydotfiles.git ~/.dotfiles
```

## Run the installation script
```
sudo sh ~/.dotfiles/install.sh
```
Or without root permission (no packages will be installed)
```
sh ~/.dotfiles/install.sh
```
