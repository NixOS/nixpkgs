source $stdenv/setup

tar jxvf $valgrindsrc || fail
cd valgrind-* || fail
./configure --prefix=$out || fail
make || fail
make install || fail

genericBuild
