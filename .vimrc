" basics
set nocompatible      " Disable compatibility with vi which can cause unexpected issues.
filetype on           " Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype plugin on    " Enable plugins and load plugin for the detected file type.
filetype indent on    " Load an indent file for the detected file type.

" navigation and control
set ttymouse=xterm2 " tmux mouse compatibility
set mouse=r         " mouse right click
set scrolloff=10    " Do not let cursor scroll below or above N number of lines when scrolling.

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

let g:airline_theme='onedark'
let g:lightline = {
          \ 'colorscheme': 'onedark',
      \ }

" PLUGINS ---------------------------------------------------------------- {{{

call plug#begin('~/.vim/plugged')
  Plug 'dense-analysis/ale'
  Plug 'preservim/nerdtree'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'joshdick/onedark.vim'
  Plug 'tpope/vim-commentary'
  Plug 'ap/vim-css-color'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'alvan/vim-closetag'
  Plug 'jiangmiao/auto-pairs'
  " Add info to sidebar about git
  Plug 'airblade/vim-gitgutter'
  " Autocomplete functionality
  Plug 'prabirshrestha/asyncomplete.vim'
  " Autocomplete source - the buffer
  Plug 'prabirshrestha/asyncomplete-buffer.vim'
  " Autocomplete source - files
  Plug 'prabirshrestha/asyncomplete-file.vim'
  " Autocomplete source - language server protocol
  " Plug 'prabirshrestha/asyncomplete-lsp.vim'
  " Autocomplete source - Ultisnips
  Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
  " Autocomplete source - ctags
  Plug 'prabirshrestha/asyncomplete-tags.vim'"
call plug#end()

colorscheme onedark 
" colorscheme nord

" }}}
