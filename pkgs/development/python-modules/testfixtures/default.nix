{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, isPy27
, mock
, pytestCheckHook
, sybil
, twisted
, zope_component
}:

buildPythonPackage rec {
  pname = "testfixtures";
  version = "6.18.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JgAQCulv/QgjNLN441VVD++LSlKab6TDT0cTCQXHQm0=";
  };

  checkInputs = [
    pytestCheckHook
    mock
    sybil
    zope_component
    twisted
  ];

  doCheck = !isPy27;

  disabledTestPaths = [
    # Django is too much hasle to setup at the moment
    "testfixtures/tests/test_django"
  ];

  pytestFlagsArray = [
    "testfixtures/tests"
  ];

  pythonImportsCheck = [ "testfixtures" ];

  meta = with lib; {
    homepage = "https://github.com/Simplistix/testfixtures";
    description = "A collection of helpers and mock objects for unit tests and doc tests";
    license = licenses.mit;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
