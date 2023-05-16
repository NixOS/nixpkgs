{ lib
, buildPythonPackage
, fetchPypi
, six
, httplib2
, py
, pytestCheckHook
, pythonOlder
, requests
, urllib3
}:

buildPythonPackage rec {
  pname = "wsgi-intercept";
<<<<<<< HEAD
  version = "1.12.1";
=======
  version = "1.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "wsgi_intercept";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-StUxEN91fU7qoptH9iKJFpZWIBIOtIe6S4gvdBgN48E=";
=======
    hash = "sha256-KvrZs+EgeK7Du7ni6icKHfcF0W0RDde0W6Aj/EPZ2Hw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    httplib2
    py
    pytestCheckHook
    requests
    urllib3
  ];

  disabledTests = [
    "test_http_not_intercepted"
    "test_https_not_intercepted"
    "test_https_no_ssl_verification_not_intercepted"
  ];

  pythonImportsCheck = [
    "wsgi_intercept"
  ];

  meta = with lib; {
    description = "Module that acts as a WSGI application in place of a real URI for testing";
    homepage = "https://github.com/cdent/wsgi-intercept";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
