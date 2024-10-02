{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  doctest,
  fmt_11,
  perl,
  glib,
  luajit,
  openssl,
  pcre,
  pkg-config,
  sqlite,
  ragel,
  icu,
  hyperscan,
  jemalloc,
  blas,
  lapack,
  lua,
  libsodium,
  xxHash,
  zstd,
  libarchive,
  withBlas ? true,
  withHyperscan ? stdenv.hostPlatform.isx86_64,
  withLuaJIT ? stdenv.hostPlatform.isx86_64,
  nixosTests,
}:

assert withHyperscan -> stdenv.hostPlatform.isx86_64;

stdenv.mkDerivation rec {
  pname = "rspamd";
  version = "3.9.1";

  src = fetchFromGitHub {
    owner = "rspamd";
    repo = "rspamd";
    rev = version;
    hash = "sha256-qT94DqX5Dt9pLgqed/j+dtiykwRFY3Fsbvcub7IzAZE=";
  };

  hardeningEnable = [ "pie" ];

  nativeBuildInputs = [
    cmake
    pkg-config
    perl
  ];
  buildInputs =
    [
      doctest
      fmt_11
      glib
      openssl
      pcre
      sqlite
      ragel
      icu
      jemalloc
      libsodium
      xxHash
      zstd
      libarchive
    ]
    ++ lib.optional withHyperscan hyperscan
    ++ lib.optionals withBlas [
      blas
      lapack
    ]
    ++ lib.optional withLuaJIT luajit
    ++ lib.optional (!withLuaJIT) lua;

  cmakeFlags =
    [
      # pcre2 jit seems to cause crashes: https://github.com/NixOS/nixpkgs/pull/181908
      "-DENABLE_PCRE2=OFF"
      "-DDEBIAN_BUILD=ON"
      "-DRUNDIR=/run/rspamd"
      "-DDBDIR=/var/lib/rspamd"
      "-DLOGDIR=/var/log/rspamd"
      "-DLOCAL_CONFDIR=/etc/rspamd"
      "-DENABLE_JEMALLOC=ON"
      "-DSYSTEM_DOCTEST=ON"
      "-DSYSTEM_FMT=ON"
      "-DSYSTEM_XXHASH=ON"
      "-DSYSTEM_ZSTD=ON"
    ]
    ++ lib.optional withHyperscan "-DENABLE_HYPERSCAN=ON"
    ++ lib.optional (!withLuaJIT) "-DENABLE_LUAJIT=OFF";

  passthru.tests.rspamd = nixosTests.rspamd;

  meta = with lib; {
    homepage = "https://rspamd.com";
    license = licenses.asl20;
    description = "Advanced spam filtering system";
    maintainers = with maintainers; [
      avnik
      fpletz
      globin
      lewo
    ];
    platforms = with platforms; linux;
  };
}
