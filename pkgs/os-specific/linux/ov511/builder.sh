source $stdenv/setup

hashname=$(basename $kernel)
echo $hashname
if echo "$hashname" | grep -q '^[a-z0-9]\{32\}-'; then
  hashname=$(echo "$hashname" | cut -c -32)
fi

stripHash $kernel
version=$(echo $strippedName | cut -c 7-)-$hashname

echo "version $version"

export version

ensureDir $out/lib/modules/$version/kernel/drivers/usb/media/

genericBuild
