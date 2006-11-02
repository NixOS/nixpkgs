source $stdenv/setup

set -o pipefail

# Get the paths in the closure of `packages'.  Unfortunately, the only
# way to get the closure is to call Nix, which is strictly speaking
# forbidden.  But we do it anyway.  In time, we should add a feature
# to Nix to let Nix pass closures to builders.
packagesClosure=$(/nix/bin/nix-store -qR $packages $init)

# Paths in cpio archives *must* be relative, otherwise the kernel
# won't unpack 'em.
mkdir root
cd root
cp -prvd --parents $packagesClosure .

# Put the closure in a gzipped cpio archive.
ensureDir $out
ln -s $init init
find * -print0 | cpio -ov -H newc --null | gzip -9 > $out/initrd
