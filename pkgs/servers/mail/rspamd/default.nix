{ stdenv, fetchFromGitHub, cmake, perl
, file, glib, gmime, libevent, luajit, openssl, pcre, pkgconfig, sqlite, ragel, icu, libfann }:

let libmagic = file;  # libmagic provided by file package ATM
in

stdenv.mkDerivation rec {
  name = "rspamd-${version}";
  version = "1.7.9";

  src = fetchFromGitHub {
    owner = "vstakhov";
    repo = "rspamd";
    rev = version;
    sha256 = "1qfkmcrcswh7k7bvr1ki1n83lnjmfd9h0281qgia0dlam7y81bcy";
  };

  nativeBuildInputs = [ cmake pkgconfig perl ];
  buildInputs = [ glib gmime libevent libmagic luajit openssl pcre sqlite ragel icu libfann ];

  cmakeFlags = [
    "-DDEBIAN_BUILD=ON"
    "-DRUNDIR=/var/run/rspamd"
    "-DDBDIR=/var/lib/rspamd"
    "-DLOGDIR=/var/log/rspamd"
    "-DLOCAL_CONFDIR=/etc/rspamd"
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/vstakhov/rspamd;
    license = licenses.asl20;
    description = "Advanced spam filtering system";
    maintainers = with maintainers; [ avnik fpletz ];
    platforms = with platforms; linux;
  };
}
