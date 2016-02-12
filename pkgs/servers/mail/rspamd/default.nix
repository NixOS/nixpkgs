{ stdenv, fetchFromGitHub, cmake, perl
, file, glib, gmime, libevent, luajit, openssl, pcre, pkgconfig, sqlite }:

let libmagic = file;  # libmagic provided by file package ATM
in

stdenv.mkDerivation rec {
  name = "rspamd-${version}";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "vstakhov";
    repo = "rspamd";
    rev = version;
    sha256 = "00d9c9b8w6j0ls1w08bfghn4635as779b45vhhlv1f5wfzhxz6a1";
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
    license = licenses.bsd2;
    description = "advanced spam filtering system";
    maintainers = with maintainers; [ avnik fpletz ];
  };
}
