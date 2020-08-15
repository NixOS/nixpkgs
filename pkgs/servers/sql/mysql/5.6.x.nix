{ stdenv, fetchurl, cmake, bison, ncurses, openssl, readline, zlib, perl }:

# mysql 5.6 is pretty old 3d slicer binary depends on it.
# Maybe renaming .so libraries would do it as well.
# I haven't checked binary compatibility
# Note: zlib is not required; MySQL can use an internal zlib.

let x = stdenv.mkDerivation rec {
  name = "mysql-${version}";
  version = "5.6.48";

  src = fetchurl {
    url = https://cdn.mysql.com//Downloads/MySQL-5.6/mysql-5.6.48.tar.gz;
    sha256 = "1hima34vnq92pdrhrm9acranplq0vjvahf3wg3siyk7ps6n27942";
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
  passthru.mysqld_path = "bin";

  passthru.mysql_initialize_datadir_cmd = {mysql, user, dataDir, ...}: ''
    ${mysql}/bin/mysql_install_db "--user=${user} --datadir=${dataDir} --basedir=${mysql} ";
  '';

  meta = {
    homepage = http://www.mysql.com/;
    description = "The world's most popular open source database"; };
};

in x // { lib = x; }
