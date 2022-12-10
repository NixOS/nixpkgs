{ lib
, buildPythonPackage
, fetchPypi
, mock
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, sybil
, twisted
, zope_component
}:

buildPythonPackage rec {
  pname = "testfixtures";
  version = "7.0.0";
  format = "setuptools";
  # DO NOT CONTACT upstream.
  # https://github.com/simplistix/ is only concerned with internal CI process.
  # Any attempt by non-standard pip workflows to comment on issues will
  # be met with hostility.
  # https://github.com/simplistix/testfixtures/issues/169
  # https://github.com/simplistix/testfixtures/issues/168

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jsrFowh5NFFkBZTZykLOibmHcR4eTJMShVMh7CH2zLQ=";
  };

  checkInputs = [
    mock
    pytestCheckHook
    sybil
    twisted
    zope_component
  ];

  disabledTestPaths = [
    # Django is too much hasle to setup at the moment
    "testfixtures/tests/test_django"
  ];

  pytestFlagsArray = [
    "testfixtures/tests"
  ];

  pythonImportsCheck = [
    "testfixtures"
  ];

  meta = with lib; {
    description = "Collection of helpers and mock objects for unit tests and doc tests";
    homepage = "https://github.com/Simplistix/testfixtures";
    license = licenses.mit;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
