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
  version = "1.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "wsgi_intercept";
    inherit version;
    hash = "sha256-9b8fvzBzBqCIQJEdNnaDnLIPaoctLxF1WvLTbZcoEhw=";
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
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
