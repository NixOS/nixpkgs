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
<<<<<<< HEAD
  version = "6.5.0";
=======
  version = "6.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "evansd";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-g1D0tjGsAP3y1fWvODWwNvxnTSZJuTpyZ0Otk83Oq9E=";
=======
    hash = "sha256-ouEoqMcNh3Vwahwaq6bGQuVUFViVN14CDJosDXC5ozI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    homepage = "https://whitenoise.readthedocs.io/";
=======
    homepage = "https://whitenoise.evans.io/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    changelog = "https://github.com/evansd/whitenoise/blob/${version}/docs/changelog.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
