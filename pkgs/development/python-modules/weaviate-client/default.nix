{
  lib,
  authlib,
  buildPythonPackage,
  fetchFromGitHub,
  grpcio,
  grpcio-health-checking,
  grpcio-tools,
  httpx,
  pydantic,
  pythonOlder,
  setuptools-scm,
  tqdm,
  validators,
}:

buildPythonPackage rec {
  pname = "weaviate-client";
  version = "4.7.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "weaviate";
    repo = "weaviate-python-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-JgnasbhAcdJwa3lpdID+B3Iwuc9peRQZBAC7tBBm54c=";
  };

  pythonRelaxDeps = [
    "httpx"
    "validators"
  ];

  build-system = [ setuptools-scm ];


  dependencies = [
    authlib
    grpcio
    grpcio-health-checking
    grpcio-tools
    httpx
    pydantic
    tqdm
    validators
  ];

  doCheck = false;

  pythonImportsCheck = [ "weaviate" ];

  meta = with lib; {
    description = "Python native client for easy interaction with a Weaviate instance";
    homepage = "https://github.com/weaviate/weaviate-python-client";
    changelog = "https://github.com/weaviate/weaviate-python-client/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
