{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  jsonschema,
  pyyaml,
  pytestCheckHook,
  typing-extensions,
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

  postPatch = ''
    # https://github.com/Yelp/swagger_spec_validator/pull/176
    substituteInPlace swagger_spec_validator/common.py tests/common_test.py \
      --replace-fail "import importlib_resources" "import importlib.resources as importlib_resources"
  '';

  build-system = [ setuptools ];

  pythonRemoveDeps = [
    "importlib-resources"
  ];

  dependencies = [
    pyyaml
    jsonschema
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "swagger_spec_validator" ];

  meta = {
    homepage = "https://github.com/Yelp/swagger_spec_validator";
    license = lib.licenses.asl20;
    description = "Validation of Swagger specifications";
    maintainers = with lib.maintainers; [ vanschelven ];
  };
})
