chmod u+w $out/include
(cd $out/include && ln -s $extra/include/* .) || exit 1

cd $out
find . -not -type l -exec $extra2/bin/chmod u+w {} \;
find . -exec $patchelf --interpreter $out/lib/ld-linux.so.2 --shrink-rpath {} \; || true

$extra2/bin/rm -rf bin

$extra2/bin/cat ./lib/libc.so | $extra4/bin/sed "s|/nix/store/[a-z0-9]*-glibc|$out|g" > ./lib/libc.so
$extra2/bin/cat ./lib/libpthread.so | $extra4/bin/sed "s|/nix/store/[a-z0-9]*-glibc|$out|g" > ./lib/libpthread.so

rm $out/lib/*.so*
