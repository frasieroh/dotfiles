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
# I think there's a bug in neovim. Without this syntax highlighting does
# not work, even though this is already in the runtime path!
export VIMRUNTIME=$NVIM_CONFIG_HOME
alias vi=$(which nvim)
alias vim=$(which nvim)

# Source another optional script for system-dependent stuff
[[ ! -f ~/.zshrc2 ]] || source ~/.zshrc2
