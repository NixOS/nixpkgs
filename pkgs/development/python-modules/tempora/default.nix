{ lib, buildPythonPackage, fetchPypi
, setuptools_scm, pytest, pytest-freezegun, freezegun, backports_unittest-mock
, six, pytz, jaraco_functools, pythonOlder }:

buildPythonPackage rec {
  pname = "tempora";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e370d822cf48f5356aab0734ea45807250f5120e291c76712a1d766b49ae34f8";
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
