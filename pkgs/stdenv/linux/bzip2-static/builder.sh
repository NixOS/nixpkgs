. $stdenv/setup

PATH=$gzip:$PATH

$curl/bin/curl $src > $tarball
$tar/bin/tar zxvf $tarball
mkdir $out
cp -a bzip2-1.0.2/* $out
