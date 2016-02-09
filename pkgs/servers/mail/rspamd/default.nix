{ stdenv, fetchFromGitHub, cmake, perl
 ,file , glib, gmime, libevent, luajit, openssl, pcre, pkgconfig, sqlite }:

let libmagic = file;  # libmagic provided buy file package ATM
in

stdenv.mkDerivation rec {
  name = "rspamd-${version}";
  version = "git-2016-01-16";
  src = fetchFromGitHub {
    owner = "vstakhov";
    repo = "rspamd";
    rev = "04bfc92c1357c0f908ce9371ab303f8bf57657df";
    sha256 = "1zip1msjjy5q7jcsn4l0yyg92c3wdsf1v5jv1acglrih8dbfl7zj";
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
    maintainer = maintainers.avnik;
  };
}
