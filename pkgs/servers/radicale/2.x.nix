{ lib, fetchFromGitHub, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "Radicale";
  version = "2.1.12";

  # No tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "Kozea";
    repo = "Radicale";
    rev = version;
    sha256 = "14f9ql0fiwapaa4xaslwgk1ah9fzxxan2p1p2rxb4a5iqph1z0cl";
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
    pytest-runner
    pytest
  ];

  meta = with lib; {
    homepage = "https://radicale.org/v2.html";
    description = "CalDAV CardDAV server";
    longDescription = ''
      The Radicale Project is a complete CalDAV (calendar) and CardDAV
      (contact) server solution. Calendars and address books are available for
      both local and remote access, possibly limited through authentication
      policies. They can be viewed and edited by calendar and contact clients
      on mobile phones or computers.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ edwtjo pSub infinisil ];
  };
}
