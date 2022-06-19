# Unpack the bootstrap tools tarball.
echo Unpacking the bootstrap tools...
$builder mkdir $out
< $tarball $builder unxz | $builder tar x -C $out

# Set the ELF interpreter / RPATH in the bootstrap binaries.
echo Patching the bootstrap tools...

if test -f $out/lib/ld.so.?; then
   # MIPS case
   LD_BINARY=lib/ld.so.?
elif test -f $out/lib/ld64.so.?; then
   # ppc64(le)
   LD_BINARY=lib/ld64.so.?
else
   # i686, x86_64 and armv5tel
   LD_BINARY=lib/ld-*so.?
fi

# make a copy of patchelf and lib so we don't try patchelf'ing
# patchelf itself, or a library that patchelf itself links against --
# this may cause segfaults due to lazy loading of binary images
LD_LIBRARY_PATH=$out/lib $out/$LD_BINARY $out/bin/cp -r $out/lib $out/bin/patchelf .

export LD_LIBRARY_PATH=lib
for i in $($LD_BINARY $out/bin/find $out -type f -executable); do

    interp=$($LD_BINARY ./patchelf --print-interpreter $i 2>/dev/null || echo)

    # patchelf --set-interpreter only if a nuke-ref'd interpreter is found
    if [ -n "${interp}" ] && [ -z "${interp##/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-*/lib*/*}" ]; then
      echo patching interpreter of "$i"
      $LD_BINARY ./patchelf --set-interpreter $out/$LD_BINARY "$i"
    fi

    rpath=$($LD_BINARY ./patchelf --print-rpath $i 2>/dev/null || echo)

    # patchelf --set-rpath only if a nuke-ref'd rpath is found
    if [ -n "${rpath}" ] && [ -z "${rpath##/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-*}" ] &&
       # do not use patchelf --set-rpath on libgcc_s.so.1, because its rpath leaks into stdenv-final
       [ -n "${i##*/lib*/libgcc_s.so.*}" ]; then
      echo patching rpath of "$i"
      $LD_BINARY ./patchelf --set-rpath $out/lib --force-rpath "$i"
    fi
done
export LD_LIBRARY_PATH=

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
