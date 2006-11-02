source $stdenv/setup

ensureDir $out

if test -n "$bootable"; then
    bootFlags="-b $bootImage -c boot.cat -no-emul-boot -boot-load-size 4"
fi

# !!! -f is a quick hack.
mkisofs -r -J -f -o $out/$isoName $bootFlags -graft-points $graftList
