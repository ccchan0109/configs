#!/bin/bash

#set -o trace

#------------------------------------------------------------------------------
#	Parameters
#------------------------------------------------------------------------------

LINK=no
UNLINK=no
BOOTSTRAP=no
ALIAS=no

#------------------------------------------------------------------------------
#	Functions
#------------------------------------------------------------------------------

usage()
{
cat <<EOF
usage: $0 OPTIONS [OPTARGS]

OPTIONS:
	-b		Bootstrap the environment with link config files
	-l		Link config files
	-u		Unlink (restore) config files
	-a		Add Alias
	-h		Show this usage

AUTHOR:
	James Chan - ccchan0109@gmail.com

VERSION:
	1.0.2 @ 2019/10/8
	1.0.1 @ 2017/8/24

EOF
}

bootstrap()
{
	sudo apt update
	sudo apt install -y ssh vim curl ctags cscope make tmux sed silversearcher-ag cifs-utils

	curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh

	link
	install_prompt

	echo "please relogin again to apply the setting"
}

install_prompt()
{
	if [ ! -d ~/.bash-git-prompt ]; then
		git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompta

		update_bashrc
	fi
}

update_bashrc()
{
	echo "source ~/.bash-git-prompta/gitprompt.sh" >> ~/.bashrc
}

add_alias()
{
	echo "alias tmux='TERM=screen-256color-bce tmux'" >> ~/.bash_aliases
	echo "alias tt='tmux new -s'" >> ~/.bash_aliases
	echo "alias ttk='tmux kill-session -t'" >> ~/.bash_aliases
	echo "alias tta='tmux attach-session -t'" >> ~/.bash_aliases
	echo "alias sd='pushd > /dev/null'" >> ~/.bash_aliases
	echo "alias pd='popd > /dev/null'" >> ~/.bash_aliases
	echo "alias cd='sd'" >> ~/.bash_aliases
}

link() {
	echo "Linking config files in env/"


	configs=$(find env/ -maxdepth 1 -xtype f)
	for config in $configs; do
		config=$(basename $config)
		[ -f ~/$config ] && [ ! -f ~/${config}.bak ] && mv -f ~/$config ~/${config}.bak && echo "backup config $config to ${config}.bak"
		ln -sf $(pwd)/env/$config ~/$config
	done
}

unlink() {
	echo "Restore config files"

	configs=$(find env/ -maxdepth 1 -xtype f)
	for config in $configs; do
		config=$(basename $config)
		rm -f ~/$config && mv -f ~/${config}.bak ~/$config
	done
}

#------------------------------------------------------------------------------
#	Main
#------------------------------------------------------------------------------

Main() {
	while getopts "hblua" OPTION
	do
		case $OPTION in
			h)
				usage
				exit 1
				;;
			b)
				BOOTSTRAP=yes
				;;
			l)
				LINK=yes
				;;
			u)
				UNLINK=yes
				;;
			a)
				ALIAS=yes
				;;
			?)
				usage
				exit 1
				;;
		esac
	done

	if [ "$BOOTSTRAP" == "yes" ]; then
		bootstrap
	elif [ "$LINK" == "yes" ]; then
		link
	elif [ "$UNLINK" == "yes" ]; then
		unlink
	elif [ "$ALIAS" == "yes" ]; then
		add_alias
	else
		usage
	fi
}

Main "$@"
