#!/bin/sh

OLDPATH="$PATH"
OLDTZ="$TZ"
source @myenvpath@

PATH="$PATH:$OLDPATH"
export PS1="\n@name@:[\u@\h:\w]\$ "
export NIX_MYENV_NAME="@name@"
export buildInputs
export NIX_STRIP_DEBUG=0
export TZ="$OLDTZ"

@shell@

