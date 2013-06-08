#!bash
source $stdenv/setup
mkdir -p $out/bin
cp $src/src/winetricks $out/bin/winetricks
chmod +x $out/bin/winetricks
cd $out/bin
patch -u -p0 < $patch

mkdir -p "$out/share/man/man1"
cp "$src/src/winetricks.1" "$out/share/man/man1/"

patchShebangs "$out"

substituteInPlace "$out/bin/winetricks" --replace "/usr/bin/perl" `which perl`

# add stuff to PATH
sed -i "2i PATH=\"${pathAdd}:\${PATH}\"" "$out/bin/winetricks"
