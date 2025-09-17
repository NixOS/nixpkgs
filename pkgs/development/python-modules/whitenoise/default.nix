{
  lib,
  brotli,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "whitenoise";
  version = "6.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "evansd";
    repo = "whitenoise";
    tag = version;
    hash = "sha256-sc8UAeLTK3lLs16woGW/2gn0ECTARNW4tF4vlTGmIuU=";
  };

  build-system = [ setuptools ];

  dependencies = [ brotli ];

  nativeCheckInputs = [
    django
    pytestCheckHook
    requests
  ];

  __darwinAllowLocalNetworking = true;

  disabledTestPaths = [
    # Don't run Django tests
    "tests/test_django_whitenoise.py"
    "tests/test_runserver_nostatic.py"
    "tests/test_storage.py"
  ];

  disabledTests = [
    # Test fails with AssertionError
    "test_modified"
  ];

  pythonImportsCheck = [ "whitenoise" ];

  meta = with lib; {
    description = "Library to serve static file for WSGI applications";
    homepage = "https://whitenoise.readthedocs.io/";
    changelog = "https://github.com/evansd/whitenoise/blob/${version}/docs/changelog.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
