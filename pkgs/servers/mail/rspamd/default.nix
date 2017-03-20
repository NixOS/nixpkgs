{ stdenv, fetchFromGitHub, cmake, perl, pkgconfig
, file, glib, icu, libevent, luajit, openssl, pcre, sqlite, ragel
, libfann, gd }:

let libmagic = file;  # libmagic provided by file package ATM
in

stdenv.mkDerivation rec {
  name = "rspamd-${version}";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "vstakhov";
    repo = "rspamd";
    rev = version;
    sha256 = "08qxx9lj27wij8ss6kvw7fkv6vgrnsf9431s62ai4vpxb7vccraa";
  };

  nativeBuildInputs = [ cmake pkgconfig perl ];
  buildInputs = [
    glib icu libevent libmagic luajit openssl pcre sqlite ragel libfann gd
  ];

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
    platforms = with platforms; linux;
  };
}
