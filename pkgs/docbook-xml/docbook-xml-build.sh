#! /bin/sh

. $stdenv/setup || exit 1

mkdir -p $out/xml/dtd/docbook || exit 1
cd $out/xml/dtd/docbook || exit 1
unzip $src || exit 1
