source $stdenv/setup

tar xfvz $src
cd mc-*
./configure --prefix=$out --with-screen=ncurses
make
make install
