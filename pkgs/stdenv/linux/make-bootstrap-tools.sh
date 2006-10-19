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


cp $bash/bin/bash $out/in-nixpkgs
cp $bzip2/bin/bunzip2 $out/in-nixpkgs
cp $gnutar/bin/tar $out/in-nixpkgs
cp $curl/bin/curl $out/check-only
bzip2 < $curl/bin/curl > $out/in-nixpkgs/curl.bz2

nukeRefs $out/in-nixpkgs/bash
nukeRefs $out/in-nixpkgs/tar


mkdir tools
mkdir tools/bin

cp $coreutils/bin/* tools/bin
rm tools/bin/groups # has references
rm tools/bin/printf # idem

cp $gnused/bin/* tools/bin
cp $gnugrep/bin/* tools/bin
cp $gnutar/bin/* tools/bin
cp $bzip2/bin/bunzip2 tools/bin
cp $patch/bin/* tools/bin

nukeRefs tools/bin/sed
nukeRefs tools/bin/tar
nukeRefs tools/bin/grep

#cp $patchelf/bin/* tools/bin


for i in $out/in-nixpkgs/* tools/bin/*; do
    if test -x $i; then
        chmod +w $i
        strip -s $i || true
    fi
done


tar cvfj $out/on-server/static-tools.tar.bz2 tools


for i in $out/on-server/*.tar.bz2; do
    (cd $out/check-only && tar xvfj $i)
done
