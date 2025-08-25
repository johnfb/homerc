#!/bin/sh

#export GIT_PS1_SHOWDIRTYSTATE=0
#export GIT_PS1_SHOWSTASHSTATE=0
#export GIT_PS1_SHOWUNTRACKEDFILES=0
GIT_PS1_SHOWCOLORHINTS=0

source $HOMERC/imported/git-prompt.sh

# From man page the "portable definitions" of the forground color numbers are:
# 0 - black   #000000
# 1 - red     #FF0000
# 2 - green   #00FF00
# 3 - yellow  #FFFF00
# 4 - blue    #0000FF
# 5 - magenta #FF00FF
# 6 - cyan    #00FFFF
# 7 - white   #FFFFFF

_COLOR_N=$(tput sgr0)    # reset
_COLOR_R=$(tput setaf 1) # red
_COLOR_G=$(tput setaf 2) # green
_COLOR_Y=$(tput setaf 3) # yellow
_COLOR_B=$(tput setaf 4) # blue
_COLOR_P=$(tput setaf 5) # purple
_COLOR_C=$(tput setaf 6) # cyan
_COLOR_W=$(tput setaf 7) # white
_PROMPT_COLOR_N='\['$(tput sgr0)'\]'    # reset
_PROMPT_COLOR_R='\['$(tput setaf 1)'\]' # red
_PROMPT_COLOR_G='\['$(tput setaf 2)'\]' # green
_PROMPT_COLOR_Y='\['$(tput setaf 3)'\]' # yellow
_PROMPT_COLOR_B='\['$(tput setaf 4)'\]' # blue
_PROMPT_COLOR_P='\['$(tput setaf 5)'\]' # purple
_PROMPT_COLOR_C='\['$(tput setaf 6)'\]' # cyan
_PROMPT_COLOR_W='\['$(tput setaf 7)'\]' # white

_prompt_jobscount() {
    local stopped=$(jobs -sp | wc -l)
    local running=$(jobs -rp | wc -l)
    ((running+stopped)) && echo -n " ${running}r/${stopped}s"
}

_prompt_shutdown() {
    if [ -f /run/systemd/shutdown/scheduled ]; then
        echo -n ${_PROMPT_COLOR_P}
        print-shutdown
        echo -n ${_PROMPT_COLOR_N}
    fi
}

_prompt_conda() {
    local name
    local i
    if ((CONDA_SHLVL > 0)); then
        echo -n " (${_PROMPT_COLOR_P}"
        for ((i=1; i <= CONDA_SHLVL; ++i)); do
            if ((i == CONDA_SHLVL)); then
                echo -n "${CONDA_PREFIX}"
            else
                name="CONDA_PREFIX_${i}"
                echo -n "${!name}:"
            fi
        done
        echo -n "${_PROMPT_COLOR_N})"
    fi
    if [ -n "${VIRTUAL_ENV}" ]; then
        echo -n " (venv: ${_PROMPT_COLOR_P}"
        echo -n "${VIRTUAL_ENV}"
        echo -n "${_PROMPT_COLOR_N})"
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

_prompt_update () {
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
        _PROMPT_EXIT_STATUS+="${_PROMPT_COLOR_R}"
        if [ ${#pipe_status[@]} -gt 1 ]; then
            for ((i=0;i<${#pipe_status[@]};++i)); do
                _PROMPT_EXIT_STATUS+="# Return[${i}]: $(_prompt_format_exit_status ${pipe_status[$i]})"'\n'
            done
        else
            _PROMPT_EXIT_STATUS+="# Return: $(_prompt_format_exit_status ${pipe_status[0]})"'\n'
        fi
        _PROMPT_EXIT_STATUS+="${_PROMPT_COLOR_N}"
    fi
    PS1="$(_prompt_shutdown || true)\\[\\033]0;\\]\\u@\\h \\w\\[\\007\\]\\u@\\H ${_PROMPT_COLOR_B}\\w${_PROMPT_COLOR_N}"
    PS1+="\$(__git_ps1 \" (%s)\" || true)"
    PS1+="$(_prompt_jobscount || true)"
    PS1+="$(_prompt_conda || true)"
    PS1+="\\n${_PROMPT_EXIT_STATUS}"
    PS1+="${_PROMPT_COLOR_Y}[\\!]${_PROMPT_COLOR_G}\\$ ${_PROMPT_COLOR_N}"
}
if [[ "${PROMPT_COMMAND}" != *_prompt_update* ]]; then
    PROMPT_COMMAND="_prompt_update;${PROMPT_COMMAND}"
fi

