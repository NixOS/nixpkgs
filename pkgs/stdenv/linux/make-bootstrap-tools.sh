source $stdenv/setup

ensureDir $out/in-nixpkgs
ensureDir $out/on-server

# Everything we put in check-only is merely to allow Nix to check that
# we aren't putting binaries with store path references in tarballs.
ensureDir $out/check-only


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
cp $bzip2/bin/bunzip2 $out/in-nixpkgs
cp $coreutils/bin/cp $out/in-nixpkgs
bzip2 < $curl/bin/curl > $out/in-nixpkgs/curl.bz2
cp $tar/bin/tar $out/in-nixpkgs
nukeRefs $out/in-nixpkgs/tar
bzip2 $out/in-nixpkgs/tar
chmod +x $out/in-nixpkgs/*.bz2


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
cp $gunzip/bin/gunzip tools/bin
cp $gunzip/bin/gzip tools/bin
cp $bzip2/bin/bunzip2 tools/bin
cp $gnumake/bin/* tools/bin
cp $patch/bin/* tools/bin
cp $patchelf/bin/* tools/bin

nukeRefs tools/bin/diff
nukeRefs tools/bin/sed
nukeRefs tools/bin/gawk
nukeRefs tools/bin/tar
nukeRefs tools/bin/grep
nukeRefs tools/bin/patchelf
nukeRefs tools/bin/make


# Create the binutils tarball.
mkdir binutils
mkdir binutils/bin
for i in as ld ar ranlib nm strip readelf; do
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
rm gcc/lib/libmud* gcc/lib/libiberty* gcc/lib/libssp*
nukeRefs gcc/lib/libgcc_s.so.1
rm -rf gcc/lib/gcc/*/*/install-tools


# Create the glibc tarball.
mkdir glibc
mkdir glibc/lib
cp $glibc/lib/*.a glibc/lib
rm glibc/lib/*_p.a
nukeRefs glibc/lib/libc.a
cp $glibc/lib/*.o glibc/lib
cp -prd $glibc/include glibc
chmod -R +w glibc
rm glibc/include/linux
cp -prd $(readlink $glibc/include/linux) glibc/include
rm glibc/include/asm
ln -s $(readlink $(readlink $glibc/include/asm)) glibc/include/asm
for i in glibc/include/asm-*; do
    target=$(readlink $i)
    rm $i
    cp -prd $target glibc/include
done


# Strip executables even further.
for i in $out/in-nixpkgs/* */bin/* gcc/libexec/gcc/*/*/*; do
    if test -x $i; then
        chmod +w $i
        strip -s $i || true
    fi
done


# Pack, unpack everything.
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
