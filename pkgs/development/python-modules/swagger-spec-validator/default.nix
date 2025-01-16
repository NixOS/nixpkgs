{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyyaml,
  jsonschema,
  importlib-resources,
  typing-extensions,
  pytestCheckHook,
  mock,
}:

buildPythonPackage rec {
  pname = "swagger-spec-validator";
  version = "3.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Yelp";
    repo = "swagger_spec_validator";
    rev = "v${version}";
    hash = "sha256-8T0973g8JZKLCTpYqyScr/JAiFdBexEReUJoMQh4vO4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    importlib-resources
    jsonschema
    pyyaml
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [ "swagger_spec_validator" ];

  meta = with lib; {
    homepage = "https://github.com/Yelp/swagger_spec_validator";
    license = licenses.asl20;
    description = "Validation of Swagger specifications";
    maintainers = with maintainers; [ vanschelven ];
  };
}
