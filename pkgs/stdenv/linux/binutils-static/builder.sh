. $stdenv/setup

PATH=$gzip:$PATH
 
$curl/bin/curl $src > $tarball
$tar/bin/tar zxvf $tarball
mkdir $out
cp -a binutils-2.15/* $out
