#!/bin/bash

#set -o trace

#------------------------------------------------------------------------------
#	Parameters
#------------------------------------------------------------------------------

LINK=no
UNLINK=no
BOOTSTRAP=no

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
	-h		Show this usage

AUTHOR:
	James Chan - ccchan0109@gmail.com

VERSION:
	1.0.0 @ 2017/8/1

EOF
}

bootstrap()
{
	apt update || sudo apt update
    apt install -y ssh vim curl ctags cscope make tmux sed silversearcher-ag cifs-utils

	curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh

	link

	git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt

	echo "source ~/.bash-git-prompt/gitprompt.sh" >> ~/.bashrc
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
	echo "Resore config files"

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
	while getopts "hblu" OPTION
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
	else
		usage
	fi
}

Main "$@"
