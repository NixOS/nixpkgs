. $stdenv/setup

PATH=$gzip:$PATH
 
$curl/bin/curl $src > $tarball
$tar/bin/tar zxvf $tarball
mkdir $out
cp -a gawk-3.1.3/* $out
