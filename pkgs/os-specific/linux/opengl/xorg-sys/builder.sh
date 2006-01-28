source $stdenv/setup

ensureDir $out/lib

ln -s /usr/lib/libGL.so.1 $out/lib/

for i in $neededLibs; do
    ln -s $i/lib/*.so* $out/lib/
done
