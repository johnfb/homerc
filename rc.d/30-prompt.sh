#!/bin/sh

#export GIT_PS1_SHOWDIRTYSTATE=0
#export GIT_PS1_SHOWSTASHSTATE=0
#export GIT_PS1_SHOWUNTRACKEDFILES=0
GIT_PS1_SHOWCOLORHINTS=0

source $HOMERC/imported/git-prompt.sh

_PROMPT_COLOR_N='\['$(tput sgr0)'\]'
_PROMPT_COLOR_I='\['$(tput bold)'\]'
_PROMPT_COLOR_R='\['$(tput setaf 1)'\]' # red
_PROMPT_COLOR_G='\['$(tput setaf 2)'\]' # green
_PROMPT_COLOR_Y='\['$(tput setaf 3)'\]' # yellow
_PROMPT_COLOR_B='\['$(tput setaf 4)'\]' # blue
_PROMPT_COLOR_P='\['$(tput setaf 5)'\]' # purple
_PROMPT_COLOR_C='\['$(tput setaf 6)'\]' # cyan
_PROMPT_COLOR_LG='\['$(tput setaf 7)'\]' # light green
_PROMPT_COLOR_DG='\['$(tput setaf 8)'\]' # dark green
_PROMPT_COLOR_LB='\['$(tput setaf 12)'\]' # light blue
_PROMPT_COLOR_W='\['$(tput setaf 15)'\]' # white

jobscount() {
    local stopped=$(jobs -sp | wc -l)
    local running=$(jobs -rp | wc -l)
    ((running+stopped)) && echo -n " ${running}r/${stopped}s"
}

_prompt_conda() {
    local name
    local i
    if ((CONDA_SHLVL > 0)); then
        echo -n " ("
        for ((i=1; i <= CONDA_SHLVL; ++i)); do
            if ((i == CONDA_SHLVL)); then
                echo -n "${CONDA_PREFIX}"
            else
                name="CONDA_PREFIX_${i}"
                echo -n "${!name}:"
            fi
        done
        echo -n ")"
    fi
}

# Known return codes:
# If a command exits due to a signal n the shell return code will be 128+n
# If the command is not found the exit status is 127
# If the command is found but not executable the status is 126
# Built-ins return 2 on incorrect usage

_PROMPT_EXIT_STATUS=''

_prompt_format_exit_status() {
    local status=$1
    echo -n ${status}
    if ((status > 127)); then
        local signal
        if signal=$(kill -l $((status-128)) 2>/dev/null); then
            echo -n " (signal?: ${signal})"
        fi
    fi
}

_update_prompt () {
    local pipe_status=("${PIPESTATUS[@]}")

    if test -n "${TMUX}" && test -n "${SSH_AUTH_SOCK}"; then
        if ! test -S ${SSH_AUTH_SOCK}; then
            eval $(tmux show-environment -s)
        fi
    fi

    _PROMPT_EXIT_STATUS=''
    local st
    local num_non_zero=0
    for st in "${pipe_status[@]}"; do
        if [ $st -gt 0 ]; then
            let num_non_zero+=1
        fi
    done
    if [ $num_non_zero -gt 0 ]; then
        _PROMPT_EXIT_STATUS+='${_PROMPT_COLOR_R@P}${_PROMPT_COLOR_I@P}'
        if [ ${#pipe_status[@]} -gt 1 ]; then
            for ((i=0;i<${#pipe_status[@]};++i)); do
                _PROMPT_EXIT_STATUS+="# Return[${i}]: $(_prompt_format_exit_status ${pipe_status[$i]})"'\n'
            done
        else
            _PROMPT_EXIT_STATUS+="# Return: $(_prompt_format_exit_status ${pipe_status[0]})"'\n'
        fi
        _PROMPT_EXIT_STATUS+='${_PROMPT_COLOR_N@P}'
    fi
}
if ! grep "_update_prompt" <<< "$PROMPT_COMMAND" >/dev/null; then
    PROMPT_COMMAND="_update_prompt;${PROMPT_COMMAND}"
fi

PS1='\u@\H ${_PROMPT_COLOR_I@P}\w${_PROMPT_COLOR_N@P}'
PS1+='$(__git_ps1 " (%s)" || true)'
PS1+='$(jobscount || true)'
PS1+='$(_prompt_conda || true)'
PS1+='\n${_PROMPT_EXIT_STATUS@P}'
PS1+='${_PROMPT_COLOR_Y@P}[\!]${_PROMPT_COLOR_G@P}\$${_PROMPT_COLOR_N@P} '
