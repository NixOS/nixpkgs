{ lib, buildPythonPackage, fetchFromGitHub, pyyaml, jsonschema, six, pytest, mock, isPy3k }:

buildPythonPackage rec {
  pname = "swagger-spec-validator";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "Yelp";
    repo = "swagger_spec_validator";
    rev = "v" + version;
    sha256 = "0qlkiyncdh7cdyjvnwjpv9i7y75ghwnpyqkkpfaa8hg698na13pw";
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


