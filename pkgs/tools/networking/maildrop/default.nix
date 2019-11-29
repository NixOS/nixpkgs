{ fetchurl, stdenv, pkgconfig, pcre, perl }:

stdenv.mkDerivation {
  name = "maildrop-2.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/courier/maildrop/2.6.0/maildrop-2.6.0.tar.bz2";
    sha256 = "1a94p2b41iy334cwfwmzi19557dn5j61abh0cp2rfc9dkc8ibhdg";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pcre perl ];

  patches = [ ./maildrop.configure.hack.patch ]; # for building in chroot

  doCheck = false; # fails with "setlocale: LC_ALL: cannot change locale (en_US.UTF-8)"

  meta = with stdenv.lib; {
    homepage = http://www.courier-mta.org/maildrop/;
    description = "Mail filter/mail delivery agent that is used by the Courier Mail Server";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
