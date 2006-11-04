source $stdenv/setup

if test -n "$bootable"; then
    bootFlags="-b $bootImage -c boot.cat -no-emul-boot -boot-load-size 4"
fi

graftList=
sources_=($sources)
targets_=($targets)
for ((i = 0; i < ${#targets_[@]}; i++)); do
    graftList="$graftList ${targets_[$i]}=$(readlink -f ${sources_[$i]})"
done

# !!! Just as with make-initrd.nix, the call to Nix here needs to be
# fixed.
packagesClosure=$(/nix/bin/nix-store -qR $packages $init)

for i in $packagesClosure; do
    graftList="$graftList ${i:1}=$i"
done

if test -n "$init"; then
    ln -s $init init
    graftList="$graftList init=init"
fi

# !!! -f is a quick hack.
ensureDir $out
mkisofs -r -J -o $out/$isoName $bootFlags \
    -graft-points $graftList

ensureDir $out/nix-support
echo $system > $out/nix-support/system
