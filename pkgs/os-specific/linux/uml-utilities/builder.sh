buildinputs=""
source $stdenv/setup

tar xvfj $src
cd tools
[ -n "$tunctl" ] && sed -e '1s/.*/TUNCTL = tunctl/' -i Makefile
[ -z "$mconsole" ] && sed -e 's/mconsole//' -i Makefile

mkdir $out
mkdir $out/bin
mkdir $out/lib
mkdir $out/lib/uml
make BIN_DIR=$out/bin LIB_DIR=$out/lib/uml
make BIN_DIR=$out/bin LIB_DIR=$out/lib/uml install
ln -s $out/lib/uml/port-helper $out/bin/port-helper
[ -z "$tunctl" ] || [ -f $out/bin/tunctl ] || fail_no_tunctl
[ -z "$mconsole" ] || [ -f $out/bin/uml_mconsole ] || fail_no_mconsole
