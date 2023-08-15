{ stdenv
, lib
, fetchFromGitHub
, fetchpatch2
, cmake
, perl
, glib
, luajit
, openssl
, pcre
, pkg-config
, sqlite
, ragel
, icu
, hyperscan
, jemalloc
, blas
, lapack
, lua
, libsodium
, withBlas ? true
, withHyperscan ? stdenv.isx86_64
, withLuaJIT ? stdenv.isx86_64
, nixosTests
}:

assert withHyperscan -> stdenv.isx86_64;

stdenv.mkDerivation rec {
  pname = "rspamd";
  version = "3.6";

  src = fetchFromGitHub {
    owner = "rspamd";
    repo = "rspamd";
    rev = version;
    hash = "sha256-GuWuJK73RE+cS8451m+bcmpZNQEzmZtexm19xgdDQeU=";
  };

  patches = [
    # Fix leak in `gzip` function
    # https://github.com/rspamd/rspamd/issues/4564
    (fetchpatch2 {
      url = "https://github.com/rspamd/rspamd/commit/ffbab4fbf218514845b8e5209aec044621b1f460.patch";
      hash = "sha256-ltkC/mZcYmGoSFILaTTRB/UWSn36flEbuJP4Buys05Y=";
    })
  ];

  hardeningEnable = [ "pie" ];

  nativeBuildInputs = [ cmake pkg-config perl ];
  buildInputs = [ glib openssl pcre sqlite ragel icu jemalloc libsodium ]
    ++ lib.optional withHyperscan hyperscan
    ++ lib.optionals withBlas [ blas lapack ]
    ++ lib.optional withLuaJIT luajit ++ lib.optional (!withLuaJIT) lua;

  cmakeFlags = [
    # pcre2 jit seems to cause crashes: https://github.com/NixOS/nixpkgs/pull/181908
    "-DENABLE_PCRE2=OFF"
    "-DDEBIAN_BUILD=ON"
    "-DRUNDIR=/run/rspamd"
    "-DDBDIR=/var/lib/rspamd"
    "-DLOGDIR=/var/log/rspamd"
    "-DLOCAL_CONFDIR=/etc/rspamd"
    "-DENABLE_JEMALLOC=ON"
  ] ++ lib.optional withHyperscan "-DENABLE_HYPERSCAN=ON"
  ++ lib.optional (!withLuaJIT) "-DENABLE_LUAJIT=OFF";

  passthru.tests.rspamd = nixosTests.rspamd;

  meta = with lib; {
    homepage = "https://rspamd.com";
    license = licenses.asl20;
    description = "Advanced spam filtering system";
    maintainers = with maintainers; [ avnik fpletz globin lewo ];
    platforms = with platforms; linux;
  };
}
