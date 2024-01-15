{ lib, stdenv, fetchurl, bison, cmake, pkg-config
, boost, icu, libedit, libevent, lz4, ncurses, openssl, perl, protobuf, re2, readline, zlib, zstd, libfido2
, numactl, cctools, CoreServices, developer_cmds, libtirpc, rpcsvc-proto, curl, DarwinTools, nixosTests
# Percona-specific deps
, coreutils, cyrus_sasl, gnumake, openldap
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "percona-server";
  version = "8.0.34-26";

  src = fetchurl {
    url = "https://www.percona.com/downloads/Percona-Server-8.0/Percona-Server-${finalAttrs.version}/source/tarball/percona-server-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-xOaXfnh/lg/TutanwGt+EmxG4UA8oTPdil2nvU3NZXQ=";
  };

  nativeBuildInputs = [ bison cmake pkg-config ]
    ++ lib.optionals (!stdenv.isDarwin) [ rpcsvc-proto ];

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
    numactl libtirpc
  ] ++ lib.optionals stdenv.isDarwin [
    cctools CoreServices developer_cmds DarwinTools
  ];

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
    tests = nixosTests.mysql.percona-server_8_0;
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
