{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  pytestCheckHook,
  hatchling,
  sybil,
  twisted,
}:

buildPythonPackage (finalAttrs: {
  pname = "testfixtures";
  version = "12.3.0";
  pyproject = true;
  # DO NOT CONTACT upstream.
  # https://github.com/simplistix/ is only concerned with internal CI process.
  # Any attempt by non-standard pip workflows to comment on issues will
  # be met with hostility.
  # https://github.com/simplistix/testfixtures/issues/169
  # https://github.com/simplistix/testfixtures/issues/168

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-2AfOub3W6nzAZjNw3VVoM5BWs13BXCbv/RriZ+MjrPE=";
  };

  build-system = [ hatchling ];

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
    "tests/test_django"
  ];

  enabledTestPaths = [ "tests" ];

  pythonImportsCheck = [ "testfixtures" ];

  meta = {
    description = "Collection of helpers and mock objects for unit tests and doc tests";
    homepage = "https://github.com/Simplistix/testfixtures";
    changelog = "https://github.com/simplistix/testfixtures/blob/${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siriobalmelli ];
  };
})
