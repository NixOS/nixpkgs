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
  version = "6.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "evansd";
    repo = "whitenoise";
    tag = version;
    hash = "sha256-pcU4qa2dlyPfMgyi1O8zME4GukIvKN4MQhFtJJjdn9w=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ setuptools ];

  dependencies = [ brotli ];

  nativeCheckInputs = [
    django
    pytestCheckHook
    requests
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
