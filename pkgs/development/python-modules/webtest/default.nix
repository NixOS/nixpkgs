{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
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
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "WebTest";
    inherit version;
    hash = "sha256-VL2WlyWDjZhhqfon+Nlx950nXZSuJV9cUB9Tu22ZKes=";
  };

  patches = [
    (fetchpatch {
      # Replace deprecated unittest aliases for Python 3.12
      name = "webtest-python312-compat.patch";
      url = "https://github.com/Pylons/webtest/commit/d82ec5bd2cf3c7109a1d49ad9fa802ae1eae1763.patch";
      hash = "sha256-hSwxAxAI3Eo28I8S+r2k/hFG8TlzrVYup3MuTsE+xXk=";
    })
  ];

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

  pythonImportsCheck = [ "webtest" ];

  meta = with lib; {
    description = "Helper to test WSGI applications";
    homepage = "https://webtest.readthedocs.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
