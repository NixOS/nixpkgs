source $stdenv/setup


ensureDir $out/baseq3
for i in $paks; do
    if test -d "$paks/baseq3"; then
        ln -s $paks/baseq3/* $out/baseq3/
    fi
done


ensureDir $out/bin

cat >$out/bin/quake3 <<EOF
exec $game/ioquake3.i386 \
    +set fs_basepath $out \
    "\$@"
EOF

chmod +x $out/bin/quake3
