{ stdenv, fetchurl, pkgconfig, perl, cups, dbus }:

stdenv.mkDerivation rec {
  name = "foomatic-filters-4.0.17";

  src = fetchurl {
    url = "http://www.openprinting.org/download/foomatic/${name}.tar.gz";
    sha256 = "1qrkgbm5jay2r7sh9qbyf0aiyrsl1mdc844hxf7fhw95a0zfbqm2";
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
