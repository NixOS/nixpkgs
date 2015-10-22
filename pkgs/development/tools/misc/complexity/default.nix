{ fetchurl, stdenv, autogen }:

stdenv.mkDerivation rec {
  name = "complexity-${version}";
  version = "1.3";

  src = fetchurl {
    url = "mirror://gnu/complexity/${name}.tar.gz";
    sha256 = "19bc64sxpqd5rqylqaa7dijz2x7qp2b0dg3ah3fb3qbcvd8b4wgy";
  };

  buildInputs = [ autogen ];

  doCheck = true;

  meta = {
    description = "C code complexity measurement tool";

    longDescription =
      '' GNU Complexity is a tool designed for analyzing the complexity of C
         program functions.  It is very similar to the McCabe scoring, but
         addresses several issues not considered in that scoring scheme.
      '';

    license = stdenv.lib.licenses.gpl3Plus;

    homepage = http://www.gnu.org/software/complexity/;

    platforms = stdenv.lib.platforms.gnu;
    maintainers = [ ];
  };
}
