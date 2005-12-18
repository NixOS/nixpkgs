source $stdenv/setup

preConfigure=preConfigure
preConfigure() {
    if test -n "$idea"; then
        gunzip < $idea > ./cipher/idea.c
    fi
}

genericBuild
