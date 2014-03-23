source $stdenv/setup

unpackPhase
cd git-export

./do

mkdir -p $out/sbin
cp cjdroute $out/sbin
