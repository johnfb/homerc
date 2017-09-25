#/etc/skel/local.[bash_]profile     2005-05-27 zagar@arlut.utexas.edu

DEBUG=false
$DEBUG && echo "Setting up custom environment"

if [ "$PS1" ]; then
    stty istrip
fi
#PATH=/bin:/usr/bin
#export PATH

if [[ $TERM == *screen* ]]; then
    if [ -e /usr/share/terminfo/s/screen-256color ]; then
        export TERM='screen-256color'
    fi
else
    if [ -e /usr/share/terminfo/x/xterm-256color ]; then
        export TERM='xterm-256color'
    else
        export TERM='xterm-color'
    fi
fi

$DEBUG && echo "Setting terminal colors: $TERM"


if  [ $?HOSTNAME ]
then
    HOSTNAME="`uname -n | cut -d. -f1`"
    export HOSTNAME
fi
$DEBUG && echo "Running on $HOSTNAME"

# I hate command not found handlers!!!
if type command_not_found_handle &> /dev/null; then
    $DEBUG && echo "Unsetting command_not_found_handle"
    unset -f command_not_found_handle
fi

######
# User Customizations



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

