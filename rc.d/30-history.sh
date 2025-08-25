#!/bin/sh

HISTIGNORE="ls"
HISTCONTROL="ignoredups"
HISTFILE="${HOME}/.history/bash_${HOSTNAME}"
mkdir -p "${HOME}/.history"

if _homerc_bash_version_at_least 4 3; then
    # No limit to history
    HISTFILESIZE=-1
    HISTSIZE=-1
else
    # Pick some arbitrary large size
    HISTFILESIZE=100000000
    HISTSIZE=100000000
fi

shopt -s histappend # Make history consistent between sessions
history -a
