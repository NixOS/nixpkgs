. $stdenv/setup || exit 1

mkdir -p $out/bin $out/lib

tar xvfz $src || exit 1
cd hevea-* || exit 1
sed s+/usr/local+$out+ Makefile > Makefile.new || exit 1
mv Makefile.new Makefile
make || exit 1
make install || exit 1
