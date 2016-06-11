{ stdenv, fetchurl, cmake, bison, ncurses, openssl, readline, zlib, perl, boost159 }:

# Note: zlib is not required; MySQL can use an internal zlib.

let x = stdenv.mkDerivation rec {
  name = "mysql-${version}";
  version = "5.7.12";

  src = fetchurl {
    url = http://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.12.tar.gz;
    md5 = "af17ba16f1b21538c9de092651529f7c";
  };

  preConfigure = stdenv.lib.optional stdenv.isDarwin ''
    ln -s /bin/ps $TMPDIR/ps
    export PATH=$PATH:$TMPDIR
  '';

  buildInputs = [ cmake bison ncurses openssl readline zlib perl boost159];

  enableParallelBuilding = true;

  cmakeFlags = "-DWITH_SSL=yes -DWITH_READLINE=yes -DWITH_EMBEDDED_SERVER=yes -DWITH_ZLIB=yes -DINSTALL_SCRIPTDIR=bin -DHAVE_IPV6=yes";

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  prePatch = ''
    sed -i -e "s|/usr/bin/libtool|libtool|" cmake/libutils.cmake
  '';
  postInstall = ''
    sed -i -e "s|basedir=\"\"|basedir=\"$out\"|" $out/bin/mysql_install_db
    rm -rf $out/mysql-test $out/sql-bench
  '';

  passthru.mysqlVersion = "5.7";

  passthru.mysql_initialize_datadir_cmd = {mysql, user, dataDir, ...}: ''
    [ -d ${dataDir}/mysql ] || ${mysql}/bin/mysqld --user=${user} --initialize --initialize-insecure --basedir=${mysql} --datadir=${dataDir}
  '';

  meta = {
    homepage = http://www.mysql.com/;
    description = "The world's most popular open source database";
  };
};

in x // { lib = x; }
