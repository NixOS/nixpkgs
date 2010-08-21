set -e

# Unpack the bootstrap tools tarball.
echo Unpacking the bootstrap tools...
$mkdir $out
$bzip2 -d < $tarball | (cd $out && $cpio -i)

# Set the ELF interpreter / RPATH in the bootstrap binaries.
echo Patching the bootstrap tools...

if test -f $out/lib/ld.so.?; then
   # MIPS case
   LD_BINARY=$out/lib/ld.so.?
else
   # i686, x86_64 and armv5tel
   LD_BINARY=$out/lib/ld-*so.?
fi

# On x86_64, ld-linux-x86-64.so.2 barfs on patchelf'ed programs.  So
# use a copy of patchelf.
LD_LIBRARY_PATH=$out/lib $LD_BINARY $out/bin/cp $out/bin/patchelf .

for i in $out/bin/* $out/libexec/gcc/*/*/*; do
    echo patching $i
    if ! test -L $i; then
         LD_LIBRARY_PATH=$out/lib $LD_BINARY \
             $out/bin/patchelf --set-interpreter $LD_BINARY --set-rpath $out/lib --force-rpath $i
         LD_LIBRARY_PATH=$out/lib $LD_BINARY \
             $out/bin/patchelf --set-interpreter $LD_BINARY --set-rpath $out/lib --force-rpath $i
    fi
done
for i in $out/lib/librt* ; do
    echo patching $i
    if ! test -L $i; then
         LD_LIBRARY_PATH=$out/lib $LD_BINARY \
             $out/bin/patchelf --set-interpreter $LD_BINARY --set-rpath $out/lib --force-rpath $i
         LD_LIBRARY_PATH=$out/lib $LD_BINARY \
             $out/bin/patchelf --set-interpreter $LD_BINARY --set-rpath $out/lib --force-rpath $i
    fi
done

for i in $out/lib/libgmp* $out/lib/libppl* $out/lib/libcloog* $out/lib/libmpc* $out/lib/libpcre* $out/lib/libstdc++*.so.*[0-9]; do
    echo trying to patch $i
    if test -f $i -a ! -L $i; then
         LD_LIBRARY_PATH=$out/lib $LD_BINARY \
             $out/bin/patchelf --set-rpath $out/lib --force-rpath $i
         LD_LIBRARY_PATH=$out/lib $LD_BINARY \
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
