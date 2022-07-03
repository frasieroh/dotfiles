bindkey -v

# Load zim modules
export ZIM_HOME=$HOME/.zim
# Performance tweaks for zsh-users/zsh-autosuggestions
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
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

alias ls="ls --color=always"
alias ll="ls -la --color=always"

# Source another optional script for system-dependent stuff
[[ ! -f ~/.zshrc2 ]] || source ~/.zshrc2
