#! /bin/sh

. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd sdf2-* || exit 1
./configure --prefix=$out --with-aterm=$aterm || exit 1
make || exit 1
make install || exit 1

# Replace the call to getopt in sdf2table with an absolute path (so that the
# users of sdf2table don't have to explicitly declare getopt as an input).
sdf2table=$out/bin/sdf2table
sed s^getopt^$getopt/bin/getopt^ < $sdf2table > $sdf2table.tmp || exit 1
mv $sdf2table.tmp $sdf2table || exit 1
chmod +x $sdf2table || exit 1
