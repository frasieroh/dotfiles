-- Install packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
	vim.o.runtimepath = vim.fn.stdpath('data') .. '/site/pack/*/start/*,' .. vim.o.runtimepath
end

-- Plugins
local packer = require('packer')
packer.startup(function(use)

use { 'wbthomason/packer.nvim', }

use { 'NLKNguyen/papercolor-theme',
	config = function()
		vim.opt.background = "dark"
		vim.cmd("colorscheme PaperColor")
	end,
}

use { 'christoomey/vim-tmux-navigator', }

use { 'kyazdani42/nvim-tree.lua',
	config = function()
		require('nvim-tree').setup {
			renderer = { icons = {
				symlink_arrow = " > ",
				padding = "",
				glyphs = {
					default = "· ",
					symlink = "l ",
					git = {
						unstaged = "* ",
						staged = "+ ",
						unmerged = "? ",
						renamed = "r ",
						deleted = "d ",
						untracked = "x ",
						ignored = "x ",
					},
					folder = {
						arrow_open = "-",
						arrow_closed = "+",
						default = "",
						open = "",
						empty = "",
						empty_open = "",
						symlink = "",
						symlink_open = "",
					},
				},
			}},
		}
		vim.api.nvim_set_keymap("n", "`", ":NvimTreeToggle<CR>", { noremap = true })
	end
}

use { 'nvim-telescope/telescope.nvim',
	requires = { 'nvim-lua/plenary.nvim' },
	config = function()
		vim.api.nvim_set_keymap("n", "ff", ":Telescope find_files<CR>", { noremap = true })
		vim.api.nvim_set_keymap("n", "fg", ":Telescope live_grep<CR>", { noremap = true })
	end,
}

use { 'nvim-lualine/lualine.nvim',
	config = function()
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
	end
}

use { 'lukas-reineke/indent-blankline.nvim',
	event = { 'BufRead', 'BufNewFile' },
}

use { 'tpope/vim-fugitive',
	event = { 'BufRead', 'BufNewFile' },
}

use { 'folke/trouble.nvim',
	event = { 'BufRead', 'BufNewFile' },
	config = function()
		require("trouble").setup {
			fold_open = "-",
			fold_closed = "+",
			icons = false,
		}
	end,
}

use { 'neovim/nvim-lspconfig',
	event = { 'BufRead', 'BufNewFile' },
	-- Load after trouble to get its lsp handlers
	after = { 'trouble.nvim' },
	config = function()
		local lspconfig = require('lspconfig')
		lspconfig.clangd.setup {
			cmd = { 'clangd', '-j=8' },
		}
		lspconfig.gopls.setup {}
		vim.api.nvim_set_keymap("n", "[", ":Trouble lsp_definitions<CR>", { noremap = true })
		vim.api.nvim_set_keymap("n", "]", ":Trouble lsp_references<CR>", { noremap = true })
		vim.api.nvim_set_keymap("n", "=", ":lua vim.lsp.buf.hover()<CR>", { noremap = true })
	end
}

use { 'jose-elias-alvarez/null-ls.nvim',
	requires = { 'nvim-lua/plenary.nvim' },
	event = { 'BufRead', 'BufNewFile' },
	config = function()
		local null_ls = require('null-ls')
		null_ls.setup {
			sources = {
				null_ls.builtins.diagnostics.shellcheck,
				null_ls.builtins.diagnostics.zsh,
				null_ls.builtins.diagnostics.pylint,
			}
		}
	end
}

use { 'nvim-treesitter/nvim-treesitter',
	event = { 'BufRead', 'BufNewFile' },
	config = function()
		require('nvim-treesitter.configs').setup {
			ensure_installed = { "norg" },
			highlight = {
				enable = true,
			}
		}
	end,
}

use { 'nvim-neorg/neorg',
	requires = { 'nvim-lua/plenary.nvim' },
	after = { 'nvim-treesitter' },
	ft = 'norg',
	config = function()
		-- Include an accessory lua file for system-local definitions
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
	end,
}

if packer_bootstrap then
	packer.sync()
end
end)

-- Other settings
vim.cmd("filetype plugin indent on")
vim.opt.nu = true
vim.opt.cursorline = true
vim.opt.tabpagemax = 20
vim.opt.colorcolumn = "100"
vim.opt.showcmd = true
vim.opt.wildmenu = true
vim.opt.hlsearch = true
vim.opt.autoindent = true

-- Other keybindings
vim.api.nvim_set_keymap("n", "<S-h>", ":bp<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<S-l>", ":bn<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "˙", ":tabprevious<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "¬", ":tabnext<CR>", { noremap = true })

