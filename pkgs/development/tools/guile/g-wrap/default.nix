{ fetchurl, stdenv, guile, libffi, pkgconfig, glib
, guileLib }:

stdenv.mkDerivation rec {
  name = "g-wrap-1.9.11";
  src = fetchurl {
    url = "mirror://savannah/g-wrap/${name}.tar.gz";
    sha256 = "1j8zchilsr0dziyr21az4x3xxyr4d3jc8nybag9rp6pjj8k49adn";
  };

  # Note: Glib support is optional, but it's quite useful (e.g., it's
  # used by Guile-GNOME).  Guile-Library is needed by the test suite.
  buildInputs = [ guile libffi pkgconfig glib guileLib ];

  # GMP 4.2.2 uses GNU "extern inline".  With GCC 4.2 in C99 mode,
  # this yields warnings such as:
  #
  #  gmp.h:1606: warning: C99 inline functions are not supported; using GNU89
  #
  # Since G-Wrap builds in C99 mode and with `-Werror', we need to
  # pass it `-fgnu89-inline'.
  CFLAGS = "-fgnu89-inline";

  doCheck = true;

  meta = {
    description = "G-Wrap, a wrapper generator for Guile";
    longDescription = ''
      G-Wrap is a tool (and Guile library) for generating function
      wrappers for inter-language calls.  It currently only supports
      generating Guile wrappers for C functions.
    '';
    homepage = http://www.nongnu.org/g-wrap/;
    license = "LGPLv2+";
  };
}
