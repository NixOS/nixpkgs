#! /bin/sh

. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd perl-* || exit 1

# Perl's Configure messes with PATH.  We can't have that, so we patch it.
# Yeah, this is an ugly hack.
grep -v '^paths=' Configure > Configure.tmp || exit 1
mv Configure.tmp Configure || exit 1
chmod +x Configure || exit 1

./Configure -de -Dcc=gcc -Dprefix=$out -Uinstallusrbinperl || exit 1
make || exit 1
make install || exit 1
