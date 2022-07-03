bindkey -v

# Source another optional script for system-dependent stuff
[[ ! -f ~/.zshrc2 ]] || source ~/.zshrc2

# Load zim modules
export ZIM_HOME=$HOME/.zim
# Performance tweaks for zsh-users/zsh-autosuggestions
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
[[ ! -f $ZIM_HOME/init.zsh ]] || source $ZIM_HOME/init.zsh

# Aliases and interactive env vars
alias vi=nvim
alias vim=nvim
alias ls="ls --color=always"
alias ll="ls -la --color=always"
export EDITOR=nvim
export VISUAL=nvim

# Source another optional script for system-dependent stuff
[[ ! -f ~/.zshrc3 ]] || source ~/.zshrc3
