{ stdenv, fetchurl, pkgconfig, perl, cups, dbus }:

stdenv.mkDerivation rec {
  name = "foomatic-filters-4.0.12";

  src = fetchurl {
    url = "http://www.openprinting.org/download/foomatic/${name}.tar.gz";
    sha256 = "17w26r15094j4fqifa7f7i7jad4gsy9zdlq69kffrykcw31qx3q8";
  };

  buildInputs = [ pkgconfig perl cups dbus ];

  preConfigure =
    ''
      substituteInPlace foomaticrip.c --replace /bin/bash /bin/sh
    '';

  installTargets = "install-cups";

  installFlags =
    ''
      CUPS_FILTERS=$(out)/lib/cups/filter
      CUPS_BACKENDS=$(out)/lib/cups/backend
    '';

  meta = {
    description = "Foomatic printing filters";
    maintainers = stdenv.lib.maintainers.raskin;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
