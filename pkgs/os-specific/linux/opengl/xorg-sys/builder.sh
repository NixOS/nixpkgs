if [ -e "$NIX_ATTRS_SH_FILE" ]; then . "$NIX_ATTRS_SH_FILE"; elif [ -f .attrs.sh ]; then . .attrs.sh; fi
source $stdenv/setup

mkdir -p $out/lib

ln -s /usr/lib/libGL.so.1 $out/lib/
ln -s /usr/lib/libGLU.so.1 $out/lib/
ln -s /usr/lib/libGLcore.so.1 $out/lib/
ln -s /usr/lib/tls/libnvidia-tls.so.1 $out/lib/
#ln -s /usr/lib/libdrm.so.2 $out/lib/

for i in $neededLibs; do
    ln -s $i/lib/*.so* $out/lib/
done



