source $stdenv/setup

ensureDir $out/baseq3
for i in $paks; do
    if test -d "$paks/baseq3"; then
        ln -s $paks/baseq3/* $out/baseq3/
    fi
done

# We add Mesa to the end of $LD_LIBRARY_PATH to provide fallback
# software rendering.  GCC is needed so that libgcc_s.so can be found
# when Mesa is used.
makeWrapper $game/ioquake3.* $out/bin/quake3 \
    --suffix-each LD_LIBRARY_PATH ':' "$mesa/lib $gcc/lib" \
    --add-flags "+set fs_basepath $out +set r_allowSoftwareGL 1"
