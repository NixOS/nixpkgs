{ lib, buildPythonPackage, fetchPypi
, setuptools-scm, pytest, pytest-freezegun, freezegun, backports_unittest-mock
, six, pytz, jaraco_functools, pythonOlder
, pytest-flake8, pytest-cov, pytest-black, pytest-mypy
}:

buildPythonPackage rec {
  pname = "tempora";
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aa21dd1956e29559ecb2f2f2e14fcdb950085222fbbf86e6c946b5e1a8c36b26";
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
