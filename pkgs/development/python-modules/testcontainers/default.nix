{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  docker,
  python-dotenv,
  typing-extensions,
  urllib3,
  wrapt,
}:

buildPythonPackage (finalAttrs: {
  pname = "testcontainers";
  version = "4.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "testcontainers";
    repo = "testcontainers-python";
    tag = "testcontainers-v${finalAttrs.version}";
    hash = "sha256-Zquh1tY9Z2BU6BPsEGR4eBjcHVB4KsxOQ81Tk6YTyTQ=";
  };

  postPatch = ''
    echo "${finalAttrs.version}" > VERSION
  '';

  build-system = [ poetry-core ];

  dependencies = [
    docker
    typing-extensions
    python-dotenv
    urllib3
    wrapt
  ];

  # Tests require various container and database services running
  doCheck = false;

  pythonImportsCheck = [
    "testcontainers"
    "testcontainers.core.container"
  ];

  meta = {
    description = "Allows using docker containers for functional and integration testing";
    homepage = "https://github.com/testcontainers/testcontainers-python";
    changelog = "https://github.com/testcontainers/testcontainers-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ onny ];
  };
})
