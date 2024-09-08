{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchPypi,
  pastedeploy,
  pyquery,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  waitress,
  webob,
  wsgiproxy2,
}:

buildPythonPackage rec {
  pname = "webtest";
  version = "3.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-STtcgC+JSKZbXjoa1bJSTuXhq2DNcT2aPaO42ggsBv4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
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
    changelog = "https://github.com/Pylons/webtest/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
