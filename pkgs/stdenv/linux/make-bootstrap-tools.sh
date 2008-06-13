source $stdenv/setup

ensureDir $out/in-nixpkgs
ensureDir $out/on-server

# Everything we put in check-only is merely to allow Nix to check that
# we aren't putting binaries with store path references in tarballs.
ensureDir $out/check-only


export PATH=$coreutils/bin:$PATH # !!! temporary hack


nukeRefs() {
    # Dirty, disgusting, but it works ;-)
    fileName=$1
    cat $fileName | sed "s|/nix/store/[a-z0-9]*-|/nix/store/ffffffffffffffffffffffffffffffff-|g" > $fileName.tmp
    if test -x $fileName; then chmod +x $fileName.tmp; fi
    mv $fileName.tmp $fileName
}


# Create the tools that need to be in-tree, i.e., the ones that are
# necessary for the absolute first stage of the bootstrap.
cp $bash/bin/bash $out/in-nixpkgs
nukeRefs $out/in-nixpkgs/bash
cp $bzip2/bin/bzip2 $out/in-nixpkgs
cp $coreutils/bin/cp $out/in-nixpkgs
cp $gnutar/bin/tar $out/in-nixpkgs
nukeRefs $out/in-nixpkgs/tar

if test "$system" = "powerpc-linux"; then
    nukeRefs $out/in-nixpkgs/cp
fi


# Create the tools tarball.
mkdir tools
mkdir tools/bin

cp $coreutils/bin/* tools/bin
rm tools/bin/groups # has references
rm tools/bin/printf # idem

cp $findutils/bin/find tools/bin
cp $findutils/bin/xargs tools/bin
cp $diffutils/bin/* tools/bin
cp $gnused/bin/* tools/bin
cp $gnugrep/bin/* tools/bin
cp $gawk/bin/gawk tools/bin
ln -s gawk tools/bin/awk
cp $gnutar/bin/* tools/bin
cp $gzip/bin/gzip tools/bin
cp $bzip2/bin/bzip2 tools/bin
cp $gnumake/bin/* tools/bin
cp $patch/bin/* tools/bin
cp $patchelf/bin/* tools/bin

nukeRefs tools/bin/diff
nukeRefs tools/bin/sed
nukeRefs tools/bin/gawk
nukeRefs tools/bin/tar
nukeRefs tools/bin/grep
nukeRefs tools/bin/fgrep
nukeRefs tools/bin/egrep
nukeRefs tools/bin/patchelf
nukeRefs tools/bin/make


# Create the binutils tarball.
mkdir binutils
mkdir binutils/bin
for i in as ld ar ranlib nm strip readelf objdump; do
    cp $binutils/bin/$i binutils/bin
    nukeRefs binutils/bin/$i
done


# Create the gcc tarball.
mkdir gcc
mkdir gcc/bin
cp $gcc/bin/gcc gcc/bin
cp $gcc/bin/cpp gcc/bin
nukeRefs gcc/bin/gcc
nukeRefs gcc/bin/cpp
cp -prd $gcc/lib gcc
cp -prd $gcc/libexec gcc
chmod -R +w gcc
nukeRefs gcc/libexec/gcc/*/*/cc1
nukeRefs gcc/libexec/gcc/*/*/collect2
if test -e gcc/lib/libgcc_s.so.1; then
    nukeRefs gcc/lib/libgcc_s.so.1
fi
if test -e $gcc/lib64; then
    cp -prd $gcc/lib64 gcc
    chmod -R +w gcc/lib64
    nukeRefs gcc/lib64/libgcc_s.so.1
fi
rm -f gcc/lib*/libmud* gcc/lib*/libiberty* gcc/lib*/libssp* gcc/lib*/libgomp*
rm -rf gcc/lib/gcc/*/*/install-tools
rm -rf gcc/lib/gcc/*/*/include/root
rm -rf gcc/lib/gcc/*/*/include/linux
if test "$system" = "powerpc-linux"; then
    nukeRefs gcc/lib/gcc/powerpc-unknown-linux-gnu/*/include/bits/mathdef.h
fi
# Dangling symlink "sound", probably produced by fixinclude.
# Should investigate why it's there in the first place.
rm -f gcc/lib/gcc/*/*/include/sound


# Create the glibc tarball.
mkdir glibc
mkdir glibc/lib
cp $glibc/lib/*.a glibc/lib
rm -f glibc/lib/*_p.a
nukeRefs glibc/lib/libc.a
cp $glibc/lib/*.o glibc/lib
cp -prd $glibc/include glibc
chmod -R +w glibc
rm glibc/include/linux
cp -prd $(readlink $glibc/include/linux) glibc/include
rm glibc/include/asm
if test -L "$(readlink $glibc/include/asm)"; then
    ln -s $(readlink $(readlink $glibc/include/asm)) glibc/include/asm
else
    cp -prd "$(readlink $glibc/include/asm)" glibc/include
fi
for i in glibc/include/asm-*; do
    target=$(readlink $i)
    rm $i
    cp -prd $target glibc/include
done
# Hopefully we won't need these.
rm -f glibc/include/mtd glibc/include/rdma glibc/include/sound glibc/include/video


# Strip executables even further.
for i in $out/in-nixpkgs/* */bin/* gcc/libexec/gcc/*/*/*; do
    if test -x $i; then
        chmod +w $i
        strip -s $i || true
    fi
done


# Pack, unpack everything.
bzip2 < $curl/bin/curl > $out/in-nixpkgs/curl.bz2
bzip2 $out/in-nixpkgs/tar
chmod +x $out/in-nixpkgs/*.bz2

tar cfj $out/on-server/static-tools.tar.bz2 tools
tar cfj $out/on-server/binutils.tar.bz2 binutils
tar cfj $out/on-server/gcc.tar.bz2 gcc
tar cfj $out/on-server/glibc.tar.bz2 glibc

for i in $out/on-server/*.tar.bz2; do
    (cd $out/check-only && tar xfj $i)
done

for i in $out/in-nixpkgs/*.bz2; do
    (cd $out/check-only && bunzip2 < $i > $(basename $i .bz2))
done


# Check that everything is statically linked
for i in $(find $out -type f -perm +111); do
    if ldd $i | grep -q "=>"; then echo "not statically linked: $i"; exit 1; fi
done
