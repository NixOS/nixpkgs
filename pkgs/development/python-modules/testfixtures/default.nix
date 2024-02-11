{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, mock
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, setuptools
, sybil
, twisted
, zope-component
}:

buildPythonPackage rec {
  pname = "testfixtures";
  version = "7.2.2";
  pyproject = true;
  # DO NOT CONTACT upstream.
  # https://github.com/simplistix/ is only concerned with internal CI process.
  # Any attempt by non-standard pip workflows to comment on issues will
  # be met with hostility.
  # https://github.com/simplistix/testfixtures/issues/169
  # https://github.com/simplistix/testfixtures/issues/168

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gHdK7LAklFgnWreD9TCT++dXlf8rMhjSLOP/8KEsTaY=";
  };

  patches = [
    # https://github.com/simplistix/testfixtures/pull/188
    (fetchpatch {
      name = "python3.12-compatibility.patch";
      url = "https://github.com/simplistix/testfixtures/commit/2b80b195e30e12c739dc4f98e9de17dec8f3558a.patch";
      hash = "sha256-LrC0uI4k3F6ZGTqbKi319tRbVk5557xbyzQN36Y1160=";
     })
  ];

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    sybil
    twisted
    zope-component
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
    changelog = "https://github.com/simplistix/testfixtures/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
