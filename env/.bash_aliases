# tmux related
alias tmux='TERM=screen-256color-bce tmux'
alias tt='tmux new -s'
alias ttk='tmux kill-session -t'
alias tta='tmux attach-session -t'
alias ttl='tmux list-sessions'
alias ttlk='tmux list-keys'

# basic
alias sd='pushd > /dev/null'
alias pd='popd > /dev/null'
alias cd='sd'
alias ls='ls --color=always'
alias ll='ls -al'

# find [path] [expression]
# -name [filename]: find files matching [filename]
# -type [filetype]: find files matching [filetype]
alias fn='find . -name'

# grep [options] pattern [files...]
# -r: recursively search folder
# -R: recursively search folder, and resolve symbolic links
# -n: print the line number
# -i: ignore cases
# -w: match entire word, not part of word
alias gp='grep -rn'

# source bashrc
alias sb='source ~/.bashrc'

# check disk space
# df -hl  # check remaining disk space
# du -sh . # check total used space for current folder

# shorthand
alias where='whereis'

# to see the definition of a function
alias def='declare -f'

# git related
alias pl='git stash; git pl; git stash pop'