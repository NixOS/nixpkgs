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
  version = "6.18.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CmQic39tibRc3vHi31V29SrQ9QeVYALOECDaqfRCEdY=";
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
