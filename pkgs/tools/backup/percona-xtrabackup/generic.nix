{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  boost,
  cmake,
  makeWrapper,
  pkg-config,
  curl,
  cyrus_sasl,
  libaio,
  libedit,
  libev,
  libevent,
  libgcrypt,
  libgpg-error,
  libtirpc,
  lz4,
  icu,
  ncurses,
  numactl,
  openssl,
  procps,
  protobuf,
  valgrind,
  xxd,
  zlib,
  zstd,
  perlPackages,
  version,
  hash,
  fetchSubmodules ? false,
  extraPatches ? [ ],
  extraPostInstall ? "",
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "percona-xtrabackup";
  inherit version;

  src = fetchFromGitHub {
    owner = "percona";
    repo = "percona-xtrabackup";
    rev = "percona-xtrabackup-${finalAttrs.version}";
    inherit hash fetchSubmodules;
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    bison
    boost
    cmake
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    (curl.override { inherit openssl; })
    cyrus_sasl
    libaio
    libedit
    libevent
    libev
    libgcrypt
    libgpg-error
    lz4
    icu
    ncurses
    numactl
    openssl
    procps
    protobuf
    valgrind
    xxd
    zlib
    zstd
  ]
  ++ (
    with perlPackages;
    [
      perl
      DBI
      DBDmysql
    ]
    ++ lib.optionals (lib.versionAtLeast version "9.7") [
      libtirpc
    ]
  );

  patches = extraPatches;

  cmakeFlags = [
    "-DMYSQL_UNIX_ADDR=/run/mysqld/mysqld.sock"
    "-DBUILD_CONFIG=xtrabackup_release"
    "-DINSTALL_MYSQLTESTDIR=OFF"
    "-DWITH_BOOST=system"
    "-DWITH_CURL=system"
    "-DWITH_EDITLINE=system"
    "-DWITH_ICU=system"
    "-DWITH_LIBEVENT=system"
    "-DWITH_LZ4=system"
    "-DWITH_PROTOBUF=system"
    "-DWITH_SASL=system"
    "-DWITH_SSL=system"
    "-DWITH_ZLIB=system"
    "-DWITH_ZSTD=system"
    "-DWITH_VALGRIND=ON"
    "-DWITH_MAN_PAGES=OFF"
  ]
  ++ lib.optionals (lib.versionAtLeast version "9.7") [
    "-DWITH_TIRPC=system"
  ];

  postInstall = ''
    wrapProgram "$out"/bin/xtrabackup --prefix PERL5LIB : $PERL5LIB
    rm -r "$out"/lib/plugin/debug
  ''
  + extraPostInstall;

  passthru.mysqlVersion = lib.versions.majorMinor finalAttrs.version;

  meta = {
    description = "Non-blocking backup tool for MySQL";
    homepage = "http://www.percona.com/software/percona-xtrabackup";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [
      lib.maintainers.izorkin
      lib.maintainers.leona
      lib.maintainers.osnyx
    ];
  };
})
