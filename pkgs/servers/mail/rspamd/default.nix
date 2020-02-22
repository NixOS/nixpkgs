{ stdenv, lib, fetchFromGitHub, cmake, perl
, glib, luajit, openssl, pcre, pkgconfig, sqlite, ragel, icu
, hyperscan, jemalloc, openblas, lua, libsodium
, withBlas ? true
, withHyperscan ? stdenv.isx86_64
, withLuaJIT ? stdenv.isx86_64
}:

assert withHyperscan -> stdenv.isx86_64;

stdenv.mkDerivation rec {
  pname = "rspamd";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "rspamd";
    repo = "rspamd";
    rev = version;
    sha256 = "1v4kbvj9r0hs8jaisq3fr0rg0qndpbhc5h8cbpfpprmkbw4nj6pf";
  };

  nativeBuildInputs = [ cmake pkgconfig perl ];
  buildInputs = [ glib openssl pcre sqlite ragel icu jemalloc libsodium ]
    ++ lib.optional withHyperscan hyperscan
    ++ lib.optional withBlas openblas
    ++ lib.optional withLuaJIT luajit ++ lib.optional (!withLuaJIT) lua;

  cmakeFlags = [
    "-DDEBIAN_BUILD=ON"
    "-DRUNDIR=/run/rspamd"
    "-DDBDIR=/var/lib/rspamd"
    "-DLOGDIR=/var/log/rspamd"
    "-DLOCAL_CONFDIR=/etc/rspamd"
    "-DENABLE_JEMALLOC=ON"
  ] ++ lib.optional withHyperscan "-DENABLE_HYPERSCAN=ON";

  meta = with stdenv.lib; {
    homepage = "https://rspamd.com";
    license = licenses.asl20;
    description = "Advanced spam filtering system";
    maintainers = with maintainers; [ avnik fpletz globin ];
    platforms = with platforms; linux;
  };
}
