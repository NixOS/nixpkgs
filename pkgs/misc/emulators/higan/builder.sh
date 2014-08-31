
source $stdenv/setup

unpackPhase
cd $sourceName
make phoenix=gtk profile=accuracy -C ananke
make phoenix=gtk profile=accuracy

install -dm 755 $out/share/applications $out/share/pixmaps $out/share/higan/Video\ Shaders $out/bin $out/lib

install -m 644 data/higan.desktop $out/share/applications/
install -m 644 data/higan.png $out/share/pixmaps/
cp -dr --no-preserve=ownership profile/* data/cheats.bml $out/share/higan/
cp -dr --no-preserve=ownership shaders/*.shader $out/share/higan/Video\ Shaders/

install -m 755 out/higan $out/bin/higan
install -m 644 ananke/libananke.so $out/lib/libananke.so.1
(cd $out/lib && ln -s libananke.so.1 libananke.so)
oldRPath=$(patchelf --print-rpath $out/bin/higan)
patchelf --set-rpath $oldRPath:$out/lib $out/bin/higan

# A dirty workaround, suggested by @cpages:
# we create a wrapper script to set up
# $HOME local configuration before higan runs

mv $out/bin/higan $out/bin/.higan-wrapped
cat <<EOF > $out/bin/higan 

#!/bin/bash
if [ ! -e \$HOME/.config/higan/.was_configured ]
then
    cp --update --recursive $out/share/higan \$HOME/.config
    chmod --recursive u+w \$HOME/.config/higan
    touch \$HOME/.config/higan/.was_configured
fi
# LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$out/lib
$out/bin/.higan-wrapped "\$@"

EOF

patchShebangs $out/bin/higan
chmod +x $out/bin/higan
