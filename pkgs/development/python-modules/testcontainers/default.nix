{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  poetry-core,

  # dependencies
  docker,
  python-dotenv,
  typing-extensions,
  urllib3,
  wrapt,
}:

buildPythonPackage rec {
  pname = "testcontainers";
  version = "4.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "testcontainers";
    repo = "testcontainers-python";
    tag = "testcontainers-v${version}";
    hash = "sha256-C3TWMf1u6RU9N7COL1DGgJQdvrpGnEWRgn9V0teyW/Q=";
  };

  patches = [
    # Bypass the socket address inference logic which fails in the nix sandbox:
    # docker.errors.DockerException: Error while fetching server API version: ('Connection aborted.', FileNotFoundError(2, 'No such file or directory'))
    # https://github.com/testcontainers/testcontainers-python/pull/832
    (fetchpatch {
      name = "fix-get-docker-socket";
      url = "https://github.com/testcontainers/testcontainers-python/pull/832/commits/a6bcc12153c17b2aa498148af8b9a8258d86476b.patch";
      hash = "sha256-qyFAf5Hvv6zxICh4zqO1nhAyNU30n3KAaRd3lEcZDgA=";
    })
  ];

  postPatch = ''
    echo "${version}" > VERSION
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
    changelog = "https://github.com/testcontainers/testcontainers-python/releases/tag/testcontainers-v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ onny ];
  };
}
