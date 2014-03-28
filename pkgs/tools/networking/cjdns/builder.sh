source $stdenv/setup

unpackPhase
cd git-export

./do

mkdir -p $out/bin
cp cjdroute $out/bin
