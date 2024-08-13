#!/bin/bash
export NINJA_STATUS='[%u/%r/%f] '
if [ -z "$(type -p ninja)" ]; then
    if type -p ninja-build > /dev/null; then
        alias ninja=ninja-build
    fi
fi
