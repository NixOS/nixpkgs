{ fetchurl, stdenv, pkgconfig, libgcrypt, libassuan, libksba, npth
, readline ? null, libusb ? null, gnutls ? null, adns ? null, openldap ? null
, zlib ? null, bzip2 ? null, pinentry ? null, autoreconfHook, gettext, texinfo
, pcsclite
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "gnupg-2.1.2";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${name}.tar.bz2";
    sha256 = "14k7c5spai3yppz6izf1ggbnffskl54ln87v1wgy9pwism1mlks0";
  };

  patches = [ ./socket-activate-2.1.1.patch ];

  postPatch = ''
    sed -i 's,"libpcsclite\.so[^"]*","${pcsclite}/lib/libpcsclite.so",g' scd/scdaemon.c
  '';

  buildInputs = [
    pkgconfig libgcrypt libassuan libksba npth
    readline libusb gnutls adns openldap zlib bzip2
    autoreconfHook gettext texinfo
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
