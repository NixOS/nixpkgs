source $stdenv/setup

tar xfvz $src
cd $pkgname-$version/wpa_supplicant
cp defconfig .config
substituteInPlace Makefile --replace /usr/local $out
make wpa_gui-qt4
cd wpa_gui-qt4
ensureDir $out/bin
cp wpa_gui $out/bin
ensureDir $out/share/applications
cp wpa_gui.desktop $out/share/applications
