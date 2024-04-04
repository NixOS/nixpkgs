{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, deprecation
, docker
, wrapt
}:

buildPythonPackage rec {
  pname = "testcontainers";
  version = "4.3.1";
  disabled = pythonOlder "3.9";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "testcontainers";
    repo = "testcontainers-python";
    rev = "refs/tags/testcontainers-v${version}";
    hash = "sha256-pS5YEcHDHpTIWLD4vMPWL4r86DOI+47jN7cTwhDeXHE=";
  };

  postPatch = ''
    echo "${version}" > VERSION
  '';

  nativeBuildInputs = [
    poetry-core
  ];

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
