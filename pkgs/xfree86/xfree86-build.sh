#! /bin/sh

. $stdenv/setup || exit 1
export PATH=$bison/bin:$flex/bin:$PATH

# For libfl.a (flex); assuming it's a static library. 
export NIX_CFLAGS_LINK="-L$flex/lib $NIX_CFLAGS_LINK"

tar xvfz $src1 || exit 1
tar xvfz $src2 || exit 1
tar xvfz $src3 || exit 1
cd xc || exit 1
sed "s^@OUT@^$out^" < $hostdef > config/cf/host.def
make World || exit 1
make install || exit 1
