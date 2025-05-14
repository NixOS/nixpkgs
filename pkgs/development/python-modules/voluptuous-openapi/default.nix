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
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "voluptuous-openapi";
    tag = "v${version}";
    hash = "sha256-cfunRVEFz8gMLEtZ6nhH7w/rW5ea0JaaV+W/4gm4mwo=";
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
