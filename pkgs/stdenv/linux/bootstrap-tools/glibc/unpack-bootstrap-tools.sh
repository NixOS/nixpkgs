# Unpack the bootstrap tools tarball.
echo Unpacking the bootstrap tools...
$builder mkdir $out
< $tarball $builder unxz | $builder tar x -C $out

# Set the ELF interpreter / RPATH in the bootstrap binaries.
echo Patching the bootstrap tools...

if test -f $out/lib/ld.so.?; then
   # MIPS case
   LD_BINARY=$out/lib/ld.so.?
elif test -f $out/lib/ld64.so.?; then
   # ppc64(le)
   LD_BINARY=$out/lib/ld64.so.?
else
   # i686, x86_64 and armv5tel
   LD_BINARY=$out/lib/ld-*so.?
fi

# path to version-specific libraries, like libstdc++.so
LIBSTDCXX_SO_DIR=$(echo $out/lib/gcc/*/*)

# Move version-specific libraries out to avoid library mix when we
# upgrade gcc.
# TODO(trofi): update bootstrap tarball script and tarballs to put them
# into expected location directly.
LD_LIBRARY_PATH=$out/lib $LD_BINARY $out/bin/mv $out/lib/libstdc++.* $LIBSTDCXX_SO_DIR/

# On x86_64, ld-linux-x86-64.so.2 barfs on patchelf'ed programs.  So
# use a copy of patchelf.
LD_LIBRARY_PATH=$out/lib $LD_BINARY $out/bin/cp $out/bin/patchelf .

# Older versions of the bootstrap-files did not compile their
# patchelf with -static-libgcc, so we have to be very careful not to
# run patchelf on the same copy of libgcc_s that it links against.
LD_LIBRARY_PATH=$out/lib $LD_BINARY $out/bin/cp $out/lib/libgcc_s.so.1 .
LD_LIBRARY_PATH=.:$out/lib:$LIBSTDCXX_SO_DIR $LD_BINARY \
  ./patchelf --set-rpath $out/lib --force-rpath $out/lib/libgcc_s.so.1

for i in $out/bin/* $out/libexec/gcc/*/*/*; do
    if [ -L "$i" ]; then continue; fi
    if [ -z "${i##*/liblto*}" ]; then continue; fi
    echo patching "$i"
    LD_LIBRARY_PATH=$out/lib:$LIBSTDCXX_SO_DIR $LD_BINARY \
        ./patchelf --set-interpreter $LD_BINARY --set-rpath $out/lib:$LIBSTDCXX_SO_DIR --force-rpath "$i"
done

for i in $out/lib/librt-*.so $out/lib/libpcre*; do
    if [ -L "$i" ]; then continue; fi
    echo patching "$i"
    $out/bin/patchelf --set-rpath $out/lib --force-rpath "$i"
done

export PATH=$out/bin

# Provide some additional symlinks.
ln -s bash $out/bin/sh
ln -s bzip2 $out/bin/bunzip2

# Provide a gunzip script.
cat > $out/bin/gunzip <<EOF
#!$out/bin/sh
exec $out/bin/gzip -d "\$@"
EOF
chmod +x $out/bin/gunzip

# Provide fgrep/egrep.
echo "#! $out/bin/sh" > $out/bin/egrep
echo "exec $out/bin/grep -E \"\$@\"" >> $out/bin/egrep
echo "#! $out/bin/sh" > $out/bin/fgrep
echo "exec $out/bin/grep -F \"\$@\"" >> $out/bin/fgrep

# Provide xz (actually only xz -d will work).
echo "#! $out/bin/sh" > $out/bin/xz
echo "exec $builder unxz \"\$@\"" >> $out/bin/xz

chmod +x $out/bin/egrep $out/bin/fgrep $out/bin/xz
