-- Install packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
	vim.o.runtimepath = vim.fn.stdpath('data') .. '/site/pack/*/start/*,' .. vim.o.runtimepath
end

-- Plugins
local packer = require('packer') packer.startup(function(use)
use { 'wbthomason/packer.nvim', }
	tag = '*',

use { 'NLKNguyen/papercolor-theme',
	tag = '*',
	config = function()
		vim.opt.background = "dark"
		vim.cmd("colorscheme PaperColor")
	end,
}

use { 'christoomey/vim-tmux-navigator', }
	tag = '*',

use { 'nvim-telescope/telescope.nvim',
	tag = '*',
	requires = { 'nvim-lua/plenary.nvim' },
	config = function()
		local builtin_config = function(initial_mode)
			return {
				theme = "ivy",
				initial_mode = initial_mode,
			}
		end
		require('telescope').setup {
			pickers = {
				live_grep = builtin_config("insert"),
				file_browser = builtin_config("normal"),
				lsp_definitions = builtin_config("normal"),
				lsp_type_definitions = builtin_config("normal"),
				lsp_references = builtin_config("normal"),
				diagnostics = builtin_config("normal"),
			},
			extensions = {
				file_browser = {
					theme = "ivy",
					initial_mode = "normal",
					hijack_netrw = true,
					dir_icon = "+",
					dir_icon_hl = "Directory",
					-- Make ` work as a toggle.
					attach_mappings = function(prompt_bufnr, map)
						local actions = require('telescope.actions')
						local close_file_browser = function()
							actions.close(prompt_bufnr)
						end
						map("n", "`", close_file_browser)
						return true
					end,
				}
			}
		}
		vim.api.nvim_set_keymap("n", "[", ":Telescope lsp_definitions<CR>", { noremap = true })
		vim.api.nvim_set_keymap("n", "<C-[>", ":Telescope lsp_type_definitions<CR>", { noremap = true })
		vim.api.nvim_set_keymap("n", "]", ":Telescope lsp_references<CR>", { noremap = true })
		vim.api.nvim_set_keymap("n", "'", ":Telescope diagnostics bufnr=0<CR>", { noremap = true })
		vim.api.nvim_set_keymap("n", "fg", ":Telescope live_grep<CR>", { noremap = true })
		vim.api.nvim_set_keymap("n", "`", ":Telescope file_browser<CR>", { noremap = true })
	end,
}

use { 'nvim-telescope/telescope-file-browser.nvim',
	tag = '*',
	requires = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
	after = { 'telescope.nvim' },
	config = function()
		require('telescope').load_extension("file_browser")
	end,
}

use { 'nvim-lualine/lualine.nvim',
	tag = '*',
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

use { 'neovim/nvim-lspconfig',
	tag = '*',
	-- Lazy loading breaks filetype recognition
	config = function()
		local lspconfig = require('lspconfig')
		lspconfig.clangd.setup {
			cmd = { 'clangd', '-j=8' },
		}
		lspconfig.gopls.setup {}
		vim.api.nvim_set_keymap("n", "=", ":lua vim.lsp.buf.hover()<CR>", { noremap = true })
	end
}

use { 'jose-elias-alvarez/null-ls.nvim',
	tag = '*',
	-- Lazy loading breaks filetype recognition
	requires = { 'nvim-lua/plenary.nvim' },
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
	tag = '*',
	config = function()
		require('nvim-treesitter.configs').setup {
			ensure_installed = {
				"norg",
			},
			highlight = {
				enable = true,
			}
		}
	end,
}

use { 'nvim-neorg/neorg',
	tag = '*',
	requires = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
	after = { 'nvim-treesitter' },
	config = function()
		require('neorg').setup {
			load = {
				["core.defaults"] = {},
				["core.norg.qol.toc"] = {},
				["core.norg.dirman"] = {
					config = {
						workspaces = {
							home = "~/neorg",
						}
					},
					autochdir = true,
					index = "index.norg",
				},
				["core.norg.journal"] = {
					config = {
						workspace = "home",
					}
				},
				["core.gtd.base"] = {
					config = {
						workspace = "home",
					}
				},
				["core.export"] = {},
			}
		}
	end,
}

use { 'tpope/vim-fugitive',
	tag = '*',
	event = { 'BufRead', 'BufNewFile' },
}

use { 'lukas-reineke/indent-blankline.nvim',
	tag = '*',
	event = { 'BufRead', 'BufNewFile' },
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

-- Autocommands
vim.api.nvim_create_autocmd({"BufWrite"}, {pattern="*", callback=vim.lsp.buf.formatting})

