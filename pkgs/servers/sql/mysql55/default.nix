{stdenv, fetchurl, cmake, bison, ncurses, openssl, readline, zlib, darwinInstallNameToolUtility, perl}:

# Note: zlib is not required; MySQL can use an internal zlib.

stdenv.mkDerivation {
  name = "mysql-5.5.20";

  src = fetchurl {
    url = ftp://mirror.leaseweb.com/mysql/Downloads/MySQL-5.5/mysql-5.5.20.tar.gz;
    sha256 = "03jl60mzrsd1jb8fvkz6c8j2239b37k8n1i07jk1q4yk58aq8ynh";
  };

  buildInputs = [ cmake bison ncurses openssl readline zlib ] ++ stdenv.lib.optionals stdenv.isDarwin [ darwinInstallNameToolUtility perl ];
  
  cmakeFlags = "-DWITH_SSL=yes -DWITH_READLINE=yes -DWITH_EMBEDDED_SERVER=yes -DWITH_ZLIB=yes -DINSTALL_SCRIPTDIR=bin";
  
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
