#! /bin/sh

export PATH=/bin:/usr/bin

mkdir $out || exit 1
mkdir $out/bin || exit 1

echo "export PATH=$out/bin:/bin:/usr/bin" >> $out/setup || exit 1

gcc=/usr/bin/gcc

sed \
 -e s^@GCC\@^$gcc^g \
 -e s^@LIBC\@^$glibc^g \
 < $gccwrapper > $out/bin/gcc || exit 1
chmod +x $out/bin/gcc || exit 1

sed \
 -e s^@GCC\@^$g++^g \
 -e s^@LIBC\@^$glibc^g \
 < $gccwrapper > $out/bin/g++ || exit 1
chmod +x $out/bin/g++ || exit 1
