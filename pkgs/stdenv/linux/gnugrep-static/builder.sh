. $stdenv/setup

PATH=$gzip:$PATH
 
$curl/bin/curl $src > $tarball
$tar/bin/tar zxvf $tarball
mkdir $out
cp -a grep-2.5.1/* $out
