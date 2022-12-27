-- Install folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)

-- Plugins
local plugins = {
	-- LSP and related plugins
	{
		"neovim/nvim-lspconfig",
		-- Don't load until mason-lspconfig requires this
		-- It requires itself to be set up first
		lazy = true,
	},

	{
		"jose-elias-alvarez/null-ls.nvim",
		-- Don't load until mason-null-ls includes this
		-- It requires itself to be set up first
		lazy = true,
	},

	{
		"williamboman/mason.nvim",
		config = function()
			require('mason').setup {}
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
		},
		config = function()
			local mason_lspconfig = require('mason-lspconfig')
			mason_lspconfig.setup {}
			mason_lspconfig.setup_handlers {
				-- Default setup handler for LSP servers
				function(server_name)
					return require('lspconfig')[server_name].setup {}
				end,
				-- Add manual setup here. Example:
				-- [ "clangd" ] = function() {
				-- ...
				-- end,
			}
		end,
	},

	{
		"jay-babu/mason-null-ls.nvim",
		dependencies = {
			"jose-elias-alvarez/null-ls.nvim",
			"williamboman/mason.nvim",
		},
		config = function()
			local mason_null_ls = require('mason-null-ls')
			mason_null_ls.setup {
				automatic_instalation = false,
				automatic_setup = true,
			}
			require("null-ls").setup {}
			mason_null_ls.setup_handlers {}
		end,
	},
	-- Neorg and related plugins
	{
		"nvim-neorg/neorg",
		-- neorg already lazy loads itself
		--  lazy = true,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
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
					-- GTD is being rewritten.
					-- ["core.gtd.base"] = {
					-- 	config = {
					-- 		workspace = "home",
					-- 	}
					-- },
				}
			}
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		lazy = true,
		event = { 'BufRead', 'BufNewFile' },
		config = function()
			require('nvim-treesitter.configs').setup {
				ensure_installed = {
					"norg",
				},
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
				},
			}
		end,
	},
	-- Other plugins
	{
		"tpope/vim-fugitive",
		lazy = true,
		event = { 'BufRead', 'BufNewFile' },
	},

	{
		"NLKNguyen/papercolor-theme",
		config = function()
			vim.opt.background = "dark"
			vim.cmd("colorscheme PaperColor")
		end,
	},

	{
		"christoomey/vim-tmux-navigator",
	},

	{
		"nvim-telescope/telescope.nvim",
		lazy = true,
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "[", ":Telescope lsp_definitions<CR>", mode = "n" },
			{ "<C-[>", ":Telescope lsp_type_definitions<CR>", mode = "n" },
			{ "]", ":Telescope lsp_references<CR>", mode = "n" },
			{ "'", ":Telescope diagnostics bufnr=0<CR>", mode = "n" },
			{ "fg", ":Telescope live_grep<CR>", mode = "n" },
		},
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
				-- extensions = {
				-- 	file_browser = {
				-- 		theme = "ivy",
				-- 		initial_mode = "normal",
				-- 		hijack_netrw = true,
				-- 		dir_icon = "+",
				-- 		dir_icon_hl = "Directory",
				-- 		-- Make ` work as a toggle.
				-- 		attach_mappings = function(prompt_bufnr, map)
				-- 			local actions = require('telescope.actions')
				-- 			local close_file_browser = function()
				-- 				actions.close(prompt_bufnr)
				-- 			end
				-- 			map("n", "`", close_file_browser)
				-- 			return true
				-- 		end,
				-- 	}
				-- }
			}
		end,
	},

	{
		"kyazdani42/nvim-tree.lua",
		keys = {
			{ "`", ":NvimTreeToggle<CR>", mode = "n" },
		},
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
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
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
		end,
	},

	{
		"tpope/vim-fugitive",
		lazy = true,
		event = { 'BufRead', 'BufNewFile' },
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		lazy = true,
		event = { 'BufRead', 'BufNewFile' },
	},

}

require("lazy").setup(plugins, {
	defaults = {
		-- Automatically use last semantic version
		version = "*",
	}
})

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
vim.api.nvim_set_keymap("n", "=", ":lua vim.lsp.buf.hover()<CR>", { noremap = true })

-- Autocommands
-- vim.api.nvim_create_autocmd({"BufWrite"}, {pattern="*", callback=vim.lsp.buf.formatting})

