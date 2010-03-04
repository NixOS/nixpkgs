{ fetchurl, xz, stdenv }:

stdenv.mkDerivation rec {
  name = "cppi-1.14";

  src = fetchurl {
    url = "mirror://gnu/cppi/${name}.tar.xz";
    sha256 = "0n7388f5z4nnyh17rnj7h0kvml3x2mba6a5km87k2bvm5v4mcrfc";
  };

  buildInputs = [ xz ];

  doCheck = true;

  meta = {
    homepage = http://savannah.gnu.org/projects/cppi/;

    description = "GNU cppi, a cpp directive indenter";

    longDescription =
      '' GNU cppi indents C preprocessor directives to reflect their nesting
         and ensure that there is exactly one space character between each #if,
         #elif, #define directive and the following token.  The number of
         spaces between the `#' and the following directive must correspond
         to the level of nesting of that directive.
      '';

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}
