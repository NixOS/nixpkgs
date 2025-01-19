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
  version = "3.0.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-STtcgC+JSKZbXjoa1bJSTuXhq2DNcT2aPaO42ggsBv4=";
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

  meta = {
    description = "Helper to test WSGI applications";
    homepage = "https://webtest.readthedocs.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
