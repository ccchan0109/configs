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
alias ll='ls -al --color=auto'

# shorthand
alias where='whereis'
alias findname='find . -name'