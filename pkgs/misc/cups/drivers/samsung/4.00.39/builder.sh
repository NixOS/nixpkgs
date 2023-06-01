if [ -e .attrs.sh ]; then source .attrs.sh; fi
source $stdenv/setup

arch=$(uname -m)
echo "$arch" | egrep -q '^i[3456]86$' && arch=i386
echo "Installing for $arch"

unpackPhase
patchPhase

set -v

cd cdroot/Linux
mkdir -p $out/opt
cp -r $arch/at_root/* $out
cp -r $arch/at_opt/* $out/opt
#cp -r noarch/at_root/* $out
cp -r noarch/at_opt/* $out/opt

cd $out
test -d usr/lib64 && ln -s usr/lib64 lib ||
    ln -s usr/lib lib
mkdir -p share/cups
cd share/cups
ln -s ../../opt/share/* .
ln -s ppd model

cd $out/lib/cups/filter
for i in $(ls); do
    echo "Patching $i..."
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $i ||
      echo "Couldn't set interpreter!"
    patchelf --set-rpath $cups/lib:$gcc/lib:$glibc/lib $i  # This might not be necessary.
done

ln -s $ghostscript/bin/gs $out/lib/cups/filter
