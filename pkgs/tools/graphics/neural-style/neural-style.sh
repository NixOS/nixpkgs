#! @bash@/bin/bash

declare -a args
c=1
flag=

for arg in "$@"; do
        if test "$arg" = "${arg#-}" && test "$arg" = "${arg#/}" && test -n "$flag"; then
                arg="$PWD/$arg"
                flag=
        elif test "$arg" != "${arg%_image}" && test "$arg" != "${arg#-}"; then
                flag=1
        else
                flag=
        fi
        args[c]="$arg";
        c=$((c+1));
done

cd "@out@/lib/lua/neural-style"

export LUA_PATH="$LUA_PATH${LUA_PATH:+;}@loadcaffe@/lua/?/init.lua;@loadcaffe@/lua/?.lua"
export LUA_CPATH="$LUA_CPATH${LUA_CPATH:+;}@loadcaffe@/lib/?.so"

@torch@/bin/th neural_style.lua "${args[@]}"
