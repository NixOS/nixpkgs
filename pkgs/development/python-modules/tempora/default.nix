{ lib, buildPythonPackage, fetchPypi
, setuptools-scm, pytest, pytest-freezegun, freezegun, backports_unittest-mock
, six, pytz, jaraco_functools, pythonOlder
, pytest-flake8, pytest-cov, pytest-black, pytest-mypy
}:

buildPythonPackage rec {
  pname = "tempora";
  version = "4.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fd6cafd66b01390d53a760349cf0b3123844ec6ae3d1043d7190473ea9459138";
  };

  disabled = pythonOlder "3.2";

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ six pytz jaraco_functools ];

  checkInputs = [
    pytest-freezegun pytest freezegun backports_unittest-mock
    pytest-flake8 pytest-cov pytest-black pytest-mypy
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
