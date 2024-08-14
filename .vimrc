" Basics
set nocompatible            " Disable compatibility with vi
filetype plugin indent on   " Enable filetype detection, plugins, and indentation

" Navigation and Control
set ttymouse=xterm2         " tmux mouse compatibility
set mouse=a                 " Enable mouse in all modes
set scrolloff=10            " Keep cursor 10 lines away from edge
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
set listchars=tab:>-,trail:- " Customize list characters

" Code Folding
set foldmethod=syntax        " Use syntax-based folding
set foldlevelstart=1         " Start with folds open by default

" Plugin Management
call plug#begin('~/.vim/plugged')
  Plug 'dense-analysis/ale'
  Plug 'preservim/nerdtree'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'joshdick/onedark.vim'
  Plug 'tpope/vim-commentary'
  Plug 'ap/vim-css-color'
  Plug 'StanAngeloff/php.vim'
  Plug 'lifepillar/pgsql.vim'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'alvan/vim-closetag'
  Plug 'jiangmiao/auto-pairs'
  Plug 'airblade/vim-gitgutter'
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-buffer.vim'
  Plug 'prabirshrestha/asyncomplete-file.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
  Plug 'prabirshrestha/asyncomplete-tags.vim'
call plug#end()

" Set colorscheme after plugins are loaded
colorscheme onedark

" Airline & Lightline
let g:airline_theme = 'onedark'
let g:lightline = {
    \ 'colorscheme': 'onedark',
    \ }

" Tab Completion with Autocomplete
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR>    pumvisible() ? asyncomplete#close_popup() : "\<CR>"
imap <C-Space> <Plug>(asyncomplete_force_refresh)

" LSP Configuration
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nnoremap <buffer> gd <Plug>(lsp-definition)
    nnoremap <buffer> gs <Plug>(lsp-document-symbol-search)
    nnoremap <buffer> gS <Plug>(lsp-workspace-symbol-search)
    nnoremap <buffer> gr <Plug>(lsp-references)
    nnoremap <buffer> gi <Plug>(lsp-implementation)
    nnoremap <buffer> gt <Plug>(lsp-type-definition)
    nnoremap <buffer> <leader>rn <Plug>(lsp-rename)
    nnoremap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nnoremap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nnoremap <buffer> K <Plug>(lsp-hover)
    nnoremap <buffer> <C-f> <Plug>(lsp-scroll-up)
    nnoremap <buffer> <C-d> <Plug>(lsp-scroll-down)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" Autocomplete Sources Configuration
call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'whitelist': ['*'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ 'config': {
    \    'max_buffer_size': 10000000,
    \  },
    \ }))

call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'whitelist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))

call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
    \ 'name': 'ultisnips',
    \ 'whitelist': ['*'],
    \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
    \ }))

call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
    \ 'name': 'tags',
    \ 'whitelist': ['c', 'ruby'],
    \ 'completor': function('asyncomplete#sources#tags#completor'),
    \ 'config': {
    \    'max_file_size': 10000000,
    \  },
    \ }))
