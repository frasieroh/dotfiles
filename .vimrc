set nocompatible

call plug#begin('~/.vim/plugged')

Plug 'NLKNguyen/papercolor-theme'
Plug 'dense-analysis/ale'
Plug 'preservim/nerdtree'

call plug#end()

filetype plugin indent on
set nu
set cursorline
set tabpagemax=20
set clipboard=exclude:.*
set colorcolumn=100
set tabstop=4
set shiftwidth=4
set background=dark
set showcmd
set wildmenu
set hlsearch
colorscheme PaperColor

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 1

let g:ale_linters = {
\   'tac': ['artaclsp'],
\   'python': ['pylsp', 'pylint'],
\   'cpp': ['clangd'],
\   'c': ['clangd'],
\}

" Optional local configuration
if filereadable( "~/.morevimrc" )
	so ~/.morevimrc
endif
