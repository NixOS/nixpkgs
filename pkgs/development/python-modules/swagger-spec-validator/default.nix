{ lib, buildPythonPackage, fetchFromGitHub, pyyaml, jsonschema, six, pytest, mock }:

buildPythonPackage rec {
  pname = "swagger-spec-validator";
  version = "2.7.4";

  src = fetchFromGitHub {
    owner = "Yelp";
    repo = "swagger_spec_validator";
    rev = "v" + version;
    sha256 = "sha256-7+kFmtzeze0QlGf6z/M4J4F7z771a5NWewB1S3+bxn4=";
  };

  checkInputs = [
    pytest
    mock
  ];

  checkPhase = ''
    pytest tests
  '';

  propagatedBuildInputs = [
    pyyaml
    jsonschema
    six
  ];

  meta = with lib; {
    homepage = "https://github.com/Yelp/swagger_spec_validator";
    license = licenses.asl20;
    description = "Validation of Swagger specifications";
    maintainers = with maintainers; [ vanschelven ];
  };
}


