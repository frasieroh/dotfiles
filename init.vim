set runtimepath^=~/.vim runtimepath+=~/.vim/after runtimepath+=~/.config/nvim
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
EOF
