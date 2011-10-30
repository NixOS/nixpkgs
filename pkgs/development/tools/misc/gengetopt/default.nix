{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "gengetopt-2.22.5";

  src = fetchurl {
    url = "mirror://gnu/gengetopt/${name}.tar.gz";
    sha256 = "0dr1xmlgk9q8za17wnpgghb5ifnbca5vb0w5bc6fpc2j0cjb6vrv";
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

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}
