. $stdenv/setup

tar xvfz $src
cd gperf-*
./configure --prefix=$out
make
make install
