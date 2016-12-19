{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "radicale-${version}";
  version = "1.1.1";

  src = fetchurl {
    url = "mirror://pypi/R/Radicale/Radicale-${version}.tar.gz";
    sha256 = "1c5lv8qca21mndkx350wxv34qypqh6gb4rhzms4anr642clq3jg2";
  };

  propagatedBuildInputs = [
    pythonPackages.flup
    pythonPackages.ldap
    pythonPackages.sqlalchemy
  ];

  doCheck = true;

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
    platform = platforms.all;
    maintainers = with maintainers; [ edwtjo pSub ];
  };
}
