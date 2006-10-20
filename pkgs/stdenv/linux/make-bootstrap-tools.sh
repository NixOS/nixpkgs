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
cp $bzip2/bin/bunzip2 $out/in-nixpkgs
cp $gnutar/bin/tar $out/in-nixpkgs
cp $curl/bin/curl $out/check-only
bzip2 < $curl/bin/curl > $out/in-nixpkgs/curl.bz2

nukeRefs $out/in-nixpkgs/bash
nukeRefs $out/in-nixpkgs/tar


# Create the tools tarball.
mkdir tools
mkdir tools/bin

cp $coreutils/bin/* tools/bin
rm tools/bin/groups # has references
rm tools/bin/printf # idem

cp $gnused/bin/* tools/bin
cp $gnugrep/bin/* tools/bin
cp $gnutar/bin/* tools/bin
cp $gunzip/bin/gunzip tools/bin
cp $bzip2/bin/bunzip2 tools/bin
cp $patch/bin/* tools/bin

nukeRefs tools/bin/sed
nukeRefs tools/bin/tar
nukeRefs tools/bin/grep

#cp $patchelf/bin/* tools/bin


# Create the binutils tarball.
mkdir binutils
mkdir binutils/bin
for i in as ld ar ranlib nm strip; do
    cp $binutils/bin/$i binutils/bin
    nukeRefs binutils/bin/$i
done


# Create the gcc tarball
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
rm gcc/lib/*.so*
rm -rf gcc/lib/gcc/*/*/install-tools


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

for i in $out/on-server/*.tar.bz2; do
    (cd $out/check-only && tar xfj $i)
done
