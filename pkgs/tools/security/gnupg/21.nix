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
  name = "gnupg-2.1.10";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${name}.tar.bz2";
    sha256 = "1ybcsazjm21i2ys1wh49cz4azmqz7ghx5rb6hm4gm93i2zc5igck";
  };

  postPatch = stdenv.lib.optionalString stdenv.isLinux ''
    sed -i 's,"libpcsclite\.so[^"]*","${pcsclite}/lib/libpcsclite.so",g' scd/scdaemon.c
  ''; #" fix Emacs syntax highlighting :-(

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
