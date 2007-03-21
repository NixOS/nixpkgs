source $stdenv/setup

tar zxvf $src

ensureDir $out/bin
cp pdfjam/scripts/* $out/bin

ensureDir $out/man/man1
cp pdfjam/man1/* $out/man/man1
