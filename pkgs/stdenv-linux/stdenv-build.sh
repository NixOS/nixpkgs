#! /bin/sh

export PATH=/bin:/usr/bin

mkdir $out || exit 1

sed \
 -e s^@GLIBC\@^$glibc^g \
 -e s^@BASEENV\@^$baseenv^g \
 -e s^@NATIVETOOLS\@^$nativeTools^g \
 -e s^@COREUTILS\@^$coreutils^g \
 < $setup > $out/setup || exit 1
