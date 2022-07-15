{ lib
, stdenv
, pkg-config
, cmake
, fetchurl
, git
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
, v8
, python3
, cyrus_sasl
, openldap
, numactl
, cctools
, CoreServices
, developer_cmds
, DarwinTools
, makeWrapper
}:

let
  pythonDeps = with python3.pkgs; [ certifi paramiko pyyaml ];
  pythonPath = lib.makeSearchPath python3.sitePackages pythonDeps;
in
stdenv.mkDerivation rec{
  pname = "mysql-shell";
  version = "8.0.29";

  srcs = [
    (fetchurl {
      url = "https://cdn.mysql.com//Downloads/MySQL-Shell/mysql-shell-${version}-src.tar.gz";
      sha256 = "sha256-ijwyamQgMoUEcMNpIJjJxH/dRuRFpdcXGmQqpD+WrmA=";
    })
    (fetchurl {
      url = "https://dev.mysql.com/get/Downloads/MySQL-${lib.versions.majorMinor version}/mysql-${version}.tar.gz";
      sha256 = "sha256-USFw+m94ppTW8Y0ZfpmdJxbuaNxUHXZE3ZIqNmNAcmY=";
    })
  ];

  sourceRoot = "mysql-shell-${version}-src";

  postPatch = ''
    substituteInPlace ../mysql-${version}/cmake/libutils.cmake --replace /usr/bin/libtool libtool
    substituteInPlace ../mysql-${version}/cmake/os/Darwin.cmake --replace /usr/bin/libtool libtool

    substituteInPlace cmake/libutils.cmake --replace /usr/bin/libtool libtool
  '';

  nativeBuildInputs = [ pkg-config cmake git bison makeWrapper ] ++ lib.optionals (!stdenv.isDarwin) [ rpcsvc-proto ];

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
    v8
    python3
  ] ++ pythonDeps ++ lib.optionals stdenv.isLinux [
    numactl
    libtirpc
  ] ++ lib.optionals stdenv.isDarwin [ cctools CoreServices developer_cmds DarwinTools ];

  preConfigure = ''
    # Build MySQL
    cmake -DWITH_BOOST=system -DWITH_SYSTEM_LIBS=ON -DWITH_ROUTER=OFF -DWITH_UNIT_TESTS=OFF \
      -DFORCE_UNSUPPORTED_COMPILER=1 -S ../mysql-${version} -B ../mysql-${version}/build

    cmake --build ../mysql-${version}/build --parallel ''${NIX_BUILD_CORES:-1} --target mysqlclient mysqlxclient

    # Get libv8_monolith
    mkdir -p ../v8/lib && ln -s ${v8}/lib/libv8.a ../v8/lib/libv8_monolith.a
  '';

  cmakeFlags = [
    "-DMYSQL_SOURCE_DIR=../mysql-${version}"
    "-DMYSQL_BUILD_DIR=../mysql-${version}/build"
    "-DMYSQL_CONFIG_EXECUTABLE=../../mysql-${version}/build/scripts/mysql_config"
    "-DWITH_ZSTD=system"
    "-DWITH_LZ4=system"
    "-DWITH_ZLIB=system"
    "-DWITH_PROTOBUF=${protobuf}"
    "-DHAVE_V8=1"
    "-DV8_INCLUDE_DIR=${v8}/include"
    "-DV8_LIB_DIR=../v8/lib"
    "-DHAVE_PYTHON=1"
  ];

  CXXFLAGS = [ "-DV8_COMPRESS_POINTERS=1" "-DV8_31BIT_SMIS_ON_64BIT_ARCH=1" ];

  postFixup = ''
    wrapProgram $out/bin/mysqlsh --set PYTHONPATH "${pythonPath}"
  '';

  meta = with lib; {
    homepage = "https://dev.mysql.com/doc/mysql-shell/${lib.versions.majorMinor version}/en/";
    description = "A new command line scriptable shell for MySQL";
    license = licenses.gpl2;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "mysqlsh";
  };
}
