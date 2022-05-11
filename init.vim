set runtimepath^=~/.vim runtimepath+=~/.vim/after runtimepath+=~/.config/nvim
let &packpath = &runtimepath
source ~/.vimrc

lua << EOF
require('neorg').setup {
	load = {
		["core.defaults"] = {},
		["core.norg.qol.toc"] = {},
		["core.norg.dirman"] = {},
		["core.norg.journal"] = {},
		["core.gtd.base"] = {},
		["core.export"] = {},
	}
}
require('nvim-treesitter.configs').setup {
	ensure_installed = { "norg" },
	highlight = {
		enable = true,
	}
}
EOF
