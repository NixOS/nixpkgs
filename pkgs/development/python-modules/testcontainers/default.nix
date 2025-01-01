{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # buildInputs
  deprecation,
  docker,
  wrapt,

  # dependencies
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "testcontainers";
  version = "4.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "testcontainers";
    repo = "testcontainers-python";
    rev = "refs/tags/testcontainers-v${version}";
    hash = "sha256-UCT0AmpDWMiAeRuW4BadZl4cJFCQPDogHOSkTYi/tqM=";
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
    changelog = "https://github.com/testcontainers/testcontainers-python/releases/tag/testcontainers-v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ onny ];
  };
}
