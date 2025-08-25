# Global environment definitions needed for all setup
function _homerc_bash_version_at_least() {
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

if ! _homerc_bash_version_at_least 4; then
    if [[ $BASH != .local/bin/bash ]] && [ -x ~/.local/bin/bash ]; then
        exec ~/.local/bin/bash
    fi
fi

declare -A HOMERC_LOG_LEVEL_MAP=(["error"]=5 ["warn"]=4 ["info"]=3 ["debug"]=2 ["trace"]=1)

function HOMERC_LOG_TEST()
{
    [ ${HOMERC_LOG_LEVEL_MAP[$1]} -ge ${HOMERC_LOG_LEVEL} ]
}

function HOMERC_LOG()
{
    if HOMERC_LOG_TEST $1; then
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

function _homerc_redirect_stdout()
{
    if [[ $- != *i* ]]; then
        declare -g HOMERC_STDOUT
        exec {HOMERC_STDOUT}>&1
        exec >/dev/null
    fi
}

function _homerc_restore_stdout()
{
    if [[ $- != *i* ]]; then
        exec >&${HOMERC_STDOUT}-
        unset HOMERC_STDOUT
    fi
}

function _homerc_find_includes()
{
    local f
    if [ -d "$1" ]; then
        for f in "$1"/*.sh; do
            if [ -a "$f" ]; then
                printf '%q %q\n' "$(basename "$f")" "$f"
            fi
        done
        _homerc_find_includes "$1/${HOSTNAME}"
        _homerc_find_includes "$1/${HOSTTYPE}"
        _homerc_find_includes "$1/${MACHTYPE}"
    fi
}

function _homerc_gather_includes()
{
    local f base_f
    while read base_f f; do
        printf '%q\n' "${f}"
    done < <(
        (_homerc_find_includes "${HOME}/.profile.d"
        _homerc_find_includes "${HOMERC}/profile.d"
        if [[ $- == *i* ]]; then
            _homerc_find_includes "${HOMERC}/rc.d"
        fi) | sort
    )
}

function _homerc_base_setup()
{
    HOMERC_LOG info "Setting up custom environment ($-) ($(shopt login_shell))"
    _homerc_redirect_stdout
    local -a includes
    mapfile -t includes < <(_homerc_gather_includes)
    local f
    for f in "${includes[@]}"; do
        HOMERC_LOG info "Loading ${f}"
        source "${f}"
    done
    _homerc_restore_stdout
}

function _homerc_rc_setup()
{
    # Source global definitions
    local f
    for f in /etc/bashrc /etc/bash.bashrc; do
        if [ -f $f ]; then
            HOMERC_LOG info "Sourcing system global definitions from $f"
            . $f
        fi
    done
    _homerc_base_setup
}

function _homerc_profile_setup()
{
    _homerc_base_setup
}

HOMERC_LOG debug "HOMERC=${HOMERC}"
