ZSH_DISABLE_COMPFIX=true

# If you come from bash you might have to change your $PATH.
export ZSH=$HOME/.oh-my-zsh

DISABLE_AUTO_UPDATE="true"

# Plugins
source ~/antigen.zsh

antigen use oh-my-zsh
antigen bundle git
antigen bundle jeffreytse/zsh-vi-mode
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen theme frasieroh/theme

antigen apply

bindkey -v

# Source another optional script for system-dependent stuff
[[ ! -f ~/.zshrc2 ]] || source ~/.zshrc2
