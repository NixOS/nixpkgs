#!/bin/sh
#
# Use this script with the upstream sorted list of patches
# curl ftp://ftp.kernel.org/pub/linux/daemons/autofs/v5/patches-5.0.{x+1}/patch_order-5.0.x | 
#   grep -v '^#' | sh create-patches-v5.sh

BASEURL=mirror://kernel/linux/daemons/autofs/v5/patches-5.0.9;

echo '# File created automatically' > patches-v5.nix
echo 'fetchurl :' >> patches-v5.nix
echo '[' >> patches-v5.nix

while read a; do
  URL=$BASEURL/$a
  HASH=`nix-prefetch-url $URL`
  echo "(fetchurl { url = $URL; sha256 = \"$HASH\"; })" >> patches-v5.nix
done

echo ']' >> patches-v5.nix
