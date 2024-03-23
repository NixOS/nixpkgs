{ lib
, fetchFromGitHub
, buildPythonPackage
, deprecation
, docker
, wrapt }:

buildPythonPackage rec {
  pname = "testcontainers";
  version = "4.0.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "testcontainers";
    repo = "testcontainers-python";
    rev = "refs/tags/testcontainers-v${version}";
    hash = "sha256-cVVP9nGRTLC09KHalQDz7KOszjuFVVpMlee4btPNgd4=";
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
