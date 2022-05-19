bindkey -v

# Load zim modules
export ZIM_HOME=$HOME/.zim
[[ ! -f $ZIM_HOME/init.zsh ]] || source $ZIM_HOME/init.zsh

# Aliases
if [[ $XDG_CONFIG_HOME ]];
then
	NVIM_CONFIG_HOME=$XDG_CONFIG_HOME/nvim
else
	mkdir -p $HOME/.config/nvim
	NVIM_CONFIG_HOME=$HOME/.config/nvim
fi
alias vi=nvim
alias vim=nvim

# Source another optional script for system-dependent stuff
[[ ! -f ~/.zshrc2 ]] || source ~/.zshrc2
