#! /bin/sh

envpkgs="$db4"
. $stdenv/setup || exit 1
export PATH=$perl/bin:$PATH

tar xvfz $src || exit 1
cd BerkeleyDB-* || exit 1

echo "LIB = $db4/lib" > config.in
echo "INCLUDE = $db4/include" >> config.in

perl Makefile.PL || exit 1
make || exit 1
make install PREFIX=$out || exit 1

echo $envpkgs > $out/envpkgs || exit 1
