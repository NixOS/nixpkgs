set -e

source $stdenv/setup

unzip $src
mkdir $out
mv jetty*/* $out
