{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "radicale-${version}";
  version = "1.1.2";

  src = fetchurl {
    url = "mirror://pypi/R/Radicale/Radicale-${version}.tar.gz";
    sha256 = "1g20p3998f46ywda7swv0py63wjbrhvk0nrafajlbb6wgzxjmqpb";
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
