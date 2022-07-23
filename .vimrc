" basics
set nocompatible      " Disable compatibility with vi which can cause unexpected issues.
filetype on           " Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype plugin on    " Enable plugins and load plugin for the detected file type.
filetype indent on    " Load an indent file for the detected file type.

" navigation and control
set ttymouse=xterm2 " tmux mouse compatibility
set mouse=r         " mouse right click
set scrolloff=10    " Do not let cursor scroll below or above N number of lines when scrolling.
set pastetoggle=<F2>

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
  " optics
  Plug 'ap/vim-css-color'
  " modern PHP syntax highlighting
  Plug 'StanAngeloff/php.vim'
  " Syntax highlighting for postgres
  Plug 'lifepillar/pgsql.vim'

  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'alvan/vim-closetag'
  Plug 'jiangmiao/auto-pairs'

  " Add info to sidebar about git
  Plug 'airblade/vim-gitgutter'

	" sync-vim is only here because it is required by vim-lsp
	Plug 'prabirshrestha/async.vim'
	" Languages server protocol connection
	Plug 'prabirshrestha/vim-lsp'

  " Autocomplete functionality
  Plug 'prabirshrestha/asyncomplete.vim'
  " Autocomplete source - the buffer
  Plug 'prabirshrestha/asyncomplete-buffer.vim'
  " Autocomplete source - files
  Plug 'prabirshrestha/asyncomplete-file.vim'
  " Autocomplete source - language server protocol
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  " Autocomplete source - Ultisnips
  Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
  " Autocomplete source - ctags
  Plug 'prabirshrestha/asyncomplete-tags.vim'"

  call plug#end()

colorscheme onedark 

" Tab completion with autocomplete
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
imap <c-space> <Plug>(asyncomplete_force_refresh)

" set up lsp

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END



" Using asyncomplete-buffer.vim
call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'whitelist': ['*'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ 'config': {
    \    'max_buffer_size': 5000000,
    \  },
    \ }))

" Using asyncomplete-file.
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'whitelist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))


" Using Ultisnips
call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
      \ 'name': 'ultisnips',
      \ 'whitelist': ['*'],
      \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
      \ }))

" Using Ctags
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
    \ 'name': 'tags',
    \ 'whitelist': ['c', 'ruby'],
    \ 'completor': function('asyncomplete#sources#tags#completor'),
    \ 'config': {
    \    'max_file_size': 50000000,
    \  },
    \ }))
