set -e

# Unpack the bootstrap tools tarball.
echo Unpacking the bootstrap tools...
$mkdir $out
$bzip2 -d < $tarball | (cd $out && $cpio -V -i)

# Set the ELF interpreter / RPATH in the bootstrap binaries.
echo Patching the bootstrap tools...

# On x86_64, ld-linux-x86-64.so.2 barfs on patchelf'ed programs.  So
# use a copy of patchelf.
LD_LIBRARY_PATH=$out/lib $out/lib/ld-linux*.so.? $out/bin/cp $out/bin/patchelf .

for i in $out/bin/* $out/libexec/gcc/*/*/* $out/lib/librt*; do
    echo patching $i
    if ! test -L $i; then
         LD_LIBRARY_PATH=$out/lib $out/lib/ld-linux*.so.? \
             $out/bin/patchelf --set-interpreter $out/lib/ld-linux*.so.? --set-rpath $out/lib --force-rpath $i
         LD_LIBRARY_PATH=$out/lib $out/lib/ld-linux*.so.? \
             $out/bin/patchelf --set-interpreter $out/lib/ld-linux*.so.? --set-rpath $out/lib --force-rpath $i
    fi
done
for i in $out/lib/libppl* $out/lib/libgmp*; do
    echo patching $i
    if ! test -L $i; then
         LD_LIBRARY_PATH=$out/lib $out/lib/ld-linux*.so.? \
             $out/bin/patchelf --set-rpath $out/lib --force-rpath $i
         LD_LIBRARY_PATH=$out/lib $out/lib/ld-linux*.so.? \
             $out/bin/patchelf --set-rpath $out/lib --force-rpath $i
    fi
done

# Fix the libc linker script.
export PATH=$out/bin
cat $out/lib/libc.so | sed "s|/nix/store/e*-[^/]*/|$out/|g" > $out/lib/libc.so.tmp
mv $out/lib/libc.so.tmp $out/lib/libc.so
cat $out/lib/libpthread.so | sed "s|/nix/store/e*-[^/]*/|$out/|g" > $out/lib/libpthread.so.tmp
mv $out/lib/libpthread.so.tmp $out/lib/libpthread.so

# Provide some additional symlinks.
ln -s bash $out/bin/sh
ln -s bzip2 $out/bin/bunzip2

# Mimic the gunzip script as in gzip installations
cat > $out/bin/gunzip <<EOF
#!$out/bin/sh
exec $out/bin/gzip -d "\$@"
EOF
chmod +x $out/bin/gunzip

# fetchurl needs curl.
bzip2 -d < $curl > $out/bin/curl
chmod +x $out/bin/curl
