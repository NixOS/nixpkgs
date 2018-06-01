{ stdenv, fetchurl, cmake, bison, ncurses, openssl, readline, zlib, perl
, boost, cctools, CoreServices, developer_cmds }:

# Note: zlib is not required; MySQL can use an internal zlib.

let
self = stdenv.mkDerivation rec {
  name = "mysql-${version}";
  version = "5.7.22";

  src = fetchurl {
    url = "mirror://mysql/MySQL-5.7/${name}.tar.gz";
    sha256 = "1wng15j5caz6fsv28avlcxjgq3c5n90ifk79xa0h7jws19dl1f2f";
  };

  preConfigure = stdenv.lib.optional stdenv.isDarwin ''
    ln -s /bin/ps $TMPDIR/ps
    export PATH=$PATH:$TMPDIR
  '';

  buildInputs = [ cmake bison ncurses openssl readline zlib boost ]
     ++ stdenv.lib.optionals stdenv.isDarwin [ perl cctools CoreServices developer_cmds ];

  enableParallelBuilding = true;

  outputs = [ "out" "static" ];

  cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=OFF" # To run libmysql/libmysql_api_test during build.
    "-DWITH_SSL=yes"
    "-DWITH_EMBEDDED_SERVER=yes"
    "-DWITH_UNIT_TESTS=no"
    "-DWITH_ZLIB=yes"
    "-DWITH_ARCHIVE_STORAGE_ENGINE=yes"
    "-DWITH_BLACKHOLE_STORAGE_ENGINE=yes"
    "-DWITH_FEDERATED_STORAGE_ENGINE=yes"
    "-DHAVE_IPV6=yes"
    "-DMYSQL_UNIX_ADDR=/run/mysqld/mysqld.sock"
    "-DMYSQL_DATADIR=/var/lib/mysql"
    "-DINSTALL_INFODIR=share/mysql/docs"
    "-DINSTALL_MANDIR=share/man"
    "-DINSTALL_PLUGINDIR=lib/mysql/plugin"
    "-DINSTALL_SCRIPTDIR=bin"
    "-DINSTALL_INCLUDEDIR=include/mysql"
    "-DINSTALL_DOCREADMEDIR=share/mysql"
    "-DINSTALL_SUPPORTFILESDIR=share/mysql"
    "-DINSTALL_MYSQLSHAREDIR=share/mysql"
    "-DINSTALL_MYSQLTESTDIR="
    "-DINSTALL_DOCDIR=share/mysql/docs"
    "-DINSTALL_SHAREDIR=share/mysql"
  ];

  CXXFLAGS = "-fpermissive";
  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  prePatch = ''
    sed -i -e "s|/usr/bin/libtool|libtool|" cmake/merge_archives.cmake.in
  '';
  postInstall = ''
    moveToOutput "lib/*.a" $static
    ln -s libmysqlclient${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/libmysqlclient_r${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  passthru = {
    client = self;
    connector-c = self;
    server = self;
    mysqlVersion = "5.7";
  };

  meta = {
    homepage = https://www.mysql.com/;
    description = "The world's most popular open source database";
    platforms = stdenv.lib.platforms.unix;
  };
}; in self
