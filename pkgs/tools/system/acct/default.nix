{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "acct-6.5";

  src = fetchurl {
    url = "mirror://gnu/acct/${name}.tar.gz";
    sha256 = "0cw0id32mw9sy6950g38yi34wn1bryrdsklh23djlqmb1imbqlji";
  };

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
