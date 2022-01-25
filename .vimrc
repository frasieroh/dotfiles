set nocompatible

call plug#begin('~/.vim/plugged')

Plug 'NLKNguyen/papercolor-theme'
Plug 'dense-analysis/ale'
Plug 'preservim/nerdtree'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-fugitive'

call plug#end()

filetype plugin indent on
set nu
set cursorline
set tabpagemax=20
set clipboard=exclude:.*
set colorcolumn=100
set background=dark
set showcmd
set wildmenu
set hlsearch
set autoindent
colorscheme PaperColor

nmap ` :NERDTreeToggle<CR>
nmap [ :vs \| :ALEGoToDefinition<CR>
nmap ] :vs \| :ALEFindReferences<CR>
nmap = :ALEHover<CR>

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 1

let g:ale_linters = {
\   'tac': ['artaclsp'],
\   'python': ['pyright', 'pylint'],
\   'cpp': ['clangd'],
\   'c': ['clangd'],
\}

" Pyright for typechecking only; no language stuff please
let b:ale_python_pyright_config = {
\ 'pyright': {
\   'disableLanguageServices': v:true,
\ },
\}
