{ stdenv, lib, fetchFromGitHub, cmake, perl
, glib, luajit, openssl, pcre, pkgconfig, sqlite, ragel, icu
, hyperscan, jemalloc, blas, lapack, lua, libsodium
, withBlas ? true
, withHyperscan ? stdenv.isx86_64
, withLuaJIT ? stdenv.isx86_64
, nixosTests
}:

assert withHyperscan -> stdenv.isx86_64;

stdenv.mkDerivation rec {
  pname = "rspamd";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "rspamd";
    repo = "rspamd";
    rev = version;
    sha256 = "0vwa7k2s2bkfb8w78z5izkd6ywjbzqysb0grls898y549hm8ii70";
  };

  nativeBuildInputs = [ cmake pkgconfig perl ];
  buildInputs = [ glib openssl pcre sqlite ragel icu jemalloc libsodium ]
    ++ lib.optional withHyperscan hyperscan
    ++ lib.optionals withBlas [ blas lapack ]
    ++ lib.optional withLuaJIT luajit ++ lib.optional (!withLuaJIT) lua;

  cmakeFlags = [
    "-DDEBIAN_BUILD=ON"
    "-DRUNDIR=/run/rspamd"
    "-DDBDIR=/var/lib/rspamd"
    "-DLOGDIR=/var/log/rspamd"
    "-DLOCAL_CONFDIR=/etc/rspamd"
    "-DENABLE_JEMALLOC=ON"
  ] ++ lib.optional withHyperscan "-DENABLE_HYPERSCAN=ON";

  passthru.tests.rspamd = nixosTests.rspamd;

  meta = with stdenv.lib; {
    homepage = "https://rspamd.com";
    license = licenses.asl20;
    description = "Advanced spam filtering system";
    maintainers = with maintainers; [ avnik fpletz globin ];
    platforms = with platforms; linux;
  };
}
