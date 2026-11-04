{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  legacy-cgi,
  pytestCheckHook,

  # for passthru.tests
  pyramid,
  routes,
  tokenlib,
}:

buildPythonPackage rec {
  pname = "webob";
  version = "1.8.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Pylons";
    repo = "webob";
    tag = version;
    hash = "sha256-K/Szik724N7Ok4R1G0CxjVjjCooOcwyo3ONTabW3pA0=";
  };

  build-system = [ setuptools ];

  # https://github.com/Pylons/webob/issues/437
  dependencies = [ legacy-cgi ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "webob" ];

  disabledTestPaths = [
    # AttributeError: 'Thread' object has no attribute 'isAlive'
    "tests/test_in_wsgiref.py"
    "tests/test_client_functional.py"
  ];

  passthru.tests = {
    inherit pyramid routes tokenlib;
  };

  meta = {
    description = "WSGI request and response object";
    homepage = "https://webob.org/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
