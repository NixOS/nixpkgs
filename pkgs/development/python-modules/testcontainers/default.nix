{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, deprecation
, docker
, wrapt
, typing-extensions
}:

buildPythonPackage rec {
  pname = "testcontainers";
  version = "4.4.1";
  disabled = pythonOlder "3.9";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "testcontainers";
    repo = "testcontainers-python";
    rev = "refs/tags/testcontainers-v${version}";
    hash = "sha256-osWppbptWpBSHcrHlAqNpn6j2n/qQ7iCobH3TVqB2bc=";
  };

  postPatch = ''
    echo "${version}" > VERSION
  '';

  build-system = [
    poetry-core
  ];

  buildInputs = [
    deprecation
    docker
    wrapt
  ];

  dependencies = [
    typing-extensions
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
