{ lib, stdenv, fetchurl, cmake, boost, bison, ncurses, openssl, readline, zlib, perl }:

# Note: zlib is not required; MySQL can use an internal zlib.

stdenv.mkDerivation rec {
  pname = "percona-server";
  version = "5.6.51-91.0";

  src = fetchurl {
    url = "https://www.percona.com/downloads/Percona-Server-5.6/Percona-Server-${version}/source/tarball/percona-server-${version}.tar.gz";
    sha256 = "0byxjzpksqpngm1dd95slic5yddb2x4bb36gchf5dfgb4k8w30j4";
  };

  buildInputs = [
    cmake bison ncurses openssl readline zlib boost.out boost.dev
  ] ++ lib.optional stdenv.isDarwin perl;

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DWITH_SSL=yes"
    "-DWITH_EMBEDDED_SERVER=no"
    "-DWITH_ZLIB=yes"
    "-DWITH_EDITLINE=bundled"
    "-DHAVE_IPV6=yes"
    "-DMYSQL_UNIX_ADDR=/run/mysqld/mysqld.sock"
    "-DMYSQL_DATADIR=/var/lib/mysql"
    "-DINSTALL_SYSCONFDIR=etc/mysql"
    "-DINSTALL_INFODIR=share/mysql/docs"
    "-DINSTALL_MANDIR=share/man"
    "-DINSTALL_PLUGINDIR=lib/mysql/plugin"
    "-DINSTALL_SCRIPTDIR=bin"
    "-DINSTALL_INCLUDEDIR=include/mysql"
    "-DINSTALL_DOCREADMEDIR=share/mysql"
    "-DINSTALL_SUPPORTFILESDIR=share/mysql"
    "-DINSTALL_MYSQLSHAREDIR=share/mysql"
    "-DINSTALL_DOCDIR=share/mysql/docs"
    "-DINSTALL_SHAREDIR=share/mysql"
  ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=address-of-packed-member" ];
  NIX_LDFLAGS = lib.optionalString stdenv.isLinux "-lgcc_s";

  prePatch = ''
    sed -i -e "s|/usr/bin/libtool|libtool|" cmake/libutils.cmake
  '';

  preConfigure = lib.optional stdenv.isDarwin ''
    ln -s /bin/ps $TMPDIR/ps
    export PATH=$PATH:$TMPDIR
  '';

  postInstall = ''
    sed -i -e "s|basedir=\"\"|basedir=\"$out\"|" $out/bin/mysql_install_db
    rm -r $out/mysql-test $out/sql-bench $out/data "$out"/lib/*.a
  '';

  passthru.mysqlVersion = "5.6";

  meta = with lib; {
    homepage = "https://www.percona.com";
    description = "a free, fully compatible, enhanced, open source drop-in replacement for MySQL that provides superior performance, scalability and instrumentation";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ grahamc ];
  };
}
