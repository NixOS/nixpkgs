set -e
. $stdenv/setup

$unzip/bin/unzip $src
mkdir -p $out
mv $name/* $out
