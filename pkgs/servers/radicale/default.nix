{ stdenv, fetchFromGitHub, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "Radicale";
  version = "2.1.10";

  # No tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "Kozea";
    repo = "Radicale";
    rev = version;
    sha256 = "0ik9gvljxhmykkzzcv9kmkp4qjwgdrl9f7hp6300flx5kmqlcjb1";
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
