source $stdenv/setup

unpackPhase
cd git-export

bash do

mkdir -p $out/sbin
cp cjdroute $out/sbin
