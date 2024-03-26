{ lib
, stdenv
, pkg-config
, cmake
, fetchurl
, git
, cctools
, DarwinTools
, makeWrapper
, CoreServices
, bison
, openssl
, protobuf
, curl
, zlib
, libssh
, zstd
, lz4
, readline
, libtirpc
, rpcsvc-proto
, libedit
, libevent
, icu
, re2
, ncurses
, libfido2
, python3
, cyrus_sasl
, openldap
, antlr
}:

let
  pythonDeps = with python3.pkgs; [ certifi paramiko pyyaml ];

  mysqlShellVersion = "8.3.0";
  mysqlServerVersion = "8.3.0";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mysql-shell-innovation";
  version = mysqlShellVersion;

  srcs = [
    (fetchurl {
      url = "https://cdn.mysql.com//Downloads/MySQL-${lib.versions.majorMinor mysqlServerVersion}/mysql-${mysqlServerVersion}.tar.gz";
      hash = "sha256-HyFJWgt6grJKRT1S4hU6gUs8pwTsz5mXZtVFvOUvOG4=";
    })
    (fetchurl {
      url = "https://cdn.mysql.com//Downloads/MySQL-Shell/mysql-shell-${finalAttrs.version}-src.tar.gz";
      hash = "sha256-O0j/gvS9fR/xp9plytjj249H7LY/+eyst1IsFpy318U=";
    })
  ];

  sourceRoot = "mysql-shell-${finalAttrs.version}-src";

  postUnpack = ''
    mv mysql-${mysqlServerVersion} mysql
  '';

  postPatch = ''
    substituteInPlace ../mysql/cmake/libutils.cmake --replace /usr/bin/libtool libtool
    substituteInPlace ../mysql/cmake/os/Darwin.cmake --replace /usr/bin/libtool libtool

    substituteInPlace cmake/libutils.cmake --replace /usr/bin/libtool libtool
  '';

  nativeBuildInputs = [ pkg-config cmake git bison makeWrapper ]
    ++ lib.optionals (!stdenv.isDarwin) [ rpcsvc-proto ]
    ++ lib.optionals stdenv.isDarwin [ cctools DarwinTools ];

  buildInputs = [
    curl
    libedit
    libssh
    lz4
    openssl
    protobuf
    readline
    zlib
    zstd
    libevent
    icu
    re2
    ncurses
    libfido2
    cyrus_sasl
    openldap
    python3
    antlr.runtime.cpp
  ] ++ pythonDeps
  ++ lib.optionals stdenv.isLinux [ libtirpc ]
  ++ lib.optionals stdenv.isDarwin [ CoreServices ];

  preConfigure = ''
    # Build MySQL
    echo "Building mysqlclient mysqlxclient"

    cmake -DWITH_SYSTEM_LIBS=ON -DWITH_FIDO=system -DWITH_ROUTER=OFF -DWITH_UNIT_TESTS=OFF \
      -DFORCE_UNSUPPORTED_COMPILER=1 -S ../mysql -B ../mysql/build

    cmake --build ../mysql/build --parallel ''${NIX_BUILD_CORES:-1} --target mysqlclient mysqlxclient
  '';

  cmakeFlags = [
    "-DMYSQL_SOURCE_DIR=../mysql"
    "-DMYSQL_BUILD_DIR=../mysql/build"
    "-DMYSQL_CONFIG_EXECUTABLE=../../mysql/build/scripts/mysql_config"
    "-DWITH_ZSTD=system"
    "-DWITH_LZ4=system"
    "-DWITH_ZLIB=system"
    "-DWITH_PROTOBUF=${protobuf}"
    "-DHAVE_PYTHON=1"
  ];

  postFixup = ''
    wrapProgram $out/bin/mysqlsh --set PYTHONPATH "${lib.makeSearchPath python3.sitePackages pythonDeps}"
  '';

  meta = with lib; {
    homepage = "https://dev.mysql.com/doc/mysql-shell/${lib.versions.majorMinor finalAttrs.version}/en/";
    description = "A new command line scriptable shell for MySQL";
    license = licenses.gpl2;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "mysqlsh";
  };
})
