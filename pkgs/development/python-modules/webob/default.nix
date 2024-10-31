{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  legacy-cgi,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,

  # for passthru.tests
  pyramid,
  routes,
  tokenlib,
}:

buildPythonPackage rec {
  pname = "webob";
  version = "1.8.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Pylons";
    repo = "webob";
    rev = "refs/tags/${version}";
    hash = "sha256-QN0UMLzO0g8Oalnn5GlOulXUxtXOx89jeeEvJV53rVs=";
  };

  build-system = [ setuptools ];

  # https://github.com/Pylons/webob/issues/437
  dependencies = lib.optionals (pythonAtLeast "3.13") [ legacy-cgi ];

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
    maintainers = [ ];
  };
}
