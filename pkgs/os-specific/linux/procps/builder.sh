. $stdenv/setup

export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$ncurses/include/ncurses"

export DESTDIR=$out

genericBuild

