set runtimepath^=~/.vim runtimepath+=~/.vim/after runtimepath+=/usr/share/vim/vimfiles
let &packpath = &runtimepath
source ~/.vimrc

lua << EOF

-- My defaults
local dirmanConfig = {}
local journalConfig = nil
local gtdConfig = nil
-- Include an accessory lua file for system-local definitions
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
require('nvim-tree').setup {}

-- LSP configuration
local lspconfig = require('lspconfig')
if lspconfig.artaclsp ~= nil then
	-- This server is not always installed.
	lspconfig.artaclsp.setup{}
end
lspconfig.clangd.setup {
	cmd = { 'clangd', '-j=8' },
}
lspconfig.gopls.setup {}

-- Linter configuration
require('lint').linters_by_ft = {
  python = {'pylint',},
  sh = {'shellcheck',},
}

EOF
