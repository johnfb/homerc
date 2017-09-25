#!/bin/bash

if [ ! $EDITOR ]; then
	export EDITOR=vim
fi

if [ ! $CCACHE_DIR ]; then
    export CCACHE_DIR=/tmp/johnfb-ccache
fi

case $PATH in
    *~/$MACHTYPE/bin:~/bin*) ;;
    *) export PATH=~/$MACHTYPE/bin:~/bin:$PATH ;;
esac

if [ ! $PKG_CONFIG_PATH ]; then
	export PKG_CONFIG_PATH=~/$MACHTYPE/lib/pkgconfig
fi

if [ ! $PYTHONPATH ]; then
    export PYTHONPATH=~/$MACHTYPE/lib:~/$MACHTYPE/lib64:$PYTHONPATH
fi

if [ ! $LD_LIBRARY_PATH ]; then
    export LD_LIBRARY_PATH=~/$MACHTYPE/lib:~/lib
fi

