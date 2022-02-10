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
  version = "6.18.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JgAQCulv/QgjNLN441VVD++LSlKab6TDT0cTCQXHQm0=";
  };

  # no longer compatible with sybil
  # https://github.com/simplistix/testfixtures/issues/169
  doCheck = false;
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

  disabledTests = lib.optionals (pythonAtLeast "3.10") [
    # https://github.com/simplistix/testfixtures/issues/168
    "test_invalid_communicate_call"
    "test_invalid_kill"
    "test_invalid_parameters"
    "test_invalid_poll"
    "test_invalid_send_signal"
    "test_invalid_terminate"
    "test_invalid_wait_call"
    "test_replace_delattr_cant_remove"
    "test_replace_delattr_cant_remove_not_strict"
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
