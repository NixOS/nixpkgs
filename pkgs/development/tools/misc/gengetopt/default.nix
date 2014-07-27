{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "gengetopt-2.22.6";

  src = fetchurl {
    url = "mirror://gnu/gengetopt/${name}.tar.gz";
    sha256 = "1xq1kcfs6hri101ss4dhym0jn96z4v6jdvx288mfywadc245mc1h";
  };

  doCheck = true;

  meta = {
    description = "GNU Gengetopt, a command-line option parser generator";

    longDescription =
      '' GNU Gengetopt program generates a C function that uses getopt_long
         function to parse the command line options, to validate them and
         fills a struct
      '';

    homepage = http://www.gnu.org/software/gengetopt/;

    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
