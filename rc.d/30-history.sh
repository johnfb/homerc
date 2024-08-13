#!/bin/sh

export FIGNORE="~:%:.o:CVS:SCCS:.DS_Store:.AppleDouble:.svn"
export HISTIGNORE="ls"
export HISTCONTROL="ignoredups"
export HISTFILE="${HOME}/.history/bash_$(hostname -s 2>/dev/null)"
mkdir -p "${HOME}/.history"

function _bash_version_at_least() {
    local v
    for v in "${BASH_VERSINFO[@]}"; do
        if [ -z "$1" ]; then
            return 0
        fi
        if [ $v -lt $1 ]; then
            return 1
        elif [ $v -gt $1 ]; then
            return 0
        fi
        shift
    done
    return 0
}

if _bash_version_at_least 4 3; then
    # No limit to history
    export HISTFILESIZE=-1
    export HISTSIZE=-1
else
    # Pick some arbitrary large size
    export HISTFILESIZE=100000000
    export HISTSIZE=100000000
fi
unset -f _bash_version_at_least

shopt -s histappend # Make history consistent between sessions
history -a
