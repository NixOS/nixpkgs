{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "cppi-1.18";

  src = fetchurl {
    url = "mirror://gnu/cppi/${name}.tar.xz";
    sha256 = "1jk42cjaggk71rimjnx3qpmb6hivps0917vl3z7wbxk3i2whb98j";
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

    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}
