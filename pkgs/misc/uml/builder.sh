buildinputs="$patch $perl $m4"
. $stdenv/setup || exit 1

tar xvfj $linuxSrc || exit 1
cd linux-* || exit 1
bunzip2 < $umlSrc | patch -p1 || exit 1
cp $config .config || exit 1
make oldconfig ARCH=um || exit 1

make linux ARCH=um || exit 1
strip linux || exit 1
make modules ARCH=um || exit 1

mkdir $out || exit 1
mkdir $out/bin || exit 1
cp -p linux $out/bin || exit 1
make modules_install INSTALL_MOD_PATH=$out ARCH=um || exit 1
