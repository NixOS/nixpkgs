
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
