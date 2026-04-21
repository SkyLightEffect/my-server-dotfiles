" ==========================================
"  Ultra-Slim Server Vim Configuration
" ==========================================

" Basics
set nocompatible            " Disable compatibility with vi
syntax on                   " Enable syntax highlighting
filetype plugin indent on   " Enable filetype detection

" Navigation and Control
set ttymouse=xterm2         " tmux mouse compatibility
set mouse=a                 " Enable mouse in all modes
set scrolloff=5             " Keep cursor 5 lines away from edge
set pastetoggle=<F2>        " Toggle paste mode with F2

" Search
set ignorecase              " Ignore case when searching
set smartcase               " Override ignorecase if search contains uppercase
set hlsearch                " Highlight search results
set incsearch               " Incremental search

" Tab and Indentation
set smartindent             " Smart indentation
set tabstop=2               " Number of spaces per tab
set shiftwidth=2            " Number of spaces for autoindent
set expandtab               " Use spaces instead of tabs

" Visual Enhancements
set number                  " Show line numbers
set cursorline              " Highlight the line with the cursor
set relativenumber          " Show relative line numbers
set wrap                    " Enable line wrapping
set list                    " Show hidden characters like tabs and trailing spaces
set listchars=tab:>-,trail:- 

" Backup and Auto-save (Deaktiviert für Server!)
" Auf Servern editieren wir oft systemkritische /etc/ Dateien. 
" Vim-Swapfiles stören hier nur und müllen die Ordner voll.
set nobackup                
set noswapfile
set noundofile

" Minimalist Plugin Management
call plug#begin('~/.vim/plugged')
  Plug 'joshdick/onedark.vim'           " Dein Theme
  Plug 'vim-airline/vim-airline'        " Statusleiste
  Plug 'vim-airline/vim-airline-themes'
  Plug 'tpope/vim-commentary'           " gcc zum schnellen Auskommentieren
call plug#end()

" Theme & Colors
colorscheme onedark
let g:airline_theme = 'onedark'
let g:airline_powerline_fonts = 0       " 0 = Sichere Text-Icons, damit SSH nicht kaputt aussieht
