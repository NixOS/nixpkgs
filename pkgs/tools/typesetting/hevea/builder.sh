set -e

. $stdenv/setup

mkdir -p $out/bin $out/lib

tar xvfz $src
cd hevea-*

sed s+/usr/local+$out+ Makefile > Makefile.new
mv Makefile.new Makefile

if test "x$system" = "xpowerpc-darwin"; then
  sed s/CPP=cpp\ -E\ -P/CPP=m4\ -E\ -E\ -P/ Makefile > Makefile.new
  mv Makefile.new Makefile
fi

make
make install
