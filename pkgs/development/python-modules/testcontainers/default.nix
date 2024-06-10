{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  deprecation,
  docker,
  wrapt,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "testcontainers";
  version = "4.5.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "testcontainers";
    repo = "testcontainers-python";
    rev = "refs/tags/testcontainers-v${version}";
    hash = "sha256-7QlT3ibSUDeC+aWi2MCagLkomXG3/VU1xHQ7Xgoh/Pw=";
  };

  postPatch = ''
    echo "${version}" > VERSION
  '';

  build-system = [ poetry-core ];

  buildInputs = [
    deprecation
    docker
    wrapt
  ];

  dependencies = [ typing-extensions ];

  # Tests require various container and database services running
  doCheck = false;

  pythonImportsCheck = [ "testcontainers" ];

  meta = {
    description = "Allows using docker containers for functional and integration testing";
    homepage = "https://github.com/testcontainers/testcontainers-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ onny ];
  };
}
