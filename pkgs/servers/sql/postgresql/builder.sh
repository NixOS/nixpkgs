. $stdenv/setup

configureFlags=""
if test "$jdbcSupport"; then
    configureFlags="--with-java $configureFlags"
fi

genericBuild
