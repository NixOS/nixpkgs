{ stdenv, fetchFromGitHub, cmake, perl
, file, glib, gmime, libevent, luajit, openssl, pcre, pkgconfig, sqlite }:

let libmagic = file;  # libmagic provided by file package ATM
in

stdenv.mkDerivation rec {
  name = "rspamd-${version}";
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = "vstakhov";
    repo = "rspamd";
    rev = version;
    sha256 = "0wr9lndg5fpsrjknm828zj0zy7zvdqrak9bdr6pga3bnq6xabbik";
  };

  nativeBuildInputs = [ cmake pkgconfig perl ];
  buildInputs = [ glib gmime libevent libmagic luajit openssl pcre sqlite];

  postPatch = ''
    substituteInPlace conf/common.conf --replace "\$CONFDIR/rspamd.conf.local" "/etc/rspamd/rspamd.conf.local"
    substituteInPlace conf/common.conf --replace "\$CONFDIR/rspamd.conf.local.override" "/etc/rspamd/rspamd.conf.local.override"
  '';

  cmakeFlags = ''
    -DDEBIAN_BUILD=ON
    -DRUNDIR=/var/run/rspamd
    -DDBDIR=/var/lib/rspamd
    -DLOGDIR=/var/log/rspamd
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/vstakhov/rspamd";
    license = licenses.asl20;
    description = "Advanced spam filtering system";
    maintainers = with maintainers; [ avnik fpletz ];
  };
}
