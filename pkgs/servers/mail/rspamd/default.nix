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
  version = "3.7.4";

  src = fetchFromGitHub {
    owner = "rspamd";
    repo = "rspamd";
    rev = version;
    hash = "sha256-Bg0EFgxk/sRwE8/7a/m8J4cTgooR4fobQil8pbWtkoc=";
  };

  patches = [
    (fetchpatch2 {
      name = "no-hyperscan-fix.patch";
      url = "https://github.com/rspamd/rspamd/commit/d907a95ac2e2cad6f7f65c4323f031f7931ae18b.patch";
      hash = "sha256-bMmgiJSy0QrzvBAComzT0aM8UF8OKeV0VgMr0wwrM6w=";
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
