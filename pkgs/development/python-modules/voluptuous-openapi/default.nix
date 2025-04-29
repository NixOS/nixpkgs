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
  version = "0.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "voluptuous-openapi";
    tag = "v${version}";
    hash = "sha256-shgLUO4dFuvVG8K3yuK8FUsohIb4zgh7h6nvNiaYws0=";
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
