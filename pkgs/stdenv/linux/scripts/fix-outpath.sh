cd $out

chmod -R +w .

find . -type f | while read fn; do
    $extra2/bin/cat $fn | $extra4/bin/sed "s|/nix/store/[a-z0-9]*-|/nix/store/ffffffffffffffffffffffffffffffff-|g" > $fn.tmp
    if test -x $fn; then chmod +x $fn.tmp; fi
    mv $fn.tmp $fn
done
