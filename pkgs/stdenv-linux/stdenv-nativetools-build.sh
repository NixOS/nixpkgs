#! /bin/sh

export PATH=/usr/local/bin:/usr/bin:/bin

mkdir $out || exit 1

sed \
 -e s^@GLIBC\@^$glibc^g \
 -e s^@CC\@^$cc^g \
 -e s^@CXX\@^$cxx^g \
 -e s^@BASEENV\@^$baseenv^g \
 -e s^@PATH\@^$p^g \
 -e s^@SHELL\@^$shell^g \
 < $setup > $out/setup || exit 1
