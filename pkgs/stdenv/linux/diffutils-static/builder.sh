. $stdenv/setup

PATH=$gzip:$PATH
 
$curl/bin/curl $src > $tarball
$tar/bin/tar zxvf $tarball
mkdir $out
cp -a diffutils-2.8.1/* $out
