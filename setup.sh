#!/bin/bash

OS=''
if [[ $OSTYPE == linux* ]]
then
	NVIM_DL_NAME='nvim-linux64'
	NVIM_DIR_NAME='nvim-linux64'
fi
if [[ $OSTYPE == darwin* ]]
then
	NVIM_DL_NAME='nvim-macos'
	NVIM_DIR_NAME='nvim-osx64'
fi
if [[ $NVIM_DL_NAME == "" ]]
then
	echo 'Fuck!'
	exit 1
fi

echo 'Link dotfiles...'
rm -f $HOME/.tmux.conf
rm -f $HOME/.zshrc
rm -f $HOME/.zshenv
rm -f $HOME/.zprofile
rm -f $HOME/.zimrc
rm -f $HOME/.vimrc
ln -s $PWD/.tmux.conf $HOME/.tmux.conf
ln -s $PWD/.zshrc $HOME/.zshrc
ln -s $PWD/.zshenv $HOME/.zshenv
ln -s $PWD/.zprofile $HOME/.zprofile
ln -s $PWD/.zimrc $HOME/.zimrc
ln -s $PWD/.vimrc $HOME/.vimrc
if [[ $XDG_CONFIG_HOME ]];
then
	NVIM_CONFIG_HOME=$XDG_CONFIG_HOME/nvim
else
	mkdir -p $HOME/.config/nvim
	NVIM_CONFIG_HOME=$HOME/.config/nvim
fi
rm -f $NVIM_CONFIG_HOME/init.lua
ln -s $PWD/init.lua $NVIM_CONFIG_HOME/init.lua

echo 'Install neovim...'
NVIM_V='v0.7.0'
LOCAL="$HOME/.local"
curl -L https://github.com/neovim/neovim/releases/download/$NVIM_V/$NVIM_DL_NAME.tar.gz | tar zxf -
mkdir -p $LOCAL/bin
mkdir -p $LOCAL/share/nvim
mv -f $NVIM_DIR_NAME/bin/nvim $LOCAL/bin/nvim
cp -R $NVIM_DIR_NAME/share/nvim/* $LOCAL/share/nvim/
rm -rf $NVIM_DIR_NAME

echo 'Install zim...'
export ZIM_HOME=$HOME/.zim
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi
zsh $ZIM_HOME/zimfw.zsh init
zsh $ZIM_HOME/zimfw.zsh install
zsh $ZIM_HOME/zimfw.zsh list
echo 'All done! Start nvim to install packer plugins.'
