#! /bin/sh -e

. $stdenv/setup

tar xvfj $src
cd binutils-*

# Clear the default library search path.
if test "$enforcePurity" = "1"; then
    echo 'NATIVE_LIB_DIRS=' >> ld/configure.tgt
fi

./configure --prefix=$out
make
make install

strip -S $out/lib/*.a
