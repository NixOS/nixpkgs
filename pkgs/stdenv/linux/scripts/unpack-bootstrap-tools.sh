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

set +e
for i in $out/bin/* $out/libexec/gcc/*/*/*; do
    echo patching $i
    if ! test -L $i; then
         LD_LIBRARY_PATH=$out/lib $out/lib/ld-linux*.so.? \
             ./patchelf --set-interpreter $out/lib/ld-linux*.so.? --set-rpath $out/lib --force-rpath $i
    fi
done
set -e

# Fix the libc linker script.
export PATH=$out/bin
cat $out/lib/libc.so | sed "s|/nix/store/e*-[^/]*/|$out/|g" > $out/lib/libc.so.tmp
mv $out/lib/libc.so.tmp $out/lib/libc.so

# Provide some additional symlinks.
ln -s bash $out/bin/sh

ln -s bzip2 $out/bin/bunzip2

# fetchurl needs curl.
bzip2 -d < $curl > $out/bin/curl
chmod +x $out/bin/curl
