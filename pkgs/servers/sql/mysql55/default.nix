{stdenv, fetchurl, cmake, bison, ncurses, openssl, readline, zlib, darwinInstallNameToolUtility, perl}:

# Note: zlib is not required; MySQL can use an internal zlib.

stdenv.mkDerivation {
  name = "mysql-5.5.23";

  src = fetchurl {
    url = ftp://ftp.inria.fr/pub/MySQL/Downloads/MySQL-5.5/mysql-5.5.23.tar.gz;
    sha256 = "0sklcz6miff7nb6bi1pqncgjv819255y7if6jxcqgiqs50z319i0";
  };

  buildInputs = [ cmake bison ncurses openssl readline zlib ] ++ stdenv.lib.optionals stdenv.isDarwin [ darwinInstallNameToolUtility perl ];
  
  cmakeFlags = "-DWITH_SSL=yes -DWITH_READLINE=yes -DWITH_EMBEDDED_SERVER=yes -DWITH_ZLIB=yes -DINSTALL_SCRIPTDIR=bin -DHAVE_IPV6=yes";
  
  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  postInstall = ''
    sed -i -e "s|basedir=\"\"|basedir=\"$out\"|" $out/bin/mysql_install_db
    rm -rf $out/mysql-test $out/sql-bench
  '';

  meta = {
    homepage = http://www.mysql.com/;
    description = "The world's most popular open source database";
  };
}
