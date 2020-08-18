{ lib, buildPythonPackage, fetchPypi
, setuptools_scm, pytest, pytest-freezegun, freezegun, backports_unittest-mock
, six, pytz, jaraco_functools, pythonOlder
, pytest-flake8, pytestcov, pytest-black, pytest-mypy
}:

buildPythonPackage rec {
  pname = "tempora";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "599a3a910b377f2b544c7b221582ecf4cb049b017c994b37f2b1a9ed1099716e";
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
