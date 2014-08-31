{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "acct-6.6.1";

  src = fetchurl {
    url = "mirror://gnu/acct/${name}.tar.gz";
    sha256 = "1jzz601cavml7894fjalw661gz28ia35002inw990agr3rhiaiam";
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

    license = stdenv.lib.licenses.gpl3Plus;

    homepage = http://www.gnu.org/software/acct/;

    maintainers = [ ];
    platforms = with stdenv.lib.platforms; allBut cygwin;
  };
}
