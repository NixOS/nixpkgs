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
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "voluptuous-openapi";
    tag = version;
    hash = "sha256-uIW+WyfSNdGxD7tA6ERf3nTp1tFhWd+lxFUNQM0O3nU=";
  };

  build-system = [ setuptools ];

  dependencies = [ voluptuous ];

  nativeCheckInputs = [
    openapi-schema-validator
    pytestCheckHook
  ];

  pythonImportsCheck = [ "voluptuous_openapi" ];

  meta = with lib; {
    changelog = "https://github.com/home-assistant-libs/voluptuous-openapi/releases/tag/${src.tag}";
    description = "Convert voluptuous schemas to OpenAPI Schema object";
    homepage = "https://github.com/home-assistant-libs/voluptuous-openapi";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
