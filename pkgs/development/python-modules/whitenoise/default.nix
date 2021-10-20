{ lib
, brotli
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "whitenoise";
  version = "5.3.0";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "evansd";
    repo = pname;
    rev = "v${version}";
    sha256 = "17j1rml1hb43c7fs7kf4ygkpmnjppzgsbnyw3plq9w3yh9w5hkhg";
  };

  propagatedBuildInputs = [
    brotli
  ];

  checkInputs = [
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
    description = "Radically simplified static file serving for WSGI applications";
    homepage = "http://whitenoise.evans.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
