{ lib, stdenv, fetchurl, cmake, bison, pkg-config
, boost, libedit, libevent, lz4, ncurses, openssl, protobuf, readline, zlib, perl
, cctools, CoreServices, developer_cmds
, libtirpc, rpcsvc-proto, nixosTests
}:

# Note: zlib is not required; MySQL can use an internal zlib.

let
self = stdenv.mkDerivation rec {
  pname = "mysql";
  version = "5.7.37";

  src = fetchurl {
    url = "mirror://mysql/MySQL-5.7/${pname}-${version}.tar.gz";
    sha256 = "sha256-qZqaqGNdJWbat2Sy3la+0XMDZdNg4guyf1Y5LOVOGL0=";
  };

  preConfigure = lib.optionalString stdenv.isDarwin ''
    ln -s /bin/ps $TMPDIR/ps
    export PATH=$PATH:$TMPDIR
  '';

  nativeBuildInputs = [ bison cmake pkg-config ]
    ++ lib.optionals (!stdenv.isDarwin) [ rpcsvc-proto ];

  buildInputs = [ boost libedit libevent lz4 ncurses openssl protobuf readline zlib ]
     ++ lib.optionals stdenv.isDarwin [ perl cctools CoreServices developer_cmds ]
     ++ lib.optionals stdenv.isLinux [ libtirpc ];

  outputs = [ "out" "static" ];

  cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=OFF" # To run libmysql/libmysql_api_test during build.
    "-DWITH_SSL=yes"
    "-DWITH_EMBEDDED_SERVER=yes"
    "-DWITH_UNIT_TESTS=no"
    "-DWITH_EDITLINE=system"
    "-DWITH_LIBEVENT=system"
    "-DWITH_LZ4=system"
    "-DWITH_PROTOBUF=system"
    "-DWITH_ZLIB=system"
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

  CXXFLAGS = "-fpermissive -std=c++11";
  NIX_LDFLAGS = lib.optionalString stdenv.isLinux "-lgcc_s";

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
    tests = nixosTests.mysql.mysql57;
  };

  meta = with lib; {
    homepage = "https://www.mysql.com/";
    description = "The world's most popular open source database";
    platforms = platforms.unix;
    license = with licenses; [
      artistic1 bsd0 bsd2 bsd3 bsdOriginal
      gpl2 lgpl2 lgpl21 mit publicDomain licenses.zlib
    ];
  };
}; in self
