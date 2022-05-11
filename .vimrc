set nocompatible

call plug#begin('~/.vim/plugged')

Plug 'NLKNguyen/papercolor-theme'
Plug 'dense-analysis/ale'
Plug 'preservim/nerdtree'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-fugitive'
" Neovim plugins
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-neorg/neorg'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter'

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

nmap ` :NERDTreeToggle<CR>
nmap [ :ALEGoToDefinition<CR>
nmap ] :ALEFindReferences<CR>
nmap = :ALEHover<CR>

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 1

let g:ale_linters = {
\   'tac': ['artaclsp'],
\   'python': ['pyright', 'pylint'],
\   'cpp': ['clangd'],
\   'c': ['clangd'],
\}

let b:ale_python_pyright_config = {
\ 'pyright': {
\   'disableLanguageServices': v:true,
\ },
\}
