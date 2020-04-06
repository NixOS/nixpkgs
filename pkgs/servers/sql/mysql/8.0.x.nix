{ lib, stdenv, fetchurl, bison, cmake, pkgconfig
, boost, icu, libedit, libevent, lz4, ncurses, openssl, protobuf, re2, readline, zlib
, numactl, perl, cctools, CoreServices, developer_cmds
}:

let
self = stdenv.mkDerivation rec {
  pname = "mysql";
  version = "8.0.17";

  src = fetchurl {
    url = "https://dev.mysql.com/get/Downloads/MySQL-${self.mysqlVersion}/${pname}-${version}.tar.gz";
    sha256 = "1mjrlxn8vigi69r0r674j2dibdnkaar01ji5965gsyx7k60z7qy6";
  };

  patches = [
    ./abi-check.patch
    ./libutils.patch
  ];

  nativeBuildInputs = [ bison cmake pkgconfig ];

  buildInputs = [
    boost icu libedit libevent lz4 ncurses openssl protobuf re2 readline zlib
  ] ++ lib.optionals stdenv.isLinux [
    numactl
  ] ++ lib.optionals stdenv.isDarwin [
    cctools CoreServices developer_cmds
  ];

  outputs = [ "out" "static" ];

  cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=OFF" # To run libmysql/libmysql_api_test during build.
    "-DFORCE_UNSUPPORTED_COMPILER=1" # To configure on Darwin.
    "-DWITH_ROUTER=OFF" # It may be packaged separately.
    "-DWITH_SYSTEM_LIBS=ON"
    "-DWITH_UNIT_TESTS=OFF"
    "-DMYSQL_UNIX_ADDR=/run/mysqld/mysqld.sock"
    "-DMYSQL_DATADIR=/var/lib/mysql"
    "-DINSTALL_INFODIR=share/mysql/docs"
    "-DINSTALL_MANDIR=share/man"
    "-DINSTALL_PLUGINDIR=lib/mysql/plugin"
    "-DINSTALL_INCLUDEDIR=include/mysql"
    "-DINSTALL_DOCREADMEDIR=share/mysql"
    "-DINSTALL_SUPPORTFILESDIR=share/mysql"
    "-DINSTALL_MYSQLSHAREDIR=share/mysql"
    "-DINSTALL_MYSQLTESTDIR="
    "-DINSTALL_DOCDIR=share/mysql/docs"
    "-DINSTALL_SHAREDIR=share/mysql"
  ];

  postInstall = ''
    moveToOutput "lib/*.a" $static
    so=${stdenv.hostPlatform.extensions.sharedLibrary}
    ln -s libmysqlclient$so $out/lib/libmysqlclient_r$so
  '';

  passthru = {
    client = self;
    connector-c = self;
    server = self;
    mysqlVersion = "8.0";
  };

  meta = with lib; {
    homepage = "https://www.mysql.com/";
    description = "The world's most popular open source database";
    license = licenses.gpl2;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.unix;
  };
}; in self
