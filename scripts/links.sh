ln -sf ~/.dotfiles/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/.vimrc ~/.vimrc
ln -sf ~/.dotfiles/.tmux.conf ~/.tmux.conf
#ln -s ~/.dotfiles/.vim/ ~/.vim/

mkdir -p ~/.vim/colors
mkdir -p ~/.vim/autoload
ln -sf ~/.dotfiles/.vim/colors/onedark.vim ~/.vim/colors/onedark.vim
ln -sf ~/.dotfiles/.vim/autoload/onedark.vim ~/.vim/autoload/onedark.vim
