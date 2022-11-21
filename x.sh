#!/bin/bash

#set -o trace

#------------------------------------------------------------------------------
#	Parameters
#------------------------------------------------------------------------------

LINK=no
UNLINK=no
BOOTSTRAP=no
ALIAS=no
GITPROMPT=no

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
	-g		Install git-prompt for bash
	-h		Show this usage

AUTHOR:
	James Chan - ccchan0109@gmail.com

VERSION:
	1.1.0 @ 2022/11/4
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

	echo "please relogin again to apply the setting"
}

install_prompt()
{
	if [ ! -d ~/.bash-git-prompt ]; then
		git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompta
		echo "source ~/.bash-git-prompta/gitprompt.sh" >> ~/.bashrc
	fi
}

add_alias()
{
	if [ ! -d ~/.bash_aliases ]; then
		echo "alias tmux='TERM=screen-256color-bce tmux'" >> ~/.bash_aliases
		echo "alias tt='tmux new -s'" >> ~/.bash_aliases
		echo "alias ttk='tmux kill-session -t'" >> ~/.bash_aliases
		echo "alias tta='tmux attach-session -t'" >> ~/.bash_aliases
		echo "alias ttl='tmux list-sessions'" >> ~/.bash_aliases
		echo "alias sd='pushd > /dev/null'" >> ~/.bash_aliases
		echo "alias pd='popd > /dev/null'" >> ~/.bash_aliases
		echo "alias cd='sd'" >> ~/.bash_aliases
		echo "alias ll='ls -al --color=auto'" >> ~/.bash_aliases

		# update to .bashrc
		echo "source ~/.bash_aliases" >> ~/.bashrc
	fi
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
	while getopts "hbluag" OPTION
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
			g)
				GITPROMPT=yes
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
	elif [ "$GITPROMPT" == "yes" ]; then
		install_prompt
	else
		usage
	fi
}

Main "$@"
