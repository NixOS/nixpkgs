. $stdenv/setup || exit 1

tar xvfj $src || exit 1
cd alsa-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
