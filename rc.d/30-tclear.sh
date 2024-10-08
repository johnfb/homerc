#!/bin/bash
tclear() {
    clear
    if test $TMUX; then
        tmux clear-history
    fi
}

tenv() {
    eval $(tmux show-environment -s)
}
