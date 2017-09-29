{ stdenv, fetchFromGitHub, python3Packages }:

let
  version = "2.1.6";
  sha256 = "1x76nvxjhjpagniyh075hqia4sl06972alnhi7628cjrq3pr4v9i";
in

python3Packages.buildPythonApplication {
  name = "radicale-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "Kozea";
    repo = "Radicale";
    rev = version;
    inherit sha256;
  };

  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    vobject
    passlib
  ];

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
    maintainers = with maintainers; [ edwtjo pSub aneeshusa infinisil ];
  };
}
