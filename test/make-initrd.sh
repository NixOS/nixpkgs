source $stdenv/setup

set -o pipefail

# Get the paths in the closure of `init'.
if ! test -e ./init-closure; then
    echo 'Your Nix installation is too old! Upgrade to nix-0.11pre7038 or newer.'
    exit 1
fi
storePaths=$($SHELL $pathsFromGraph ./init-closure)

# Paths in cpio archives *must* be relative, otherwise the kernel
# won't unpack 'em.
mkdir root
cd root
cp -prd --parents $storePaths .

# Put the closure in a gzipped cpio archive.
ensureDir $out
ln -s $init init
find * -print0 | cpio -ov -H newc --null | gzip -9 > $out/initrd
