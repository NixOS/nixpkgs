#! /bin/sh

. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd perl-* || exit 1

# Perl's Configure messes with PATH.  We can't have that, so we patch it.
# Yeah, this is an ugly hack.
cat Configure | \
 grep -v '^paths=' | \
 grep -v '^locincpth=' | \
 grep -v '^xlibpth=' | \
 grep -v '^glibpth=' | \
 grep -v '^loclibpth=' | \
 grep -v '^locincpth=' | \
 cat > Configure.tmp || exit 1
mv Configure.tmp Configure || exit 1
chmod +x Configure || exit 1

./Configure -de -Dcc=gcc -Dprefix=$out -Uinstallusrbinperl \
 -Dlocincpth="$NIX_LIBC_INCLUDES" \
 -Dloclibpth="$NIX_LIBC_LIBS" \
 || exit 1
make || exit 1
make install || exit 1
