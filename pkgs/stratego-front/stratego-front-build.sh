#! /bin/sh
set -e
$pkgbuild --with-aterm=$aterm --with-sdf=$sdf2 --with-srts=$srts --with-xtc=$xtc

$xtc/bin/xtc -r $(REPOSITORY) import