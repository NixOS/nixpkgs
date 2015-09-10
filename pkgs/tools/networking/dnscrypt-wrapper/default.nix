{ stdenv, fetchurl, libsodium, libevent, pkgconfig, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "dnscrypt-wrapper-${version}";
  version = "0.2";

  src = fetchurl {
    url = "https://github.com/Cofyc/dnscrypt-wrapper/releases/download/v0.2/dnscrypt-wrapper-v0.2.tar.bz2";
    sha256 = "0kh52dc0v9lxwi39y88z0ab6bwa5bcw8b24psnz72fv555irsvyj";
  };

  buildInputs = [ pkgconfig autoreconfHook libsodium libevent ];

  meta = {
    description = "A tool for adding dnscrypt support to any name resolver";
    homepage = http://dnscrypt.org/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
    platforms = stdenv.lib.platforms.linux;
  };
}
