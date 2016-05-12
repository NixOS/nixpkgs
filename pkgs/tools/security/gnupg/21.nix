{ fetchurl, stdenv, pkgconfig, libgcrypt, libassuan, libksba, libiconv, npth
, gettext, texinfo, pcsclite

# Each of the dependencies below are optional.
# Gnupg can be built without them at the cost of reduced functionality.
, pinentry ? null, x11Support ? true
, adns ? null, gnutls ? null, libusb ? null, openldap ? null
, readline ? null, zlib ? null, bzip2 ? null
}:

with stdenv.lib;

assert x11Support -> pinentry != null;

stdenv.mkDerivation rec {
  name = "gnupg-2.1.12";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${name}.tar.bz2";
    sha256 = "01n5py45x0r97l4dzmd803jpbpbcxr1591k3k4s8m9804jfr4d5c";
  };

  buildInputs = [
    pkgconfig libgcrypt libassuan libksba libiconv npth gettext texinfo
    readline libusb gnutls adns openldap zlib bzip2
  ];

  postPatch = stdenv.lib.optionalString stdenv.isLinux ''
    sed -i 's,"libpcsclite\.so[^"]*","${pcsclite}/lib/libpcsclite.so",g' scd/scdaemon.c
  ''; #" fix Emacs syntax highlighting :-(

  configureFlags = optional x11Support "--with-pinentry-pgm=${pinentry}/bin/pinentry";

  postConfigure = "substituteAllInPlace tools/gpgkey2ssh.c";

  meta = with stdenv.lib; {
    homepage = http://gnupg.org;
    description = "a complete and free implementation of the OpenPGP standard";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wkennington simons fpletz ];
    platforms = platforms.all;
  };
}
