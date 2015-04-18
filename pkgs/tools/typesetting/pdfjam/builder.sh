source $stdenv/setup

tar zxvf $src

mkdir -p $out/bin
cp pdfjam/bin/* $out/bin

mkdir -p $out/man/man1
cp pdfjam/man1/* $out/man/man1
