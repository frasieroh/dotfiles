set nocompatible

call plug#begin('~/.vim/plugged')

Plug 'NLKNguyen/papercolor-theme'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-fugitive'
endif

call plug#end()

filetype plugin indent on
set nu
set cursorline
set tabpagemax=20
set colorcolumn=100
set background=dark
set showcmd
set wildmenu
set hlsearch
set autoindent
colorscheme PaperColor

nmap <S-h> :bp<CR>
nmap <S-l> :bn<CR>
" Alt + h, l respectively
nmap ˙ :tabprevious<CR>
nmap ¬ :tabnext<CR>
