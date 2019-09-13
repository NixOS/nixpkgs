{ stdenv, fetchFromGitHub, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "Radicale";
  version = "2.1.11";

  # No tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "Kozea";
    repo = "Radicale";
    rev = version;
    sha256 = "1k32iy55lnyyp1r75clarhwdqvw6w8mxb5v0l5aysga07fg2mix4";
  };

  # We only want functional tests
  postPatch = ''
    sed -i "s/pytest-cov\|pytest-flake8\|pytest-isort//g" setup.py
    sed -i "/^addopts/d" setup.cfg
  '';

  propagatedBuildInputs = with python3.pkgs; [
    vobject
    python-dateutil
    passlib
    setuptools
  ];

  checkInputs = with python3.pkgs; [
    pytestrunner
    pytest
  ];

  meta = with stdenv.lib; {
    homepage = https://www.radicale.org/;
    description = "CalDAV CardDAV server";
    longDescription = ''
      The Radicale Project is a complete CalDAV (calendar) and CardDAV
      (contact) server solution. Calendars and address books are available for
      both local and remote access, possibly limited through authentication
      policies. They can be viewed and edited by calendar and contact clients
      on mobile phones or computers.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ edwtjo pSub aneeshusa infinisil ];
  };
}
