" basics
set nocompatible " Disable compatibility with vi which can cause unexpected issues.
filetype on " Enable type file detection. Vim will be able to try to detect the type of file in use.

" navigation and control

set mouse=a       " mouse right click
set scrolloff=10  " Do not let cursor scroll below or above N number of lines when scrolling.

# search
set ignorecase    " Ignore capital letters during search.
set smartcase     " Override the ignorecase option if searching for capital letters.
set hlsearch      " Use highlighting when doing a search. 

" tab spacing
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab

" colors
syntax on
colorscheme onedark

" optics
set number
set cursorline
