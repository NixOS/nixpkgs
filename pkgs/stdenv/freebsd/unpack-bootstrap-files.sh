$mkdir -p $out
$unxz <$bootstrapFiles | $tar -C $out -x
for f in $out/bin/*; do
    $out/bin/patchelf --set-rpath $out/lib --set-interpreter $out/libexec/ld-elf.so.? $f || true
done
$out/bin/cp $builder $mkdir $tar $unxz $out/bin
