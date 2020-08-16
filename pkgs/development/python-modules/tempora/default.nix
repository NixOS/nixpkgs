{ lib, buildPythonPackage, fetchPypi
, setuptools_scm, pytest, pytest-freezegun, freezegun, backports_unittest-mock
, six, pytz, jaraco_functools, pythonOlder }:

buildPythonPackage rec {
  pname = "tempora";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "599a3a910b377f2b544c7b221582ecf4cb049b017c994b37f2b1a9ed1099716e";
  };

  disabled = pythonOlder "3.2";

  nativeBuildInputs = [ setuptools_scm ];

  patches = [
    ./0001-pytest-remove-flake8-black-coverage.patch
  ];

  propagatedBuildInputs = [ six pytz jaraco_functools ];

  checkInputs = [
    pytest-freezegun pytest freezegun backports_unittest-mock
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
