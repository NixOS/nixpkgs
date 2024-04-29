{ lib
, authlib
, buildPythonPackage
, fetchPypi
, grpcio
, grpcio-health-checking
, grpcio-tools
, httpx
, pydantic
, pythonOlder
, pythonRelaxDepsHook
, setuptools-scm
, tqdm
, validators
}:

buildPythonPackage rec {
  pname = "weaviate-client";
  version = "4.5.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gElboFIwEMiwN6HhpPPT+tcmh0pMiDjq7R8TG2eMMKI=";
  };

  pythonRelaxDeps = [
    "httpx"
    "validators"
  ];

  build-system = [
    setuptools-scm
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

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

  pythonImportsCheck = [
    "weaviate"
  ];

  meta = with lib; {
    description = "Python native client for easy interaction with a Weaviate instance";
    homepage = "https://github.com/weaviate/weaviate-python-client";
    changelog = "https://github.com/weaviate/weaviate-python-client/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
