#! /bin/sh

. $stdenv/setup || exit 1

envpkgs="$ssl $db4 $httpd $swig $libxml"
. $setenv

if test $localServer; then
    extraflags="--with-berkeley-db=$db4 $extraflags"
fi

if test $httpsClient; then
    extraflags="--with-ssl --with-libs=$ssl $extraflags"
fi

if test $httpServer; then
    extraflags="--with-apxs=$httpd/bin/apxs --with-apr=$httpd --with-apr-util=$httpd $extraflags"
    extramakeflags="APACHE_LIBEXECDIR=$out/modules $extramakeflags"
fi

if test $pythonBindings; then
    extraflags="--with-swig=$swig $extraflags"
fi

echo "extra flags: $extraflags"

tar xvfz $src || exit 1
cd subversion-* || exit 1
LDFLAGS=-Wl,-S ./configure --prefix=$out $extraflags --without-gdbm || exit 1
make $extramakeflags || exit 1
make install $extramakeflags || exit 1

if test $pythonBindings; then
    make swig-py || exit 1
    make install-swig-py || exit 1
fi

echo $envpkgs > $out/envpkgs || exit 1
