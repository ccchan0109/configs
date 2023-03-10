# tmux related
alias tmux='TERM=screen-256color-bce tmux'
alias tt='tmux new -s'
alias ttk='tmux kill-session -t'
alias tta='tmux attach-session -t'
alias ttl='tmux list-sessions'

# basic
alias sd='pushd > /dev/null'
alias pd='popd > /dev/null'
alias cd='sd'
alias ls='ls --color=always'
alias ll='ls -al'
alias gp='grep'

# source bashrc
alias sb='source ~/.bashrc'

# check disk space
# df -hl  # check remaining disk space
# du -sh . # check total used space for current folder

# shorthand
alias where='whereis'
alias findname='find . -name'

# git related
alias pl='git stash; git pl; git stash pop'