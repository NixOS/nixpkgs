{
  lib,
  brotli,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "whitenoise";
  version = "6.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "evansd";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-4SrTiTqBrfFuQ/8mqQL+YiehFWW+ZzKiAF0h2XyYuSs=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ brotli ];

  nativeCheckInputs = [
    django
    pytestCheckHook
    requests
  ];

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
