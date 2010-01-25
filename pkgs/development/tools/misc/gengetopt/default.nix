{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "gengetopt-2.22.4";

  src = fetchurl {
    url = "mirror://gnu/gengetopt/${name}.tar.gz";
    sha256 = "08a4wmzvin8ljdgw2c0mcz654h4hpzam2p43hsf951c0xhj6ppsf";
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
