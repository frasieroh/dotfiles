bindkey -v

# Load zim modules
export ZIM_HOME=$HOME/.zim
[[ ! -f $ZIM_HOME/init.zsh ]] || source $ZIM_HOME/init.zsh

# Aliases
alias vi=$(which nvim)
alias vim=$(which nvim)

# Source another optional script for system-dependent stuff
[[ ! -f ~/.zshrc2 ]] || source ~/.zshrc2
