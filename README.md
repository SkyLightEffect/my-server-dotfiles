# My Dotfiles

## Initial step: Cache Token
```
git config --global credential.helper cache
```

## Clone repo into hidden directory
```
git clone https://github.com/SkyLightEffect/mydotfiles.git ~/.dotfiles
```

## Create systemlinks in the Home directory to the real files in the repo
```
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfilees/.gitconfig ~/.gitconfig
```
