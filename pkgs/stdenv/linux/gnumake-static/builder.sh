. $stdenv/setup

PATH=$gzip:$PATH
 
$curl/bin/curl $src > $tarball
$tar/bin/tar zxvf $tarball
mkdir $out
cp -a make-3.80/* $out
