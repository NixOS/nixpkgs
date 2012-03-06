set -e

source $stdenv/setup

unzip $src
mkdir -p $out/$name
mv jetty*/* $out/$name
