{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  importlib-resources,
  jsonschema,
  pyyaml,
  six,
  pytestCheckHook,
  mock,
}:

buildPythonPackage (finalAttrs: {
  pname = "swagger-spec-validator";
  version = "3.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Yelp";
    repo = "swagger_spec_validator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8T0973g8JZKLCTpYqyScr/JAiFdBexEReUJoMQh4vO4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    importlib-resources
    jsonschema
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [ "swagger_spec_validator" ];

  meta = {
    homepage = "https://github.com/Yelp/swagger_spec_validator";
    license = lib.licenses.asl20;
    description = "Validation of Swagger specifications";
    maintainers = with lib.maintainers; [ vanschelven ];
  };
})
