{ lib, stdenv, fetchurl, bison, cmake, pkg-config
, boost, icu, libedit, libevent, lz4, ncurses, openssl, perl, protobuf, re2, readline, zlib, zstd, libfido2
, numactl, cctools, CoreServices, developer_cmds, libtirpc, rpcsvc-proto, curl, DarwinTools, nixosTests
, coreutils, procps, gnused, gnugrep, hostname, makeWrapper
, systemd
# Percona-specific deps
, cyrus_sasl, gnumake, openldap
# optional: different malloc implementations
, withJemalloc ? false, withTcmalloc ? false, jemalloc, gperftools
}:

assert !(withJemalloc && withTcmalloc);


stdenv.mkDerivation (finalAttrs: {
  pname = "percona-server_innovation";
  version = "8.3.0-1";

  src = fetchurl {
    url = "https://downloads.percona.com/downloads/percona-distribution-mysql-ps/percona-distribution-mysql-ps-${builtins.head (lib.strings.split "-" finalAttrs.version)}/source/tarball/percona-server-${finalAttrs.version}.tar.gz";
    hash = "sha256-GeuifzqCkStmb4qYa8147XBHvMogYwfsn0FyHdO4WEg";
  };

  nativeBuildInputs = [
    bison cmake pkg-config makeWrapper
    # required for scripts/CMakeLists.txt
    coreutils gnugrep procps
  ] ++ lib.optionals (!stdenv.isDarwin) [ rpcsvc-proto ];

  patches = [
    ./no-force-outline-atomics.patch # Do not force compilers to turn on -moutline-atomics switch
  ];

  ## NOTE: MySQL upstream frequently twiddles the invocations of libtool. When updating, you might proactively grep for libtool references.
  postPatch = ''
    substituteInPlace cmake/libutils.cmake --replace /usr/bin/libtool libtool
    substituteInPlace cmake/os/Darwin.cmake --replace /usr/bin/libtool libtool
    # The rocksdb setup script is called with `env -i` and cannot find anything in PATH.
    patchShebangs storage/rocksdb/get_rocksdb_files.sh
    substituteInPlace storage/rocksdb/get_rocksdb_files.sh --replace mktemp ${coreutils}/bin/mktemp
    substituteInPlace storage/rocksdb/get_rocksdb_files.sh --replace "rm $MKFILE" "${coreutils}/bin/rm $MKFILE"
    substituteInPlace storage/rocksdb/get_rocksdb_files.sh --replace "make --" "${gnumake}/bin/make --"
  '';

  buildInputs = [
    boost (curl.override { inherit openssl; }) icu libedit libevent lz4 ncurses openssl protobuf re2 readline zlib
    zstd libfido2 openldap perl cyrus_sasl
  ] ++ lib.optionals stdenv.isLinux [
    numactl libtirpc systemd
  ] ++ lib.optionals stdenv.isDarwin [
    cctools CoreServices developer_cmds DarwinTools
  ]
  ++ lib.optional (stdenv.isLinux && withJemalloc) jemalloc
  ++ lib.optional (stdenv.isLinux && withTcmalloc) gperftools;

  outputs = [ "out" "static" ];

  cmakeFlags = [
    # Percona-specific flags.
    "-DPORTABLE=1"
    "-DWITH_LDAP=system"
    "-DROCKSDB_DISABLE_AVX2=1"
    "-DROCKSDB_DISABLE_MARCH_NATIVE=1"

    # Flags taken from mysql package.
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


  ] ++ lib.optionals stdenv.isLinux [
    "-DWITH_SYSTEMD=1"
    "-DWITH_SYSTEMD_DEBUG=1"
  ]
  ++ lib.optional (stdenv.isLinux && withJemalloc) "-DWITH_JEMALLOC=1"
  ++ lib.optional (stdenv.isLinux && withTcmalloc) "-DWITH_TCMALLOC=1";

  postInstall = ''
    moveToOutput "lib/*.a" $static
    so=${stdenv.hostPlatform.extensions.sharedLibrary}
    ln -s libmysqlclient$so $out/lib/libmysqlclient_r$so

    wrapProgram $out/bin/mysqld_safe --prefix PATH : ${lib.makeBinPath [ coreutils procps gnugrep gnused hostname ]}
    wrapProgram $out/bin/mysql_config --prefix PATH : ${lib.makeBinPath [ coreutils gnused ]}
    wrapProgram $out/bin/ps_mysqld_helper --prefix PATH : ${lib.makeBinPath [ coreutils gnugrep ]}
    wrapProgram $out/bin/ps-admin --prefix PATH : ${lib.makeBinPath [ coreutils gnugrep ]}
  '' + lib.optionalString stdenv.isDarwin ''
    wrapProgram $out/bin/mysqld_multi --prefix PATH : ${lib.makeBinPath [ coreutils gnugrep ]}
  '';

  passthru = {
    client = finalAttrs.finalPackage;
    connector-c = finalAttrs.finalPackage;
    server = finalAttrs.finalPackage;
    mysqlVersion = lib.versions.majorMinor finalAttrs.version;
    tests = nixosTests.mysql.percona-server_innovation;
  };


  meta = with lib; {
    homepage = "https://www.percona.com/software/mysql-database/percona-server";
    description = ''
      A free, fully compatible, enhanced, open source drop-in replacement for
      MySQL® that provides superior performance, scalability and instrumentation.
    '';
    license = licenses.gpl2;
    maintainers = teams.flyingcircus.members;
    platforms = platforms.unix;
  };
})
