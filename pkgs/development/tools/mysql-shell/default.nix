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
stdenv.mkDerivation (finalAttrs: {
  pname = "mysql-shell";
  version = "8.0.37";

  srcs = [
    (fetchurl {
      url = "https://dev.mysql.com/get/Downloads/MySQL-${lib.versions.majorMinor finalAttrs.version}/mysql-${finalAttrs.version}.tar.gz";
      hash = "sha256-4GOgkazZ7EC7BfLATfZPiZan5OJuiDu2UChJ1fa0pho=";
    })
    (fetchurl {
      url = "https://dev.mysql.com/get/Downloads/MySQL-Shell/mysql-shell-${finalAttrs.version}-src.tar.gz";
      hash = "sha256-UtZ7/Ip5h9CXKy3lkSt8/TXJgbPPUO73rMSIFPfX0Is=";
    })
  ];

  sourceRoot = "mysql-shell-${finalAttrs.version}-src";

  postUnpack = ''
    mv mysql-${finalAttrs.version} mysql
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

    cmake -DWITH_SYSTEM_LIBS=ON -DWITH_BOOST=system -DWITH_FIDO=system -DWITH_ROUTER=OFF -DWITH_UNIT_TESTS=OFF \
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
