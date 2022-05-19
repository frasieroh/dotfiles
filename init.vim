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
require('nvim-treesitter.configs').setup {
	ensure_installed = { "norg" },
	highlight = {
		enable = true,
	}
}
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
require('nvim-tree').setup {}
EOF
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
    \   'arrow_open': ">",
    \   'arrow_closed': "<",
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': ".",
    \   'symlink': "",
    \   'symlink_open': "",
    \   }
    \ }
