{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "Radicale";
  version = "3.0.6";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "a9433d3df97135d9c02cec8dde4199444daf1b73ad161ded398d67b8e629fdc6";
  };

  propagatedBuildInputs = with python3.pkgs; [
    defusedxml
    passlib
    vobject
    python-dateutil
    setuptools
  ];

  checkInputs = with python3.pkgs; [
    pytestrunner
    pytest
    pytestcov
    pytest-flake8
    pytest-isort
    waitress
  ];

  meta = with lib; {
    homepage = "https://www.radicale.org/3.0.html";
    description = "CalDAV and CardDAV server";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
