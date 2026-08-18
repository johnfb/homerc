#!/bin/bash
alias pd='pushd'
alias pop='popd'
alias rd='pushd +1'
alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias m='make -j $(nproc) -l $(nproc)'

if type -p xdg-open > /dev/null; then
    alias open='xdg-open'
fi
