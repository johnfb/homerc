#!/bin/bash --rcfile

SELF_DIR="$( cd "$( dirname ${BASH_SOURCE[0]} )" && pwd )"

TMOUT=0
readonly TMOUT
export TMOUT

export HOME="${SELF_DIR}"
echo "Setting new home to ${HOME}"
source ${HOME}/.bashrc
