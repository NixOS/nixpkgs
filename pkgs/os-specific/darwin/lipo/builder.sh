source $stdenv/setup
mkdir -p "$out/bin"
ln -s /usr/bin/lipo "$out/bin/"
