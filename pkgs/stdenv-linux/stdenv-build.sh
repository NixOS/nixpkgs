#! /bin/sh

export PATH=/bin:/usr/bin

mkdir $out || exit 1

p=
first=1
for i in $tools; do
    if test "$first" == 1; then
	first=
    else
	p=$p:
    fi
    p=$p$i/bin
done

cc=$gcc/bin/gcc
cxx=$gcc/bin/g++
shell=$shell/bin/sh

echo "########## $p"

sed \
 -e s^@GLIBC\@^$glibc^g \
 -e s^@GCC\@^$gcc^g \
 -e s^@CC\@^$cc^g \
 -e s^@CXX\@^$cxx^g \
 -e s^@BASEENV\@^$baseenv^g \
 -e s^@PATH\@^$p^g \
 -e s^@SHELL\@^$shell^g \
 < $setup > $out/setup || exit 1
