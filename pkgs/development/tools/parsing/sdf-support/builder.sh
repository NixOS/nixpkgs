buildinputs="$aterm $ptsupport $toolbuslib"
. $stdenv/setup || exit 1

tar zxf $src || exit 1
cd sdf-support-* || exit 1
./configure --prefix=$out --with-aterm=$aterm --with-toolbuslib=$toolbuslib --with-pt-support=$ptsupport || exit 1
make install || exit 1
