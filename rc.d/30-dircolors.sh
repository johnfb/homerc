#!/bin/bash
case $(uname -s) in
Darwin)
    alias ls="ls -FG"
    ;;
Linux)
    if [ -z "$LS_COLORS" ] && type -p dircolors > /dev/null; then
        eval $(dircolors 2> /dev/null)
    fi
    alias ls="ls -F --color=auto"
    ;;
esac
