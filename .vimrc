" basics
set nocompatible      " Disable compatibility with vi which can cause unexpected issues.
filetype on           " Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype plugin on    " Enable plugins and load plugin for the detected file type.
filetype indent on    " Load an indent file for the detected file type.

" navigation and control

set mouse=a       " mouse right click
set scrolloff=10  " Do not let cursor scroll below or above N number of lines when scrolling.

" search
set ignorecase    " Ignore capital letters during search.
set smartcase     " Override the ignorecase option if searching for capital letters.
set hlsearch      " Use highlighting when doing a search. 
set incsearch     " Start highlighting as soon as you start typing for search

" tab spacing
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab

" colors
syntax on

" optics
set number
set cursorline

" PLUGINS ---------------------------------------------------------------- {{{

call plug#begin('~/.vim/plugged')
  Plug 'dense-analysis/ale'
  Plug 'preservim/nerdtree'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'joshdick/onedark.vim'
call plug#end()

colorscheme onedark                                                                                                                                                                                                                let g:airline_theme='onedark'

" }}}

