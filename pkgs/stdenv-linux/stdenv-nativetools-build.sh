#! /bin/sh

export PATH=/bin:/usr/bin

mkdir $out || exit 1

p='$PATH:/usr/local/bin:/usr/bin:/bin'

cc=/usr/bin/gcc
cxx=/usr/bin/g++
shell=/bin/sh

echo "########## $p"

sed \
 -e s^@GLIBC\@^$glibc^g \
 -e s^@CC\@^$cc^g \
 -e s^@CXX\@^$cxx^g \
 -e s^@BASEENV\@^$baseenv^g \
 -e s^@PATH\@^$p^g \
 -e s^@SHELL\@^$shell^g \
 < $setup > $out/setup || exit 1
