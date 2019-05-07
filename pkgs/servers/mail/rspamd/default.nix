{ stdenv, lib, fetchFromGitHub, cmake, perl
, file, glib, libevent, luajit, openssl, pcre, pkgconfig, sqlite, ragel, icu
, hyperscan, libfann, gd, jemalloc, openblas
, withFann ? true
, withGd ? false
, withBlas ? true
, withHyperscan ? stdenv.isx86_64
}:

assert withHyperscan -> stdenv.isx86_64;

let libmagic = file;  # libmagic provided by file package ATM
in

stdenv.mkDerivation rec {
  name = "rspamd-${version}";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "rspamd";
    repo = "rspamd";
    rev = version;
    sha256 = "1ygyqlm8x8d54g829pmd3x3qp4rsxj8nq25kgzrpkw73spi7bkkq";
  };

  nativeBuildInputs = [ cmake pkgconfig perl ];
  buildInputs = [ glib libevent libmagic luajit openssl pcre sqlite ragel icu jemalloc ]
    ++ lib.optional withFann libfann
    ++ lib.optional withGd gd
    ++ lib.optional withHyperscan hyperscan
    ++ lib.optional withBlas openblas;

  cmakeFlags = [
    "-DDEBIAN_BUILD=ON"
    "-DRUNDIR=/run/rspamd"
    "-DDBDIR=/var/lib/rspamd"
    "-DLOGDIR=/var/log/rspamd"
    "-DLOCAL_CONFDIR=/etc/rspamd"
    "-DENABLE_JEMALLOC=ON"
  ] ++ lib.optional withFann "-DENABLE_FANN=ON"
    ++ lib.optional withHyperscan "-DENABLE_HYPERSCAN=ON"
    ++ lib.optional withGd "-DENABLE_GD=ON";

  meta = with stdenv.lib; {
    homepage = https://rspamd.com;
    license = licenses.asl20;
    description = "Advanced spam filtering system";
    maintainers = with maintainers; [ avnik fpletz ];
    platforms = with platforms; linux;
  };
}
