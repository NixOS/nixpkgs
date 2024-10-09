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

  mysqlShellVersion = "9.0.1";
  mysqlServerVersion = "9.0.1";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mysql-shell-innovation";
  version = mysqlShellVersion;

  srcs = [
    (fetchurl {
      url = "https://dev.mysql.com/get/Downloads/MySQL-${lib.versions.majorMinor mysqlServerVersion}/mysql-${mysqlServerVersion}.tar.gz";
      hash = "sha256-GPpl8epq6nHkGP4FSFUtmijeaOK4vDupU2WZ60WaZgY=";
    })
    (fetchurl {
      url = "https://dev.mysql.com/get/Downloads/MySQL-Shell/mysql-shell-${finalAttrs.version}-src.tar.gz";
      hash = "sha256-F77W+cY1X29p4DIA1JOxJ6jAKT+8Qz4LkHh91MASlE0=";
    })
  ];

  sourceRoot = "mysql-shell-${finalAttrs.version}-src";

  postUnpack = ''
    mv mysql-${mysqlServerVersion} mysql
  '';

  patches = [
    # No openssl bundling on macOS. It's not working.
    # See https://github.com/mysql/mysql-shell/blob/5b84e0be59fc0e027ef3f4920df15f7be97624c1/cmake/ssl.cmake#L53
    ./no-openssl-bundling.patch
  ];

  postPatch = ''
    substituteInPlace ../mysql/cmake/libutils.cmake --replace-fail /usr/bin/libtool libtool
    substituteInPlace ../mysql/cmake/os/Darwin.cmake --replace-fail /usr/bin/libtool libtool

    substituteInPlace cmake/libutils.cmake --replace-fail /usr/bin/libtool libtool
  '';

  nativeBuildInputs = [ pkg-config cmake git bison makeWrapper ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ rpcsvc-proto ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ cctools DarwinTools ];

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
  ++ lib.optionals stdenv.hostPlatform.isLinux [ libtirpc ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices ];

  preConfigure = ''
    # Build MySQL
    echo "Building mysqlclient mysqlxclient"

    cmake -DWITH_SYSTEM_LIBS=ON -DWITH_FIDO=system -DWITH_ROUTER=OFF -DWITH_UNIT_TESTS=OFF \
      -DFORCE_UNSUPPORTED_COMPILER=1 -S ../mysql -B ../mysql/build

    cmake --build ../mysql/build --parallel ''${NIX_BUILD_CORES:-1} --target mysqlclient mysqlxclient

    cmakeFlagsArray+=(
      "-DMYSQL_SOURCE_DIR=''${NIX_BUILD_TOP}/mysql"
      "-DMYSQL_BUILD_DIR=''${NIX_BUILD_TOP}/mysql/build"
      "-DMYSQL_CONFIG_EXECUTABLE=''${NIX_BUILD_TOP}/mysql/build/scripts/mysql_config"
      "-DWITH_ZSTD=system"
      "-DWITH_LZ4=system"
      "-DWITH_ZLIB=system"
      "-DWITH_PROTOBUF=system"
      "-DHAVE_PYTHON=1"
    )
  '';

  postFixup = ''
    wrapProgram $out/bin/mysqlsh --set PYTHONPATH "${lib.makeSearchPath python3.sitePackages pythonDeps}"
  '';

  meta = with lib; {
    homepage = "https://dev.mysql.com/doc/mysql-shell/${lib.versions.majorMinor finalAttrs.version}/en/";
    description = "New command line scriptable shell for MySQL";
    license = licenses.gpl2;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "mysqlsh";
  };
})
