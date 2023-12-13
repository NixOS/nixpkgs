{ lib
, brotli
, buildPythonPackage
, django
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "whitenoise";
  version = "6.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "evansd";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-g1D0tjGsAP3y1fWvODWwNvxnTSZJuTpyZ0Otk83Oq9E=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    brotli
  ];

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

  pythonImportsCheck = [
    "whitenoise"
  ];

  meta = with lib; {
    description = "Library to serve static file for WSGI applications";
    homepage = "https://whitenoise.readthedocs.io/";
    changelog = "https://github.com/evansd/whitenoise/blob/${version}/docs/changelog.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
