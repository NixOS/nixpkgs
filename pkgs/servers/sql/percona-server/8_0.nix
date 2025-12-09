{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  gitUpdater,
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
  perl,
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
  coreutils,
  procps,
  gnused,
  gnugrep,
  hostname,
  makeWrapper,
  # Percona-specific deps
  cyrus_sasl,
  gnumake,
  openldap,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "percona-server";
  version = "8.0.44-35";

  src = fetchurl {
    url = "https://downloads.percona.com/downloads/Percona-Server-8.0/Percona-Server-${finalAttrs.version}/source/tarball/percona-server-${finalAttrs.version}.tar.gz";
    hash = "sha256-4eiNKzXzc5TAhsdIKQvyhQknsOiVSSkbZXDFY+qInYE=";
  };

  nativeBuildInputs = [
    bison
    cmake
    pkg-config
    makeWrapper
    # required for scripts/CMakeLists.txt
    coreutils
    gnugrep
    procps
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ rpcsvc-proto ];

  patches = [
    # fixes using -DWITH_SSL=system with CMAKE_PREFIX_PATH on darwin
    # https://github.com/Homebrew/homebrew-core/pull/204799
    (fetchpatch {
      name = "fix-system-ssl-darwin.patch";
      url = "https://github.com/percona/percona-server/pull/5537/commits/a693e5d67abf6f27f5284c86361604babec529c6.patch";
      hash = "sha256-fFBy3AYTMLvHvbsh0g0UvuPkmVMKZzxPsxeBKbsN8Ho=";
    })
    ./no-force-outline-atomics.patch # Do not force compilers to turn on -moutline-atomics switch
    ./coredumper-explicitly-import-unistd.patch # fix build on aarch64-linux
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
    openldap
    perl
    cyrus_sasl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    numactl
    libtirpc
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
    developer_cmds
    DarwinTools
  ];

  outputs = [
    "out"
    "static"
  ];

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
    ln -s libperconaserverclient$so $out/lib/libmysqlclient_r$so

    wrapProgram $out/bin/mysqld_safe --prefix PATH : ${
      lib.makeBinPath [
        coreutils
        procps
        gnugrep
        gnused
        hostname
      ]
    }
    wrapProgram $out/bin/mysql_config --prefix PATH : ${
      lib.makeBinPath [
        coreutils
        gnused
      ]
    }
    wrapProgram $out/bin/ps_mysqld_helper --prefix PATH : ${
      lib.makeBinPath [
        coreutils
        gnugrep
      ]
    }
    wrapProgram $out/bin/ps-admin --prefix PATH : ${
      lib.makeBinPath [
        coreutils
        gnugrep
      ]
    }
    wrapProgram $out/bin/mysqld_multi --prefix PATH : ${
      lib.makeBinPath [
        coreutils
        gnugrep
      ]
    }
  '';

  passthru = {
    client = finalAttrs.finalPackage;
    connector-c = finalAttrs.finalPackage;
    server = finalAttrs.finalPackage;
    mysqlVersion = lib.versions.majorMinor finalAttrs.version;
    tests.percona-server =
      nixosTests.mysql."percona-server_${lib.versions.major finalAttrs.version}_${lib.versions.minor finalAttrs.version}";
    updateScript = gitUpdater {
      url = "https://github.com/percona/percona-server";
      rev-prefix = "Percona-Server-";
      allowedVersions = "${lib.versions.major finalAttrs.version}\\.${lib.versions.minor finalAttrs.version}\\..+";
    };
  };

  meta = with lib; {
    homepage = "https://www.percona.com/software/mysql-database/percona-server";
    description = ''
      A free, fully compatible, enhanced, open source drop-in replacement for
      MySQL® that provides superior performance, scalability and instrumentation.
      Long-term support release.
    '';
    license = licenses.gpl2Only;
    teams = [ teams.flyingcircus ];
    platforms = platforms.unix;
  };
})
