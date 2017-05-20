{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "acct-6.6.3";

  src = fetchurl {
    url = "mirror://gnu/acct/${name}.tar.gz";
    sha256 = "14x0zklwlg7cc7amlyzffqr8az3fqj1h9dyj0hvl1kpi7cr7kbjy";
  };

  doCheck = true;

  meta = with stdenv.lib; {
    description = "GNU Accounting Utilities, login and process accounting utilities";

    longDescription = ''
      The GNU Accounting Utilities provide login and process accounting
      utilities for GNU/Linux and other systems.  It is a set of utilities
      which reports and summarizes data about user connect times and process
      execution statistics.
    '';

    license = licenses.gpl3Plus;

    homepage = http://www.gnu.org/software/acct/;

    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
