source $stdenv/setup

tar xvfz $src
cd bsod-*
make
mkdir -p $out/bin
cp bsod $out/bin

