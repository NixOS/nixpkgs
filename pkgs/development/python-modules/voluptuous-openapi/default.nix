{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  voluptuous,

  # tests
  openapi-schema-validator,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "voluptuous-openapi";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "voluptuous-openapi";
    tag = version;
    hash = "sha256-e94D87plGOcdXFLmZ4MhOt5xWbcoqyo3FgYbbXV8nNU=";
  };

  build-system = [ setuptools ];

  dependencies = [ voluptuous ];

  nativeCheckInputs = [
    openapi-schema-validator
    pytestCheckHook
  ];

  pythonImportsCheck = [ "voluptuous_openapi" ];

  meta = {
    changelog = "https://github.com/home-assistant-libs/voluptuous-openapi/releases/tag/${src.tag}";
    description = "Convert voluptuous schemas to OpenAPI Schema object";
    homepage = "https://github.com/home-assistant-libs/voluptuous-openapi";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
