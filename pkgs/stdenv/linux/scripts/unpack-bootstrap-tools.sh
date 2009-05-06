set -e

# Unpack the bootstrap tools tarball.
echo Unpacking the bootstrap tools...
$mkdir $out
$bzip2 -d < $tarball | (cd $out && $cpio -V -i)

# Set the ELF interpreter / RPATH in the bootstrap binaries.
echo Patching the bootstrap tools...

# On x86_64, ld-linux-x86-64.so.2 barfs on patchelf'ed programs.  So
# use a copy of patchelf.
LD_LIBRARY_PATH=$out/lib $out/lib/ld-linux*.so.2 $out/bin/cp $out/bin/patchelf .

for i in $out/bin/* $out/libexec/gcc/*/*/*; do
    echo patching $i
    if ! test -L $i; then
         LD_LIBRARY_PATH=$out/lib $out/lib/ld-linux*.so.2 \
             ./patchelf --set-interpreter $out/lib/ld-linux*.so.2 --set-rpath $out/lib $i
    fi
done

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

# Some libraries have libpthread in their DT_RUNPATH.  PatchELF
# doesn't work on libraries, so we need to set LD_LIBRARY_PATH.
# However, setting LD_LIBRARY_PATH to $out/lib will confuse /bin/sh,
# since it might end up loading libraries from a different Glibc.  So
# put *only* libpthread in LD_LIBRARY_PATH (via $out/lib2).  !!! This
# is a temporary fix (since /bin/sh could have a dependency on
# libpthread as well).  A better fix would be to make patchelf work on
# libraries, or to set the RPATH rather than the RUNPATH in the
# binaries in $out/bin (patchelf --force-rpath doesn't quite work,
# since it doesn't discard the existing RUNPATH).
mkdir $out/lib2
ln -s $out/lib/libpthread* $out/lib2
