if test -z "$out"; then
  stdenv=$STDENV
  out=$OUT
  src=$SRC
  exename=$EXENAME
fi

source $stdenv/setup

mkdir $out
mkdir $out/bin
cp $src $out/bin/$exename
