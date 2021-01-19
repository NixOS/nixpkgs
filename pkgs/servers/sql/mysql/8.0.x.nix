{ lib, stdenv, fetchurl, bison, cmake, pkg-config
, boost, icu, libedit, libevent, lz4, ncurses, openssl, protobuf, re2, readline, zlib, zstd
, numactl, perl, cctools, CoreServices, developer_cmds, libtirpc, rpcsvc-proto
}:

let
self = stdenv.mkDerivation rec {
  pname = "mysql";
  version = "8.0.22";

  src = fetchurl {
    url = "https://dev.mysql.com/get/Downloads/MySQL-${self.mysqlVersion}/${pname}-${version}.tar.gz";
    sha256 = "9fd85bb243940ef8234d21384ef421a0962fd4d13406fc1420efa902115ce17a";
  };

  patches = [
    ./abi-check.patch
  ];

  nativeBuildInputs = [ bison cmake pkg-config rpcsvc-proto ];

  ## NOTE: MySQL upstream frequently twiddles the invocations of libtool. When updating, you might proactively grep for libtool references.
  postPatch = ''
    substituteInPlace cmake/libutils.cmake --replace /usr/bin/libtool libtool
    substituteInPlace cmake/os/Darwin.cmake --replace /usr/bin/libtool libtool
  '';

  buildInputs = [
    boost icu libedit libevent lz4 ncurses openssl protobuf re2 readline zlib
    zstd
  ] ++ lib.optionals stdenv.isLinux [
    numactl libtirpc
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
