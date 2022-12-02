#!/bin/bash

#set -o trace

#------------------------------------------------------------------------------
#	Information
#------------------------------------------------------------------------------

author="James Chan"
email="ccchan0109@gmail.com"
version="1.1.1"
updateDate="2022/11/22"

#------------------------------------------------------------------------------
#	Parameters
#------------------------------------------------------------------------------

LINK=no
UNLINK=no
BOOTSTRAP=no
ALIAS=no
GITPROMPT=no

CONFIGS=(
	".vimrc"
	".tmux.conf"
	".gitconfig"
	".gitignore"
)

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
	$author - $email

VERSION:
	$version @ $updateDate

EOF
}

bootstrap()
{
	install_dependent_packages

	install_vim_neobundle

	link_configs

	echo "don't forget to set up git user name and email"
	echo "please relogin again to apply the setting"
}

install_dependent_packages()
{
	if [ "$EUID" == "0" ]; then
		apt update
		apt install -y ssh vim curl exuberant-ctags cscope make tmux sed silversearcher-ag cifs-utils
	else
		sudo apt update
		sudo apt install -y ssh vim curl exuberant-ctags cscope make tmux sed silversearcher-ag cifs-utils
	fi
}

install_vim_neobundle()
{
	curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh
}

install_git_prompt()
{
	if [ ! -d ~/.bash-git-prompt ]; then
		git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompta
		echo "source ~/.bash-git-prompta/gitprompt.sh" >> ~/.bashrc
	fi
}

add_alias()
{
	if [ ! -f ~/.bash_aliases ]; then
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
	else
		echo ".bash_aliases is already existed"
	fi
}

link() {
	config=$1

	if [ -L ~/$config ] && [ -e ~/$config ]; then
		echo "$config is already linked"
	else
		[ -f ~/$config ] && [ ! -f ~/${config}.bak ] && mv -f ~/$config ~/${config}.bak && echo "backup config $config to ${config}.bak"
		ln -sf $(pwd)/env/$config ~/$config
		echo "link of $config is built"
	fi
}

link_configs() {
	echo "linking config files..."

	for config in ${CONFIGS[@]}; do
		link $config
	done

	echo "linking config files done"
}

unlink() {
	config=$1

	if [ -L ~/$config ] && [ -e ~/$config ]; then
		rm -f ~/$config
		if [ -f ~/${config}.bak ]; then
			mv -f ~/${config}.bak ~/$config && echo "restore config $config from ~/${config}.bak"
		else
			echo "link of $config is removed"
		fi
	else
		echo "$config link is not existed"
	fi
}

unlink_configs() {
	echo "restore config files..."

	for config in ${CONFIGS[@]}; do
		unlink $config
	done

	echo "restore config files done"
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
		link_configs
	elif [ "$UNLINK" == "yes" ]; then
		unlink_configs
	elif [ "$ALIAS" == "yes" ]; then
		add_alias
	elif [ "$GITPROMPT" == "yes" ]; then
		install_git_prompt
	else
		usage
	fi
}

Main "$@"
