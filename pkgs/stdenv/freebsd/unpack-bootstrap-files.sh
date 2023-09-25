$mkdir -p $out
$unxz <$bootstrapFiles | $tar --delay-directory-restore --no-same-permissions -C $out -x
PATH=$out/bin
$chmod +w -R $out
for f in $out/bin/* $out/bin/.*; do
    patchelf --set-rpath $out/lib --set-interpreter $out/libexec/ld-elf.so.? $f
done
for f in $($out/bin/find $out/lib -type f); do
    patchelf --set-rpath $out/lib $f
done
for f in $($out/bin/find $out -type f); do
    grep -I /nix/store $f >/dev/null && sed -E -i -e 's_/nix/store/[^/]+_'"$out"'_g' $f
done
$out/bin/cp $mkdir $tar $unxz $out/bin
$out/bin/cp $builder $out/bin/bash
echo $out
