export buildinputs="$bison $flex"
. $stdenv/setup || exit 1

tar xvfz $src1 || exit 1
tar xvfz $src2 || exit 1
tar xvfz $src3 || exit 1
cd xc || exit 1
sed "s^@OUT@^$out^" < $hostdef > config/cf/host.def
make World || exit 1
make install || exit 1

# !!! Hack to get fontconfig to work.
ln -s /usr/X11R6/lib/X11/fonts $out/lib/X11/fonts
