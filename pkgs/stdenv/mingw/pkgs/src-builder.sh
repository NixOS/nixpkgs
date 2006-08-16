source $STDENV/setup

tar zxvf $SRC
cd $NAME
./configure --prefix=$OUT
make
make install
