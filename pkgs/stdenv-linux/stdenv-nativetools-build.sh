#! /bin/sh

export PATH=/usr/local/bin:/usr/bin:/bin

mkdir $out || exit 1

sed \
 -e s^@GLIBC\@^$glibc^g \
 -e s^@BASEENV\@^$baseenv^g \
 < $setup > $out/setup || exit 1
