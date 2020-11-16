{ lib, buildPythonPackage, fetchPypi
, setuptools_scm, pytest, pytest-freezegun, freezegun, backports_unittest-mock
, six, pytz, jaraco_functools, pythonOlder
, pytest-flake8, pytestcov, pytest-black, pytest-mypy
}:

buildPythonPackage rec {
  pname = "tempora";
  version = "4.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9af06854fafb26d3d40d3dd6402e8baefaf57f90e48fdc9a94f6b22827a60fb3";
  };

  disabled = pythonOlder "3.2";

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ six pytz jaraco_functools ];

  checkInputs = [
    pytest-freezegun pytest freezegun backports_unittest-mock
    pytest-flake8 pytestcov pytest-black pytest-mypy
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Objects and routines pertaining to date and time";
    homepage = "https://github.com/jaraco/tempora";
    license = licenses.mit;
  };
}
