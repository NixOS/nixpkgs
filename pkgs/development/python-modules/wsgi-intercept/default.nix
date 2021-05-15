{ lib, buildPythonPackage, fetchPypi, six, httplib2, py, pytestCheckHook, requests, urllib3 }:

buildPythonPackage rec {
  pname = "wsgi-intercept";
  version = "1.9.2";

  src = fetchPypi {
    pname = "wsgi_intercept";
    inherit version;
    sha256 = "1b6251d03jnhqywr54bzj9fnc3qzp2kvz22asxpd27jy984qx21n";
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
