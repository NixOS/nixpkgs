buildInputs="$openssl $db4 $expat $perl"
. $stdenv/setup

configureFlags="--with-expat=$expat --enable-mods-shared=all --without-gdbm \
 --enable-threads --with-devrandom=/dev/urandom"

if test $db4Support; then
    configureFlags="--with-berkeley-db=$db4 $configureFlags"
fi

if test $sslSupport; then
    configureFlags="--enable-ssl --with-ssl=$openssl $configureFlags"
fi


postInstall() {
    echo "removing manual"
    rm -rf $out/manual
}
postInstall=postInstall


genericBuild
