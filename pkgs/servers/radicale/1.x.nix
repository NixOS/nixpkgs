{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "radicale-${version}";
  version = "1.1.6";

  src = fetchurl {
    url = "mirror://pypi/R/Radicale/Radicale-${version}.tar.gz";
    sha256 = "0ay90nj6fmr2aq8imi0mbjl4m2rzq7a83ikj8qs9gxsylj71j1y0";
  };

  propagatedBuildInputs = stdenv.lib.optionals (!pythonPackages.isPy3k) [
    pythonPackages.flup
    pythonPackages.ldap
    pythonPackages.sqlalchemy
  ];

  doCheck = !pythonPackages.isPy3k;

  meta = with stdenv.lib; {
    homepage = http://www.radicale.org/;
    description = "CalDAV CardDAV server";
    longDescription = ''
      The Radicale Project is a complete CalDAV (calendar) and CardDAV
      (contact) server solution. Calendars and address books are available for
      both local and remote access, possibly limited through authentication
      policies. They can be viewed and edited by calendar and contact clients
      on mobile phones or computers.
    '';
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ edwtjo pSub aneeshusa ];
  };
}
