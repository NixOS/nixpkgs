{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "acct-6.5.4";

  src = fetchurl {
    url = "mirror://gnu/acct/${name}.tar.gz";
    sha256 = "1fvrv70rnli1q7pn1j10z55f26awh54zwwann0s88yrjvpbzbhka";
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
