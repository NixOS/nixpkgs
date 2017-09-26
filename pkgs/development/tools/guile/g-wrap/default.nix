{ fetchurl, stdenv, guile, libffi, pkgconfig, glib, guile-lib }:

stdenv.mkDerivation rec {
  name = "g-wrap-1.9.15";
  src = fetchurl {
    url = "mirror://savannah/g-wrap/${name}.tar.gz";
    sha256 = "0ak0bha37dfpj9kmyw1r8fj8nva639aw5xr66wr5gd3l1rqf5xhg";
  };

  # Note: Glib support is optional, but it's quite useful (e.g., it's
  # used by Guile-GNOME).
  buildInputs = [ guile pkgconfig glib guile-lib ];

  propagatedBuildInputs = [ libffi ];

  doCheck = true;

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
    platforms = stdenv.lib.platforms.linux;
  };
}
