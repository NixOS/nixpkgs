{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,

  # for passthru.tests
  pyramid,
  routes,
  tokenlib,
}:

buildPythonPackage rec {
  pname = "webob";
  version = "1.8.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Pylons";
    repo = "webob";
    rev = "refs/tags/${version}";
    hash = "sha256-QN0UMLzO0g8Oalnn5GlOulXUxtXOx89jeeEvJV53rVs=";
  };

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

  meta = with lib; {
    description = "WSGI request and response object";
    homepage = "https://webob.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
