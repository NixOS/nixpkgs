export buildinputs="$yacc $m4"
. $stdenv/setup

tar xvfj $src
cd flex-*
./configure --prefix=$out
make
make install

mkdir $out/nix-support
echo "$m4" > $out/nix-support/propagated-build-inputs
