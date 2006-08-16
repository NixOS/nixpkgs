source $STDENV/setup

tar zxvf $SRC
cd mingw-runtime-*
./configure --prefix=$OUT
make
make install




