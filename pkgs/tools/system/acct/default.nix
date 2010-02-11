{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "acct-6.5.3";

  src = fetchurl {
    url = "mirror://gnu/acct/${name}.tar.gz";
    sha256 = "0a48z9wb1cfb7nnmr0y4pbyqbx6qim2hqwl9bm4iyfy1p2r06mml";
  };

  doCheck = true;

  meta = {
    description = "GNU Accounting Utilities, login and process accounting utilities";

    longDescription = ''
      The GNU Accounting Utilities provide login and process accounting
      utilities for GNU/Linux and other systems.  It is a set of utilities
      which reports and summarizes data about user connect times and process
      execution statistics.
    '';

    license = "GPLv3+";

    homepage = http://www.gnu.org/software/acct/;

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.allBut "i686-cygwin";
  };
}
