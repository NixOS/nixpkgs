source $stdenv/setup

if test "$sslSupport"; then
  configureFlags="--with-ssl=$openssl"
else
  configureFlags="--without-ssl"
fi

genericBuild
