buildinputs=""
source $stdenv/setup

tar xvfj $src
cd tools
sed -e 's/mconsole//' -e '1s/.*/TUNCTL = \$(shell [ -n tunctl ] \&\& echo tunctl)/' -i Makefile
mkdir $out
mkdir $out/bin
mkdir $out/lib
mkdir $out/lib/uml
make BIN_DIR=$out/bin LIB_DIR=$out/lib/uml
make BIN_DIR=$out/bin LIB_DIR=$out/lib/uml install
[ -n $tunctl ] && [ -f $out/bin/tunctl ] || fail_no_tunctl
