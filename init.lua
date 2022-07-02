-- Plugins
local packer = require('packer')
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end
packer.startup(function(use)
	use 'wbthomason/packer.nvim'
	use 'NLKNguyen/papercolor-theme'
	use 'christoomey/vim-tmux-navigator'
	use 'tpope/vim-fugitive'
	use 'nvim-lua/plenary.nvim'
	use 'neovim/nvim-lspconfig'
	use 'jose-elias-alvarez/null-ls.nvim'
	use 'kyazdani42/nvim-tree.lua'
	use 'nvim-treesitter/nvim-treesitter'
	use 'nvim-neorg/neorg'
	use 'nvim-lualine/lualine.nvim'

	if packer_bootstrap then
		packer.sync()
	end
end)

-- Settings
vim.cmd("filetype plugin indent on")
vim.cmd("colorscheme PaperColor")
vim.opt.nu = true
vim.opt.cursorline = true
vim.opt.tabpagemax = 20
vim.opt.colorcolumn = "100"
vim.opt.background = 'dark'
vim.opt.showcmd = true
vim.opt.wildmenu = true
vim.opt.hlsearch = true
vim.opt.autoindent = true

-- Keymaps
vim.api.nvim_set_keymap("n", "<S-h>", ":bp<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<S-l>", ":bn<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "˙", ":tabprevious<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "¬", ":tabnext<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "[", ":lua vim.lsp.buf.definition()<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "]", ":lua vim.lsp.buf.references()<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "=", ":lua vim.lsp.buf.hover()<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "`", ":NvimTreeToggle<CR>", { noremap = true })

-- Include an accessory lua file for system-local definitions
-- Defaults
local dirmanConfig = {}
local journalConfig = nil
local gtdConfig = nil
local homeDir = os.getenv("HOME")
package.path = package.path .. ";" .. homeDir .. "/.?.lua"
local haveLocalDefs, localDefs = pcall(require, "nvim-local-defs")
if haveLocalDefs then
	-- Override defaults
	dirmanConfig = localDefs.dirmanConfig
	journalConfig = localDefs.journalConfig
	gtdConfig = localDefs.gtdConfig
end

-- Neorg configuration
require('neorg').setup {
	load = {
		["core.defaults"] = {},
		["core.norg.qol.toc"] = {},
		["core.norg.dirman"] = dirmanConfig,
		["core.norg.journal"] = journalConfig,
		["core.gtd.base"] = gtdConfig,
		["core.export"] = {},
	}
}

-- Treesitter configuration
require('nvim-treesitter.configs').setup {
	ensure_installed = { "norg" },
	highlight = {
		enable = true,
	}
}

-- Lualine configuration
require('lualine').setup {
	options = {
		theme = {
			normal = {
				a = { fg = '#C6C6C6', bg = '#3A3A3A' },
				b = { fg = '#B2B2B2', bg = '#303030' },
				c = { fg = '#B2B2B2', bg = '#303030' },
				x = { fg = '#B2B2B2', bg = '#303030' },
				y = { fg = '#B2B2B2', bg = '#303030' },
				z = { fg = '#C6C6C6', bg = '#3A3A3A' },
			},
			inactive = {
				a = { fg = '#B2B2B2', bg = '#303030' },
				b = { fg = '#C6C6C6', bg = '#3A3A3A' },
				c = { fg = '#C6C6C6', bg = '#3A3A3A' },
				x = { fg = '#C6C6C6', bg = '#3A3A3A' },
				y = { fg = '#C6C6C6', bg = '#3A3A3A' },
				z = { fg = '#B2B2B2', bg = '#303030' },
			}
		},
		icons_enabled = false,
		section_separators = {left = '', right = ''},
		component_separators = {left = '', right = ''},
	},
	sections = {
		lualine_a = {'branch'},
		lualine_b = {'filename'},
		lualine_c = {''},
		lualine_x = {''},
		lualine_y = {'filetype', 'progress', 'location'},
		lualine_z = {''}
	},
	tabline = {
		lualine_a = {'tabs'},
		lualine_z = {'buffers'},
	},
}

-- Nvim-tree configuration
require('nvim-tree').setup {
	renderer = { icons = {
		symlink_arrow = " -> ",
		glyphs = {
			default = "",
			symlink = "",
			git = {
				unstaged = "*",
				staged = "*",
				unmerged = "",
				renamed = "",
				untracked = "!",
				deleted = "!",
				ignored = ".",
			},
			folder = {
				arrow_open = "<",
				arrow_closed = ">",
				default = "",
				open = "",
				empty = "",
				empty_open = ".",
				symlink = "",
				symlink_open = "",
			},
		},
	}},
}

-- LSP configuration
local lspconfig = require('lspconfig')
lspconfig.clangd.setup {
	cmd = { 'clangd', '-j=8' },
}
lspconfig.gopls.setup {}

-- Null-LS (linters) configuration
local null_ls = require('null-ls')
null_ls.setup {
	sources = {
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.diagnostics.zsh,
		null_ls.builtins.diagnostics.pylint,
	}
}
