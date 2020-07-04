{ lib, python3, fetchFromGitHub }:

python3.pkgs.buildPythonApplication rec {
  pname = "radicale";
  version = "3.0.3";

  # No tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "Kozea";
    repo = "Radicale";
    rev = version;
    sha256 = "170mqxlnfzx15img4wb71axq9cnxwllk5cabsv8i008q7wyjqp0n";
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
