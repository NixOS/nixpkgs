#! /bin/sh

export PATH=/bin:/usr/bin

mkdir $out || exit 1

if test "$nativeTools" == 1; then
    p='$PATH:/usr/local/bin:/usr/bin:/bin'

    cc=/usr/bin/gcc
    cxx=/usr/bin/g++
else
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
    p=$p':$PATH'

    cc=$gcc/bin/gcc
    cxx=$gcc/bin/g++
fi

echo "########## $p"

sed \
 -e s^@GLIBC\@^$glibc^g \
 -e s^@CC\@^$cc^g \
 -e s^@CXX\@^$cxx^g \
 -e s^@BASEENV\@^$baseenv^g \
 -e s^@PATH\@^$p^g \
 < $setup > $out/setup || exit 1
