#!/bin/bash
if [[ -z "$(which zsh)" ]]
then
	echo 'Install zsh'
	exit 1
fi
if [[ $OSTYPE == linux* ]]
then
	NVIM_DL_NAME='nvim-linux64'
	NVIM_DIR_NAME='nvim-linux64'
fi
if [[ $OSTYPE == darwin* ]]
then
	NVIM_DL_NAME='nvim-macos'
	NVIM_DIR_NAME='nvim-macos'
fi
if [[ $NVIM_DL_NAME == "" ]]
then
	echo "Unrecognized OS type $OSTYPE"
	exit 1
fi

echo 'Linking dotfiles...'
update_link() {
	# Backup old dotfiles at <dotfiles>.old and create new symlink
	cp -rL "$1" "$1.old" 2>/dev/null
	rm -f "$1"
	ln -s "$2" "$1"
}
update_link "$HOME/.tmux.conf" "$PWD/.tmux.conf"
update_link "$HOME/.zshrc" "$PWD/.zshrc"
update_link "$HOME/.zshenv" "$PWD/.zshenv"
update_link "$HOME/.zprofile" "$PWD/.zprofile"
update_link "$HOME/.zimrc" "$PWD/.zimrc"
update_link "$HOME/.vimrc" "$PWD/.vimrc"
if [[ $XDG_CONFIG_HOME ]];
then
	NVIM_CONFIG_HOME=$XDG_CONFIG_HOME/nvim
else
	mkdir -p "$HOME/.config/nvim"
	NVIM_CONFIG_HOME=$HOME/.config/nvim
fi
update_link "$NVIM_CONFIG_HOME/init.lua" "$PWD/init.lua"
update_link "$NVIM_CONFIG_HOME/lazy-lock.json" "$PWD/lazy-lock.json"

echo 'Install neovim...'
NVIM_V='v0.8.1'
LOCAL="$HOME/.local"
curl -L "https://github.com/neovim/neovim/releases/download/$NVIM_V/$NVIM_DL_NAME.tar.gz" | tar zxf -
mkdir -p "$LOCAL"
if [[ $OSTYPE == linux* ]]
then
	cp -R "$NVIM_DIR_NAME"/* "$LOCAL"
else
	# MacOS cp hates globs
	cp -R "$NVIM_DIR_NAME/" "$LOCAL"
fi
rm -rf "$NVIM_DIR_NAME"

echo 'Install zim...'
export ZIM_HOME=$HOME/.zim
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o "${ZIM_HOME}/zimfw.zsh" \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi
zsh "$ZIM_HOME/zimfw.zsh" init
zsh "$ZIM_HOME/zimfw.zsh" install
zsh "$ZIM_HOME/zimfw.zsh" list

echo 'All done!'

