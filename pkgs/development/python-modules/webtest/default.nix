{ lib
, beautifulsoup4
, buildPythonPackage
, fetchPypi
, pastedeploy
, pyquery
, pytestCheckHook
, pythonOlder
, six
, waitress
, webob
, wsgiproxy2
}:

buildPythonPackage rec {
  pname = "webtest";
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "WebTest";
    inherit version;
    hash = "sha256-VL2WlyWDjZhhqfon+Nlx950nXZSuJV9cUB9Tu22ZKes=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    six
    waitress
    webob
  ];

  nativeCheckInputs = [
    pastedeploy
    pyquery
    pytestCheckHook
    wsgiproxy2
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "webtest"
  ];

  meta = with lib; {
    description = "Helper to test WSGI applications";
    homepage = "https://webtest.readthedocs.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
