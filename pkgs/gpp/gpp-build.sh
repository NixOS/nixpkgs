#! /bin/sh
set -e
$pkgbuild --with-aterm=$aterm --with-sdf=$sdf2 --with-srts=$srts --with-xtc=$xtc \
    --with-stratego-front=$stratego_front
