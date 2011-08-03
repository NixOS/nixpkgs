{stdenv, fetchurl, cmake, bison, ncurses, openssl, readline, zlib}:

# Note: zlib is not required; MySQL can use an internal zlib.

stdenv.mkDerivation {
  name = "mysql-5.5.15";

  src = fetchurl {
    url = ftp://mirror.leaseweb.com/mysql/Downloads/MySQL-5.5/mysql-5.5.15.tar.gz;
    sha256 = "10jwkkmp231swc986z01nsp0q67kp0zdkfb4q4v9if2vn6a51ldy";
  };

  buildInputs = [ cmake bison ncurses openssl readline zlib ];
  
  cmakeFlags = "-DWITH_SSL=yes -DWITH_READLINE=yes -DWITH_EMBEDDED_SERVER=yes -DWITH_ZLIB=yes -DINSTALL_SCRIPTDIR=bin";
  
  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  postInstall = ''
    sed -i -e "s|basedir=\"\"|basedir=\"$out\"|" $out/bin/mysql_install_db
  '';

  meta = {
    homepage = http://www.mysql.com/;
    description = "The world's most popular open source database";
  };
}
