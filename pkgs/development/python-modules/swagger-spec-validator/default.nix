{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyyaml,
  jsonschema,
  six,
  pytestCheckHook,
  mock,
}:

buildPythonPackage rec {
  pname = "swagger-spec-validator";
  version = "3.0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Yelp";
    repo = "swagger_spec_validator";
    rev = "v${version}";
    hash = "sha256-8T0973g8JZKLCTpYqyScr/JAiFdBexEReUJoMQh4vO4=";
  };

  propagatedBuildInputs = [
    pyyaml
    jsonschema
    six
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
