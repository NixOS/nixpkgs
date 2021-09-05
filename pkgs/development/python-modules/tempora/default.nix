{ lib, buildPythonPackage, fetchPypi
, setuptools-scm, pytest, pytest-freezegun, freezegun, backports_unittest-mock
, six, pytz, jaraco_functools, pythonOlder
, pytest-flake8, pytest-cov, pytest-black, pytest-mypy
}:

buildPythonPackage rec {
  pname = "tempora";
  version = "4.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c54da0f05405f04eb67abbb1dff4448fd91428b58cb00f0f645ea36f6a927950";
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
