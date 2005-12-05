source $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd cksfv-*/src || exit 1
make || exit 1
mkdir $out || exit 1
mkdir $out/bin || exit 1
install cksfv $out/bin || exit 1
