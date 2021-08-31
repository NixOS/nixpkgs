{ lib, buildPythonPackage, fetchPypi
, setuptools-scm, pytest, pytest-freezegun, freezegun, backports_unittest-mock
, six, pytz, jaraco_functools, pythonOlder
, pytest-flake8, pytest-cov, pytest-black, pytest-mypy
}:

buildPythonPackage rec {
  pname = "tempora";
  version = "4.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10fdc29bf85fa0df39a230a225bb6d093982fc0825b648a414bbc06bddd79909";
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
