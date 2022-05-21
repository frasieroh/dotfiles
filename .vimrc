set nocompatible

call plug#begin('~/.vim/plugged')

Plug 'NLKNguyen/papercolor-theme'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-fugitive'
" Neovim plugins
if has('nvim')
    Plug 'kyazdani42/nvim-tree.lua'
    Plug 'nvim-treesitter/nvim-treesitter'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-neorg/neorg'
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'mfussenegger/nvim-lint'
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

if has('nvim')
    nmap [ :lua vim.lsp.buf.definition()<CR>
    nmap ] :lua vim.lsp.buf.references()<CR>
    nmap = :lua vim.lsp.buf.hover()<CR>
    nmap ` :NvimTreeToggle<CR>
    let g:nvim_tree_symlink_arrow = " -> "
    let g:nvim_tree_icons = {
        \ 'default': "",
        \ 'symlink': "",
        \ 'git': {
        \   'unstaged': "*",
        \   'staged': "*",
        \   'unmerged': "",
        \   'renamed': "",
        \   'untracked': "!",
        \   'deleted': "!",
        \   'ignored': ".",
        \   },
        \ 'folder': {
        \   'arrow_open': "<",
        \   'arrow_closed': ">",
        \   'default': "",
        \   'open': "",
        \   'empty': "",
        \   'empty_open': ".",
        \   'symlink': "",
        \   'symlink_open': "",
        \   }
        \ }

    command! -nargs=1 Gtd Neorg gtd <args>
    command! -nargs=1 Journal Neorg journal <args>

    autocmd FileType norg setlocal spell
    autocmd InsertLeave <buffer> lua require('lint').try_lint()
    autocmd BufWritePost <buffer> lua require('lint').try_lint()
endif

