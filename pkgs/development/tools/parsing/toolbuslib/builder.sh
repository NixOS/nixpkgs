buildinputs="$aterm"
. $stdenv/setup || exit 1

tar zxf $src || exit 1
cd toolbuslib-* || exit 1
./configure --prefix=$out --with-aterm=$aterm || exit 1
make install || exit 1
