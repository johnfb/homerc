#!/bin/bash

declare -A HOMERC_LOG_LEVEL_MAP=(["error"]=5 ["warn"]=4 ["info"]=3 ["debug"]=2 ["trace"]=1)
function HOMERC_LOG()
{
    if [ ${HOMERC_LOG_LEVEL_MAP[$1]} -ge ${HOMERC_LOG_LEVEL} ]; then
        shift
        echo "$@" >&2
    fi
}
if [ -z ${HOMERC_LOG_LEVEL} ]; then
    if [[ $- == *i* ]] && shopt -q login_shell; then
        HOMERC_LOG_LEVEL=${HOMERC_LOG_LEVEL_MAP["warn"]}
    else
        HOMERC_LOG_LEVEL=${HOMERC_LOG_LEVEL_MAP["error"]}
    fi
fi
HOMERC="${HOME}/homerc"

HOMERC_LOG debug "HOMERC=${HOMERC}"
HOMERC_LOG info "Setting up custom environment ($-) ($(shopt login_shell))"

function _find_includes() {
    local f
    if [ -d "$1" ]; then
        for f in $(find "$1" -maxdepth 1 -type f -iname '*.sh'); do
            echo $(basename $f) $f
        done
        _find_includes "$1/$(hostname -s)"
        _find_includes "$1/$(hostname -f)"
        _find_includes "$1/${HOSTTYPE}"
        _find_includes "$1/${MACHTYPE}"
    fi
}

if [[ $- != *i* ]]; then
    exec {HOMERC_STDOUT}>&1
    exec >/dev/null
fi

while read base_f f; do
    HOMERC_LOG info "Loading ${f}"
    source ${f}
done < <( (
_find_includes "${HOME}/.profile.d"
_find_includes "${HOMERC}/profile.d"
if [[ $- == *i* ]]; then
    _find_includes "${HOMERC}/rc.d"
fi) | sort -n)


if [[ $- != *i* ]]; then
    exec >&${HOMERC_STDOUT}-
    unset HOMERC_STDOUT
fi

unset -f _find_includes
unset f base_f

HOMERC_LOG_LEVEL=${HOMERC_LOG_LEVEL_MAP["info"]}
