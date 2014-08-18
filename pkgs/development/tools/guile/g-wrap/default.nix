{ fetchurl, stdenv, guile, libffi, pkgconfig, glib
, guile_lib }:

stdenv.mkDerivation rec {
  name = "g-wrap-1.9.13";
  src = fetchurl {
    url = "mirror://savannah/g-wrap/${name}.tar.gz";
    sha256 = "0fc874zlwzjahyliqnva1zfsv0chlx4cvfhwchij9n2d3kmsss9v";
  };

  # Note: Glib support is optional, but it's quite useful (e.g., it's
  # used by Guile-GNOME).
  buildInputs = [ guile pkgconfig glib ]
    ++ stdenv.lib.optional doCheck guile_lib;

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
    license = "LGPLv2+";
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
