{ fetchurl, stdenv, pkgconfig, libgcrypt, libassuan, libksba, libiconv, npth
, gettext, texinfo, pcsclite

# Each of the dependencies below are optional.
# Gnupg can be built without them at the cost of reduced functionality.
, pinentry ? null, guiSupport ? true
, adns ? null, gnutls ? null, libusb ? null, openldap ? null
, readline ? null, zlib ? null, bzip2 ? null
}:

with stdenv.lib;

assert guiSupport -> pinentry != null;

stdenv.mkDerivation rec {
  name = "gnupg-${version}";

  version = "2.1.15";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${name}.tar.bz2";
    sha256 = "1pgz02gd84ab94w4xdg67p9z8kvkyr9d523bvcxxd2hviwh1m362";
  };

  buildInputs = [
    pkgconfig libgcrypt libassuan libksba libiconv npth gettext texinfo
    readline libusb gnutls adns openldap zlib bzip2
  ];

  patches = [ ./fix-libusb-include-path.patch ];
  postPatch = stdenv.lib.optionalString stdenv.isLinux ''
    sed -i 's,"libpcsclite\.so[^"]*","${pcsclite}/lib/libpcsclite.so",g' scd/scdaemon.c
  ''; #" fix Emacs syntax highlighting :-(

  pinentryBinaryPath = pinentry.binaryPath or "bin/pinentry";
  configureFlags = optional guiSupport "--with-pinentry-pgm=${pinentry}/${pinentryBinaryPath}";

  meta = with stdenv.lib; {
    homepage = http://gnupg.org;
    description = "A complete and free implementation of the OpenPGP standard";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wkennington peti fpletz vrthra ];
    platforms = platforms.all;
  };
}
