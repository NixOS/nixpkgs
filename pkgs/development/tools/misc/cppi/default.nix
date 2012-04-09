{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "cppi-1.16";

  src = fetchurl {
    url = "mirror://gnu/cppi/${name}.tar.xz";
    sha256 = "16i4j80wam7p189xc9i2ijrcgjn684296rym6ja3nlqv8rv90lm8";
  };

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
