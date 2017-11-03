#!/bin/bash

if [ $?DEBUG ]
then
    DEBUG=false
fi

$DEBUG && echo "Setting up custom environment"

# I hate command not found handlers!!!
if type command_not_found_handle &> /dev/null; then
    $DEBUG && echo "Unsetting command_not_found_handle"
    unset -f command_not_found_handle
fi


if  [ -d ${HOME}/.profile.d ]
then
    PROFILE_DIR="${HOME}/.profile.d"

    for file in ${PROFILE_DIR}/*.sh
    do
        $DEBUG && echo "Loading profile script $f"
        . ${file}
    done

    unset PROFILE_DIR
fi

######
INIT_DIR=~/homerc/init
if [ -d $INIT_DIR ]; then
    for f in $INIT_DIR/*.init; do
        $DEBUG && echo "Loading init script $f"
        . $f
    done

    if [ -d $INIT_DIR/${HOSTNAME} ]
    then
        for f in $INIT_DIR/${HOSTNAME}/*.init; do
            $DEBUG && echo "Loading init script $f"
            . $f
        done
    fi
fi

