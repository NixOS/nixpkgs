{ stdenv, fetchurl, cmake, bison, ncurses, openssl, readline, zlib, perl }:

# Note: zlib is not required; MySQL can use an internal zlib.

stdenv.mkDerivation rec {
  name = "mysql-${version}";
  version = "5.5.28";

  src = fetchurl {
    urls = [
      "mirror://sourceforge/mysql.mirror/${name}.tar.gz"
      "http://mysql.linux.cz/Downloads/MySQL-5.5/${name}.tar.gz"
      "http://ftp.gwdg.de/pub/misc/mysql/Downloads/MySQL-5.5/${name}.tar.gz"
    ];
    sha256 = "13y7bhjmx4daidvyqjz88yffbswb6rc1khkmiqm896fx3lglkcpr";
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

  meta = {
    homepage = http://www.mysql.com/;
    description = "The world's most popular open source database";
  };
}
