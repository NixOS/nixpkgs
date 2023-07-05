{ lib, buildPythonPackage, fetchFromGitHub, pyyaml, jsonschema, six, pytestCheckHook, mock }:

buildPythonPackage rec {
  pname = "swagger-spec-validator";
  version = "2.7.4";

  src = fetchFromGitHub {
    owner = "Yelp";
    repo = "swagger_spec_validator";
    rev = "v${version}";
    hash = "sha256-7+kFmtzeze0QlGf6z/M4J4F7z771a5NWewB1S3+bxn4=";
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
