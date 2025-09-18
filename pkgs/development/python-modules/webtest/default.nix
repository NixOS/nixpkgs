{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pastedeploy,
  pyquery,
  pytestCheckHook,
  pythonOlder,
  six,
  waitress,
  webob,
  wsgiproxy2,
}:

buildPythonPackage rec {
  pname = "webtest";
  version = "3.0.6";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Qlb9UkJEj1bFdby5r+J14wWm8HI8SwFDjb3U3VNElEs=";
  };

  build-system = [ setuptools ];

  dependencies = [
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

  pythonImportsCheck = [ "webtest" ];

  meta = with lib; {
    description = "Helper to test WSGI applications";
    homepage = "https://webtest.readthedocs.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
