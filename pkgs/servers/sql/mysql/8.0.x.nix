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
  CoreServices,
  developer_cmds,
  libtirpc,
  rpcsvc-proto,
  curl,
  DarwinTools,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mysql";
  version = "8.0.40";

  src = fetchurl {
    url = "https://dev.mysql.com/get/Downloads/MySQL-${lib.versions.majorMinor finalAttrs.version}/mysql-${finalAttrs.version}.tar.gz";
    hash = "sha256-At/ZQ/lnQvf5zXiFWzJwjqTfVIycFK+Sc4F/O72dIrI=";
  };

  nativeBuildInputs = [
    bison
    cmake
    pkg-config
  ] ++ lib.optionals (!stdenv.isDarwin) [ rpcsvc-proto ];

  patches = [
    ./no-force-outline-atomics.patch # Do not force compilers to turn on -moutline-atomics switch
  ];

  ## NOTE: MySQL upstream frequently twiddles the invocations of libtool. When updating, you might proactively grep for libtool references.
  postPatch = ''
    substituteInPlace cmake/libutils.cmake --replace /usr/bin/libtool libtool
    substituteInPlace cmake/os/Darwin.cmake --replace /usr/bin/libtool libtool
  '';

  buildInputs =
    [
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
    ++ lib.optionals stdenv.isLinux [
      numactl
      libtirpc
    ]
    ++ lib.optionals stdenv.isDarwin [
      cctools
      CoreServices
      developer_cmds
      DarwinTools
    ];

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
    description = "The world's most popular open source database";
    license = licenses.gpl2;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.unix;
  };
})
