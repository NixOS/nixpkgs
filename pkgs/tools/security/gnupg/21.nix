{ fetchurl, stdenv, pkgconfig, libgcrypt, libassuan, libksba, libiconv, npth
, autoreconfHook, gettext, texinfo, pcsclite

# Each of the dependencies below are optional.
# Gnupg can be built without them at the cost of reduced functionality.
, pinentry ? null, x11Support ? true
, adns ? null, gnutls ? null, libusb ? null, openldap ? null
, readline ? null, zlib ? null, bzip2 ? null
}:

with stdenv.lib;

assert x11Support -> pinentry != null;

stdenv.mkDerivation rec {
  name = "gnupg-2.1.7";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${name}.tar.bz2";
    sha256 = "0vl4wzraln0h4db0kfza4l5by5pgfijqplji5n4riv3zsiv3g2n1";
  };

  postPatch = stdenv.lib.optionalString stdenv.isLinux ''
    sed -i 's,"libpcsclite\.so[^"]*","${pcsclite}/lib/libpcsclite.so",g' scd/scdaemon.c
  '';

  buildInputs = [
    pkgconfig libgcrypt libassuan libksba libiconv npth
    autoreconfHook gettext texinfo
    readline libusb gnutls adns openldap zlib bzip2
  ];

  configureFlags = optional x11Support "--with-pinentry-pgm=${pinentry}/bin/pinentry";

  meta = with stdenv.lib; {
    homepage = http://gnupg.org;
    description = "a complete and free implementation of the OpenPGP standard";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wkennington ];
    platforms = platforms.all;
  };
}
