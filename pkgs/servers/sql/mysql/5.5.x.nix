{ stdenv, fetchurl, cmake, bison, ncurses, openssl, readline, zlib, perl }:

# Note: zlib is not required; MySQL can use an internal zlib.

stdenv.mkDerivation rec {
  name = "mysql-${version}";
  version = "5.5.34";

  src = fetchurl {
    url = "http://cdn.mysql.com/Downloads/MySQL-5.5/${name}.tar.gz";
    md5 = "930970a42d51e48599deb7fe01778a4a";
  };

  buildInputs = [ cmake bison ncurses openssl readline zlib ]
     ++ stdenv.lib.optional stdenv.isDarwin perl;

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

  passthru.mysqlVersion = "5.5";

  meta = {
    homepage = http://www.mysql.com/;
    description = "The world's most popular open source database";
  };
}
