set -e

. $stdenv/setup

tar zxf $src
mkdir $out
mv jetty*/* $out
