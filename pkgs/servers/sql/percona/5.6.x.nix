{ lib, stdenv, fetchurl, cmake, bison, ncurses, openssl, zlib, libaio, perl }:

stdenv.mkDerivation rec {
  pname = "percona-server";
  version = "5.6.49-89.0";

  src = fetchurl {
    url = "https://www.percona.com/downloads/Percona-Server-5.6/Percona-Server-${version}/source/tarball/percona-server-${version}.tar.gz";
    sha256 = "09qqk02iny7jvngyk6k2j0kk2sspc6gw8sm3i6nn97njbkihi697";
  };

  nativeBuildInputs = [ cmake bison perl ];
  buildInputs = [ ncurses openssl zlib libaio ];

  cmakeFlags = [
    "-DFEATURE_SET=community"
    "-DBUILD_CONFIG=mysql_release"
    "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    "-DWITH_SSL=yes"
    "-DWITH_READLINE=no"
    "-DWITH_EMBEDDED_SERVER=no"
    "-DWITH_EDITLINE=bundled"
    "-DWITH_ZLIB=yes"
    "-DHAVE_IPV6=no"
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
  NIX_LDFLAGS = "-lgcc_s";

  prePatch = ''
    sed -i -e "s|/usr/bin/libtool|libtool|" cmake/libutils.cmake
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
