{ lib
, brotli
, buildPythonPackage
, django
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "whitenoise";
  version = "6.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "evansd";
    repo = pname;
    rev = version;
    hash = "sha256-mUjyX4eQOiMweje6UPyfyJsiHwzF5OQ93KuxFedWxbQ=";
  };

  propagatedBuildInputs = [
    brotli
  ];

  checkInputs = [
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
    description = "Radically simplified static file serving for WSGI applications";
    homepage = "http://whitenoise.evans.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
