ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf
#ln -s ~/.dotfiles/.vim/ ~/.vim/

mkdir -p ~/.vim/colors
mkdir -p ~/.vim/autoload
ln -s ~/.dotfiles/.vim/colors/onedark.vim ~/.vim/colors/onedark.vim
ln -s ~/.dotfiles/.vim/autoload/onedark.vim ~/.vim/autoload/onedark.vim
