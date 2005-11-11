source $stdenv/setup

tar jxvf $valgrindsrc || fail
cd valgrind-* || fail
./configure --prefix=$out || fail
make || fail
make install || fail

tar zxvf $src
cd clg3 || fail
./configure --prefix=$out || fail
make || fail
make install || fail
