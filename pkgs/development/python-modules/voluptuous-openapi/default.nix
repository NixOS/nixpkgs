{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  voluptuous,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "voluptuous-openapi";
  version = "0.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "voluptuous-openapi";
    rev = "v${version}";
    hash = "sha256-QZi2uxFrYMSJVKIHTRBlGAM1sCD6oIzsZNQH7zkXL8w=";
  };

  build-system = [ setuptools ];

  dependencies = [ voluptuous ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "voluptuous_openapi" ];

  meta = with lib; {
    changelog = "https://github.com/home-assistant-libs/voluptuous-openapi/releases/tag/${src.rev}";
    description = "Convert voluptuous schemas to OpenAPI Schema object";
    homepage = "https://github.com/home-assistant-libs/voluptuous-openapi";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
