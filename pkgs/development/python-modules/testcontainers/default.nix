{ lib
, fetchFromGitHub
, buildPythonPackage
, deprecation
, docker
, wrapt }:

buildPythonPackage rec {
  pname = "testcontainers";
  version = "3.7.1";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "testcontainers";
    repo = "testcontainers-python";
    rev = "v${version}";
    hash = "sha256-OHuvUi5oa0fVcfo0FW9XwaUp52MEH4NTM6GqK4ic0oM=";
  };

  postPatch = ''
    echo "${version}" > VERSION
  '';

  buildInputs = [
    deprecation
    docker
    wrapt
  ];

  # Tests require various container and database services running
  doCheck = false;

  pythonImportsCheck = [
    "testcontainers"
  ];

  meta = with lib; {
    description = ''
      Allows using docker containers for functional and integration testing
    '';
    homepage = "https://github.com/testcontainers/testcontainers-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
  };
}
