{ stdenv, fetchurl, cmake, ncurses, openssl, pcre, boost, judy, bison, libxml2
, libaio, libevent, groff, jemalloc, perl, fixDarwinDylibNames
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "mariadb-${version}";
  version = "10.0.17";

  src = fetchurl {
    url    = "https://downloads.mariadb.org/interstitial/mariadb-${version}/source/mariadb-${version}.tar.gz";
    sha256 = "04ckq67qgkghh7yzrbzwidk7wn7yjml15gzj2c5p1hs2k7lr9lww";
  };

  buildInputs = [ cmake ncurses openssl pcre libxml2 boost judy bison libevent ]
    ++ stdenv.lib.optionals stdenv.isLinux [ jemalloc libaio ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ perl fixDarwinDylibNames ];

  patches = stdenv.lib.optional stdenv.isDarwin ./my_context_asm.patch;

  cmakeFlags = [
    "-DBUILD_CONFIG=mysql_release"
    "-DDEFAULT_CHARSET=utf8"
    "-DDEFAULT_COLLATION=utf8_general_ci"
    "-DENABLED_LOCAL_INFILE=ON"
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
    "-DWITH_READLINE=ON"
    "-DWITH_ZLIB=system"
    "-DWITH_SSL=system"
    "-DWITH_PCRE=system"
    "-DWITH_EMBEDDED_SERVER=yes"
    "-DWITH_EXTRA_CHARSETS=complex"
    "-DWITH_EMBEDDED_SERVER=ON"
    "-DWITH_ARCHIVE_STORAGE_ENGINE=1"
    "-DWITH_BLACKHOLE_STORAGE_ENGINE=1"
    "-DWITH_INNOBASE_STORAGE_ENGINE=1"
    "-DWITH_PARTITION_STORAGE_ENGINE=1"
    "-DWITHOUT_EXAMPLE_STORAGE_ENGINE=1"
    "-DWITHOUT_FEDERATED_STORAGE_ENGINE=1"
  ] ++ stdenv.lib.optional stdenv.isDarwin "-DWITHOUT_OQGRAPH_STORAGE_ENGINE=1";

  NIX_CFLAGS_COMPILE = "-Wno-error=cpp";

  enableParallelBuilding = true;

  prePatch = ''
    substituteInPlace cmake/libutils.cmake \
      --replace /usr/bin/libtool libtool
  '';
  postInstall = ''
    substituteInPlace $out/bin/mysql_install_db \
      --replace basedir=\"\" basedir=\"$out\"
  '';

  passthru.mysqlVersion = "5.6";

  meta = with stdenv.lib; {
    description = "An enhanced, drop-in replacement for MySQL";
    homepage    = https://mariadb.org/;
    license     = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ shlevy thoughtpolice wkennington ];
    platforms   = stdenv.lib.platforms.all;
  };
}
