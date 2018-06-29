{ stdenv, fetchFromGitHub, python3 }:

let
  version = "2.1.9";
  sha256 = "1sywxn7j9bq39qwq74h327crc44j9049cykai1alv44agx8s1nhz";

  python = python3.override {
    packageOverrides = self: super: {

      # https://github.com/eventable/vobject/issues/112
      python-dateutil = super.python-dateutil.overridePythonAttrs (oldAttrs: rec {
        version = "2.6.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca";
        };
      });

    };
  };
in

python.pkgs.buildPythonApplication {
  name = "radicale-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "Kozea";
    repo = "Radicale";
    rev = version;
    inherit sha256;
  };

  doCheck = false;

  propagatedBuildInputs = with python.pkgs; [
    vobject
    passlib
    pytz
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
