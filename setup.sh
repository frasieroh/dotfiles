#!/bin/bash

# Install oh-my-zsh and antigen
export CHSH=no
export RUNZSH=no
export KEEP_ZSHRC=yes
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
curl -L git.io/antigen > $HOME/.antigen.zsh

# Install vim plugins
vim +PlugInstall +qall

# Add symbolic links to home directory (admittedly this is crude)
rm $HOME/.tmux.conf
rm $HOME/.p10k.zsh
rm $HOME/.zshrc
rm $HOMR/.vimrc
ln -s .tmux.conf $HOME/.tmux.conf
ln -s .p10k.zsh $HOME/.p10k.zsh
ln -s .zshrc $HOME/.zshrc
ln -s .vimrc $HOME/.vimrc

# Use zsh for interactive shells
cat << EOF >> ~/.bashrc
case \$- in
	(*i*) test -z "\$ARTEST_RANDSEED" -a -f \$(which zsh) && exec \$(which zsh);;
esac
EOF
