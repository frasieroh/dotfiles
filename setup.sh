#!/bin/bash

OS=''
if [[ $OSTYPE == linux* ]]
then
	OS='linux64'
fi
if [[ $OSTYPE == darwin* ]]
then
	OS='macos'
fi
if [[ $OS == "" ]]
then
	echo 'OS not detected'
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
ln -s $PWD/init.vim $NVIM_CONFIG_HOME/init.vim

echo 'Install neovim...'
NVIM_V='v0.7.0'
NVIM_NAME="nvim-$OS"
NVIM_PATH="$HOME/.local/bin/nvim"
wget -O - https://github.com/neovim/neovim/releases/download/$NVIM_V/$NVIM_NAME.tar.gz | tar zxf -
mkdir -p $HOME/.local/bin
mv -f $NVIM_NAME/bin/nvim $NVIM_PATH
cp -rT $NVIM_NAME/share/nvim/runtime $NVIM_CONFIG_HOME
rm -rf $NVIM_NAME

# Install zim
echo 'Install zim...'
export ZIM_HOME=$HOME/.zim
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi
zsh $ZIM_HOME/zimfw.zsh init
zsh $ZIM_HOME/zimfw.zsh install

# Install vim-plug and plugins
echo 'Install vim-plug and plugins...'
curl -sfLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
$NVIM_PATH -es -u $HOME/.vimrc -i NONE -c "PlugInstall" -c "qa"

echo 'All done!'
