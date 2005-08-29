source $stdenv/setup

export NIX_CFLAGS_COMPILE="-I$ncurses/include/ncurses -I$ncurses/include $NIX_CFLAGS_COMPILE"

genericBuild
