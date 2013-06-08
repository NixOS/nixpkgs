set -e

source $stdenv/setup

mkdir -p $out/bin $out/lib

tar xvfz $src
cd hevea-*

sed s+/usr/local+$out+ Makefile > Makefile.new
mv Makefile.new Makefile

make
make install
