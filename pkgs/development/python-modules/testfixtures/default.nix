{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  pytestCheckHook,
  setuptools,
  sybil,
  twisted,
}:

buildPythonPackage rec {
  pname = "testfixtures";
  version = "10.0.0";
  pyproject = true;
  # DO NOT CONTACT upstream.
  # https://github.com/simplistix/ is only concerned with internal CI process.
  # Any attempt by non-standard pip workflows to comment on issues will
  # be met with hostility.
  # https://github.com/simplistix/testfixtures/issues/169
  # https://github.com/simplistix/testfixtures/issues/168

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-K5gpv39C8MqGACUHYuZyVXXaWa8Y2af4Kq4sl7FPD2Y=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    sybil
    twisted
  ];

  disabledTests = [
    "test_filter_missing"
    "test_filter_present"
  ];

  disabledTestPaths = [
    # Django is too much hasle to setup at the moment
    "testfixtures/tests/test_django"
  ];

  enabledTestPaths = [ "testfixtures/tests" ];

  pythonImportsCheck = [ "testfixtures" ];

  meta = {
    description = "Collection of helpers and mock objects for unit tests and doc tests";
    homepage = "https://github.com/Simplistix/testfixtures";
    changelog = "https://github.com/simplistix/testfixtures/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siriobalmelli ];
  };
}
