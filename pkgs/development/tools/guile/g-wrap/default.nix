{ fetchurl, stdenv, guile, libffi, pkgconfig, glib, guile_lib }:

stdenv.mkDerivation rec {
  name = "g-wrap-1.9.15";
  src = fetchurl {
    url = "mirror://savannah/g-wrap/${name}.tar.gz";
    sha256 = "140fcvp24pqmfmiibhjxl3s75hj26ln7pkl2wxas84lnchbj9m4d";
  };

  # Note: Glib support is optional, but it's quite useful (e.g., it's
  # used by Guile-GNOME).
  buildInputs = [ guile pkgconfig glib ]
    ++ stdenv.lib.optional doCheck guile_lib;

  propagatedBuildInputs = [ libffi ];

  doCheck = !stdenv.isFreeBSD; # XXX: 00-socket.test hangs

  meta = {
    description = "G-Wrap, a wrapper generator for Guile";
    longDescription = ''
      G-Wrap is a tool (and Guile library) for generating function
      wrappers for inter-language calls.  It currently only supports
      generating Guile wrappers for C functions.
    '';
    homepage = http://www.nongnu.org/g-wrap/;
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = [ stdenv.lib.maintainers.taktoa ];
  };
}
