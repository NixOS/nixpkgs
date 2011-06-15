{ stdenv, fetchurl, perl, cups, coreutils, gnused }:

stdenv.mkDerivation rec {
  name = "foomatic-filters-4.0.6";

  src = fetchurl {
    url = "http://www.openprinting.org/download/foomatic/${name}.tar.gz";
    sha256 = "0wa9hlq7s99sh50kl6bj8j0vxrz7pcbwdnqs1yfjjhqshfh7hsav";
  };

  buildInputs = [ perl cups ];

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
