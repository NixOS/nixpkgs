{
  lib,
  stdenv,
  fetchurl,
  bison,
  cmake,
  pkg-config,
  boost,
  icu,
  libedit,
  libevent,
  lz4,
  ncurses,
  openssl,
  protobuf,
  re2,
  readline,
  zlib,
  zstd,
  libfido2,
  numactl,
  cctools,
  developer_cmds,
  libtirpc,
  rpcsvc-proto,
  curl,
  DarwinTools,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mysql";
  version = "8.0.44";

  src = fetchurl {
    url = "https://dev.mysql.com/get/Downloads/MySQL-${lib.versions.majorMinor finalAttrs.version}/mysql-${finalAttrs.version}.tar.gz";
    hash = "sha256-YJUi7R/vzlqziN7CXg0bzhMjgtom4rd7aPB0HApkE1Y=";
  };

  nativeBuildInputs = [
    bison
    cmake
    pkg-config
    protobuf
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ rpcsvc-proto ];

  patches = [
    ./no-force-outline-atomics.patch # Do not force compilers to turn on -moutline-atomics switch
  ];

  ## NOTE: MySQL upstream frequently twiddles the invocations of libtool. When updating, you might proactively grep for libtool references.
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace cmake/libutils.cmake --replace-fail /usr/bin/libtool ${cctools}/bin/libtool
    substituteInPlace cmake/os/Darwin.cmake --replace-fail /usr/bin/libtool ${cctools}/bin/libtool
    substituteInPlace cmake/package_name.cmake --replace-fail "COMMAND sw_vers" "COMMAND ${DarwinTools}/bin/sw_vers"
  '';

  buildInputs = [
    boost
    (curl.override { inherit openssl; })
    icu
    libedit
    libevent
    lz4
    ncurses
    openssl
    protobuf
    re2
    readline
    zlib
    zstd
    libfido2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    numactl
    libtirpc
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    developer_cmds
  ];

  strictDeps = true;

  outputs = [
    "out"
    "static"
  ];

  cmakeFlags = [
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
    client = finalAttrs.finalPackage;
    connector-c = finalAttrs.finalPackage;
    server = finalAttrs.finalPackage;
    mysqlVersion = lib.versions.majorMinor finalAttrs.version;
    tests = nixosTests.mysql.mysql80;
  };

  meta = with lib; {
    homepage = "https://www.mysql.com/";
    description = "World's most popular open source database";
    license = licenses.gpl2Only;
    maintainers = [ ];
    platforms = platforms.unix;
  };
})
