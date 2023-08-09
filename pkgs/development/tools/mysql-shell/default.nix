{ lib
, stdenv
, pkg-config
, cmake
, fetchurl
, git
, cctools
, developer_cmds
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
, boost
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
in
stdenv.mkDerivation rec {
  pname = "mysql-shell";
  version = "8.0.34";

  srcs = [
    (fetchurl {
      url = "https://cdn.mysql.com//Downloads/MySQL-Shell/mysql-shell-${version}-src.tar.gz";
      hash = "sha256-QY1PmhGw3PhqZ79+H/Xbb9uOvmrBlFQRS7idnV5OXF0=";
    })
    (fetchurl {
      url = "https://dev.mysql.com/get/Downloads/MySQL-${lib.versions.majorMinor version}/mysql-${version}.tar.gz";
      hash = "sha256-5l0Do8QmGLX7+ZBCrtMyCUAumyeqYsfIdD/9R4jY2x0=";
    })
  ];

  sourceRoot = "mysql-shell-${version}-src";

  postPatch = ''
    substituteInPlace ../mysql-${version}/cmake/libutils.cmake --replace /usr/bin/libtool libtool
    substituteInPlace ../mysql-${version}/cmake/os/Darwin.cmake --replace /usr/bin/libtool libtool

    substituteInPlace cmake/libutils.cmake --replace /usr/bin/libtool libtool
  '';

  nativeBuildInputs = [ pkg-config cmake git bison makeWrapper ]
    ++ lib.optionals (!stdenv.isDarwin) [ rpcsvc-proto ]
    ++ lib.optionals stdenv.isDarwin [ cctools developer_cmds DarwinTools ];

  buildInputs = [
    boost
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

    cmake -DWITH_BOOST=system -DWITH_SYSTEM_LIBS=ON -DWITH_ROUTER=OFF -DWITH_UNIT_TESTS=OFF \
      -DFORCE_UNSUPPORTED_COMPILER=1 -S ../mysql-${version} -B ../mysql-${version}/build

    cmake --build ../mysql-${version}/build --parallel ''${NIX_BUILD_CORES:-1} --target mysqlclient mysqlxclient
  '';

  cmakeFlags = [
    "-DMYSQL_SOURCE_DIR=../mysql-${version}"
    "-DMYSQL_BUILD_DIR=../mysql-${version}/build"
    "-DMYSQL_CONFIG_EXECUTABLE=../../mysql-${version}/build/scripts/mysql_config"
    "-DWITH_ZSTD=system"
    "-DWITH_LZ4=system"
    "-DWITH_ZLIB=system"
    "-DWITH_PROTOBUF=${protobuf}"
    "-DHAVE_V8=0" # V8 10.x required.
    "-DHAVE_PYTHON=1"
  ];

  postFixup = ''
    wrapProgram $out/bin/mysqlsh --set PYTHONPATH "${lib.makeSearchPath python3.sitePackages pythonDeps}"
  '';

  meta = with lib; {
    homepage = "https://dev.mysql.com/doc/mysql-shell/${lib.versions.majorMinor version}/en/";
    description = "A new command line scriptable shell for MySQL";
    license = licenses.gpl2;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "mysqlsh";
  };
}
