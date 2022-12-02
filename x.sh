#!/bin/bash

#set -o trace

#------------------------------------------------------------------------------
#	Information
#------------------------------------------------------------------------------

author="James Chan"
email="ccchan0109@gmail.com"
version="1.1.2"
updateDate="2022/12/02"

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
	".bash_aliases"
)

#------------------------------------------------------------------------------
#	Colors
#------------------------------------------------------------------------------

COLOR_OFF='\033[0m'
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

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

	install_git_prompt

	link_configs

	add_alias

	echo -e "don't forget to ${GREEN}set up git user name and email${COLOR_OFF}"
	echo -e "please ${GREEN}relogin${COLOR_OFF} again to apply the setting"
}

install_dependent_packages()
{
	if [ "$EUID" == "0" ]; then
		apt update
		apt install -y ssh vim curl exuberant-ctags cscope make tmux sed silversearcher-ag cifs-utils git
	else
		sudo apt update
		sudo apt install -y ssh vim curl exuberant-ctags cscope make tmux sed silversearcher-ag cifs-utils git
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
		source_to_bashrc "~/.bash-git-prompta/gitprompt.sh"
	fi
}

source_to_bashrc()
{
	local config=$1
	cmd="source $config"

	if ! grep -Fxq "$cmd" ~/.bashrc ; then
		echo "$cmd" >> ~/.bashrc
	fi
}

add_alias()
{
	link ".bash_aliases"
	source_to_bashrc "~/.bash_aliases"
}

link() {
	local config=$1

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
	local config=$1

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
