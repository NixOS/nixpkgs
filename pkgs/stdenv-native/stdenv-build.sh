#! /bin/sh

export PATH=/bin:/usr/bin

mkdir $out || exit 1
mkdir $out/bin || exit 1

echo "export PATH=$out/bin:/bin:/usr/bin" >> $out/setup || exit 1

gcc=/usr/bin/gcc

sed \
 -e s^@GCC\@^$gcc^g \
 < $gccwrapper > $out/bin/gcc || exit 1
chmod +x $out/bin/gcc || exit 1

ln -s gcc $out/bin/cc

gplusplus=/usr/bin/g++

sed \
 -e s^@GCC\@^$gplusplus^g \
 < $gccwrapper > $out/bin/g++ || exit 1
chmod +x $out/bin/g++ || exit 1

ln -s g++ $out/bin/c++
