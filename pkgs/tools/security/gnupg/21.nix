{ fetchurl, stdenv, pkgconfig, libgcrypt, libassuan, libksba, npth
, readline ? null, libusb ? null, gnutls ? null, adns ? null, openldap ? null
, zlib ? null, bzip2 ? null, pinentry ? null, autoreconfHook, gettext
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "gnupg-2.1.1";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${name}.tar.bz2";
    sha256 = "12q5shx6ldqad3rky154nv8f2cy57sxy9idivz93ggqm1bsw7a0a";
  };

  patches = [ ./socket-activate.patch ];

  buildInputs = [
    pkgconfig libgcrypt libassuan libksba npth
    readline libusb gnutls adns openldap zlib bzip2
    autoreconfHook gettext
  ];

  configureFlags =
    optional (pinentry != null) "--with-pinentry-pgm=${pinentry}/bin/pinentry";

  meta = with stdenv.lib; {
    homepage = http://gnupg.org;
    description = "a complete and free implementation of the OpenPGP standard";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
