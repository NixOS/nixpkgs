buildinputs="$aterm $toolbuslib"
. $stdenv/setup || exit 1

tar zxf $src || exit 1
cd pt-support-* || exit 1
./configure --prefix=$out --with-aterm=$aterm --with-toolbuslib=$toolbuslib || exit 1
make install || exit 1
