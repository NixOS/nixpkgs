buildinputs=""
. $stdenv/setup

tar xvfj $src
cd tools
sed s/mconsole// < Makefile > tmp
mv tmp Makefile
mkdir $out
mkdir $out/bin
mkdir $out/lib
mkdir $out/lib/uml
make BIN_DIR=$out/bin LIB_DIR=$out/lib/uml
make BIN_DIR=$out/bin LIB_DIR=$out/lib/uml install
