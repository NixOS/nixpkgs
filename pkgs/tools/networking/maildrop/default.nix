{ fetchurl, stdenv, pkgconfig, pcre, perl }:

stdenv.mkDerivation rec {
  name = "maildrop-2.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/courier/maildrop/2.6.0/maildrop-2.6.0.tar.bz2";
    sha256 = "1a94p2b41iy334cwfwmzi19557dn5j61abh0cp2rfc9dkc8ibhdg";
  };

  buildInputs = [ pkgconfig pcre perl ];

  patches = [ ./maildrop.configure.hack.patch ]; # for building in chroot

  meta = with stdenv.lib; {
    homepage = http://www.courier-mta.org/maildrop/;
    description = "Mail filter/mail delivery agent that is used by the Courier Mail Server";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
