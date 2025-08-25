#!/bin/bash

export PATH LD_LIBRARY_PATH PKG_CONFIG_PATH PYTHONPATH MANPATH CMAKE_SYSTEM_PREFIX_PATH PYTHONHOMESITE

add_path() {
    #echo "Checking $1=${!1}"
    if [ ! "${!1}" ]; then
        HOMERC_LOG info "Setting ""$1"" to: $2"
        export $1=$2
    else
        if [[ ":${!1}:" != *":$2:"* ]]; then
            HOMERC_LOG info "Adding ""$2"" to $1"
            export $1="$2:${!1}"
        fi
    fi
}

remove_path() {
    HOMERC_LOG info "Removing ""$2"" from $1"
    local v=":${!1}:"
    local s=":$2:"
    v="${v//$s/:}"
    v="${v#:}"
    v="${v%:}"
    export $1="$v"
}

std_path_env() {
    if [ -d "$1" ]; then

        $2 CMAKE_PREFIX_PATH "$1"

# binary directories
        if [ -d "$1/bin" ]; then
            $2 PATH "$1/bin"
        fi

        if [ -d "$1/sbin" ]; then
            $2 PATH "$1/sbin"
        fi

# python directories
        $2 PYTHONHOMESITE "${1}"

# library directories
        local lib
        for lib in "$1/lib" "$1/lib64"; do
            if [ -d "$lib" ]; then
                $2 LD_LIBRARY_PATH "$lib"
                $2 PKG_CONFIG_PATH "$lib/pkgconfig"
            fi
        done

# man directories
        if [ -d "$1/share/man" ]; then
            $2 MANPATH "$1/share/man"
        fi
        std_path_env "$1/usr" $2
    fi
}

add_path_env() {
    std_path_env "$1" add_path
}

rem_path_env() {
    std_path_env "$1" remove_path
}

init_default_paths()
{
    local DEFAULT_ROOTS=(
        "/opt"
        "/opt/local"
        "${HOME}"
        "${HOME}/.local"
        "${HOME}/.local/${MACHTYPE}"
        "${HOME}/.local/${HOSTTYPE}"
        "${HOME}/.local/${HOSTNAME}"
    )
    local dir
    for dir in "${DEFAULT_ROOTS[@]}"; do
        add_path_env $dir
    done
    # Ensure MANPATH has a : in it so that default path elements are added
    add_path MANPATH ":"
}

ensure_abs_path() {
    local p="${1%/}"
    if [[ "$p" != /* ]]; then
        local rp=$(type -p realpath)
        if [ "x$rp" != "x" ]; then
            $rp $p
        else
            readlink -f "$p"
        fi
    else
        echo $p
    fi
}

init_path() {
    if [ "x$1" != "x" ]; then
        local p=$(ensure_abs_path $1)
        if [ "x$p" == "x" ]; then
            return
        fi
        echo "Setting paths for $p"
        add_path_env "$p"
    else
        echo "Setting paths for $(pwd)"
        add_path_env "$(pwd)"
    fi
}

deinit_path() {
    if [ "x$1" != "x" ]; then
        local p=$(ensure_abs_path $1)
        if [ "x$p" == "x" ]; then
            return
        fi
        echo "Unsetting paths for $p"
        rem_path_env "$p"
    else
        echo "Unsetting paths for $(pwd)"
        rem_path_env "$(pwd)"
    fi
}

print_path() {
    local old=$IFS; IFS=:
    printf "\n--- PATH\n"
    printf "%s\n" ${PATH}
    printf "\n--- LD_LIBRARY_PATH\n"
    printf "%s\n" ${LD_LIBRARY_PATH}
    printf "\n--- PKG_CONFIG_PATH\n"
    printf "%s\n" ${PKG_CONFIG_PATH}
    printf "\n--- CMAKE_PREFIX_PATH\n"
    printf "%s\n" ${CMAKE_PREFIX_PATH}
    printf "\n--- PYTHONPATH\n"
    printf "%s\n" ${PYTHONPATH}
    printf "\n--- PYTHONHOMESITE\n"
    printf "%s\n" ${PYTHONHOMESITE}
    IFS=$old
}

init_default_paths
