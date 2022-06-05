{ lib, buildPythonPackage, fetchPypi, six, httplib2, py, pytestCheckHook, requests, urllib3 }:

buildPythonPackage rec {
  pname = "wsgi-intercept";
  version = "1.10.0";

  src = fetchPypi {
    pname = "wsgi_intercept";
    inherit version;
    sha256 = "sha256-BX8EWtR8pXkibcliJbfBw6/5VdHs9HczjM1c1SWx3wk=";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ httplib2 py pytestCheckHook requests urllib3 ];

  disabledTests = [
    "test_http_not_intercepted"
    "test_https_not_intercepted"
    "test_https_no_ssl_verification_not_intercepted"
  ];

  pythonImportsCheck = [ "wsgi_intercept" ];

  meta = with lib; {
    description = "wsgi_intercept installs a WSGI application in place of a real URI for testing";
    homepage = "https://github.com/cdent/wsgi-intercept";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
