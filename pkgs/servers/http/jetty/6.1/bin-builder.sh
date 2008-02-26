set -e

source $stdenv/setup

unzip $src
ensureDir $out/$name
mv jetty*/* $out/$name
