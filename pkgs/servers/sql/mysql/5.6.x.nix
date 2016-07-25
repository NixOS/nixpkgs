{ stdenv, fetchurl, cmake, bison, ncurses, openssl, readline, zlib, perl }:

# Note: zlib is not required; MySQL can use an internal zlib.

let x = stdenv.mkDerivation rec {
  name = "mysql-${version}";
  version = "5.6.23";

  src = fetchurl {
    url = "http://cdn.mysql.com/Downloads/MySQL-5.6/${name}.tar.gz";
    md5 = "60344f26eae136a267a0277407926e79";
  };

  preConfigure = stdenv.lib.optional stdenv.isDarwin ''
    ln -s /bin/ps $TMPDIR/ps
    export PATH=$PATH:$TMPDIR
  '';

  buildInputs = [ cmake bison ncurses openssl readline zlib perl ];

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

  passthru.mysqlVersion = "5.6";
  passthru.mysqld_path = "libexec";

  passthru.mysql_initialize_datadir_cmd = {mysql, user, dataDir, ...}: ''
    ${mysql}/bin/mysql_install_db "--user=${user} --datadir=${dataDir} --basedir=${mysql} ";
  '';

  meta = {
    homepage = http://www.mysql.com/;
    description = "The world's most popular open source database";
  };
};

in x // { lib = x; }
