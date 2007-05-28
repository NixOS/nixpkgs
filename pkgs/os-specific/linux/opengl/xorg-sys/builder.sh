source $stdenv/setup

ensureDir $out/lib

ln -s /usr/lib/libGL.so.1 $out/lib/
ln -s /usr/lib/libGLcore.so.1 $out/lib/
ln -s /usr/lib/libnvidia-tls.so.1 $out/lib/
#ln -s /usr/lib/libdrm.so.2 $out/lib/

for i in $neededLibs; do
    ln -s $i/lib/*.so* $out/lib/
done



