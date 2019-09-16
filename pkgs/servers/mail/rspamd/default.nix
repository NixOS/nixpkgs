{ stdenv, lib, fetchFromGitHub, cmake, perl
, file, glib, libevent, luajit, openssl, pcre, pkgconfig, sqlite, ragel, icu
, hyperscan, libfann, gd, jemalloc, openblas, lua
, withFann ? true
, withGd ? false
, withBlas ? true
, withHyperscan ? stdenv.isx86_64
, withLuaJIT ? stdenv.isx86_64
}:

assert withHyperscan -> stdenv.isx86_64;

let libmagic = file;  # libmagic provided by file package ATM
in

stdenv.mkDerivation rec {
  pname = "rspamd";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "rspamd";
    repo = "rspamd";
    rev = version;
    sha256 = "0b8n7xazmzjb6jf8sk0jg0x861nf1ayzxsvjaymw1qjgpn371r51";
  };

  nativeBuildInputs = [ cmake pkgconfig perl ];
  buildInputs = [ glib libevent libmagic openssl pcre sqlite ragel icu jemalloc ]
    ++ lib.optional withFann libfann
    ++ lib.optional withGd gd
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
  ] ++ lib.optional withFann "-DENABLE_FANN=ON"
    ++ lib.optional withHyperscan "-DENABLE_HYPERSCAN=ON"
    ++ lib.optional withGd "-DENABLE_GD=ON"
    ++ lib.optional (!withLuaJIT) "-DENABLE_TORCH=OFF";

  meta = with stdenv.lib; {
    homepage = "https://rspamd.com";
    license = licenses.asl20;
    description = "Advanced spam filtering system";
    maintainers = with maintainers; [ avnik fpletz globin ];
    platforms = with platforms; linux;
  };
}
