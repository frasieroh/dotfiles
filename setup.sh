#!/bin/bash

# Add symbolic links to home directory (admittedly this is crude)
echo 'Link dotfiles...'
rm -f $HOME/.tmux.conf
rm -f $HOME/.p10k.zsh
rm -f $HOME/.zshrc
rm -f $HOME/.vimrc
ln -s $PWD/.tmux.conf $HOME/.tmux.conf
ln -s $PWD/.p10k.zsh $HOME/.p10k.zsh
ln -s $PWD/.zshrc $HOME/.zshrc
ln -s $PWD/.vimrc $HOME/.vimrc

# Install oh-my-zsh and antigen
echo 'Install oh-my-zsh...'
export CHSH=no
export RUNZSH=no
export KEEP_ZSHRC=yes
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
curl -sL git.io/antigen > $HOME/.antigen.zsh

# Install vim-plug and plugins
echo 'Install vim-plug and plugins...'
curl -sfLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -es -u vimrc -i NONE -c "PlugInstall" -c "qa"

# Use zsh for interactive shells
echo 'Use zsh for interactive shells...'
cat << EOF >> ~/.bashrc
case \$- in
	(*i*) test -z "\$ARTEST_RANDSEED" -a -f \$(which zsh) && exec \$(which zsh);;
esac
EOF

echo 'All done!'
