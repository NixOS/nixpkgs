{
  lib,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  pythonOlder,
  poetry-core,
  protobuf,
  python-dateutil,
  rustc,
  rustPlatform,
  setuptools,
  setuptools-rust,
  types-protobuf,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "temporalio";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "sdk-python";
    rev = "refs/tags/${version}";
    hash = "sha256-3rQLBgBViCW0qmQ2tkvaafIPOugja9uhEu6dMXoDM1Y=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "opentelemetry-prometheus-0.17.0" = "sha256-KjPqfxnXoxVKZ63nL8v7yKr7KN6z0ZoChuTZpjVV0cI=";
    };
  };

  cargoRoot = "temporalio/bridge";

  build-system = [
    poetry-core
    setuptools
    setuptools-rust
  ];

  dependencies = [
    protobuf
    types-protobuf
    typing-extensions
  ] ++ lib.optional (pythonOlder "3.11") python-dateutil;

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
  ];

  pythonImportsCheck = [
    "temporalio"
    "temporalio.client"
    "temporalio.worker"
  ];

  meta = {
    description = "Temporal Python SDK";
    homepage = "https://temporal.io/";
    changelog = "https://github.com/temporalio/sdk-python/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jpds ];
  };
}
