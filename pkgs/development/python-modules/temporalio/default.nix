{
  lib,
  buildPackages,
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
  version = "1.10.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "sdk-python";
    rev = "refs/tags/${version}";
    hash = "sha256-0y89P3+6n1Bi70uGQPCazPMiCexzFSFNu/yzwxAXNkI=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    sourceRoot = "${src.name}/${cargoRoot}";
    hash = "sha256-5UB8CjnkO7GF412ZC6AHq6MQFfHuI8mEYXNslrmYisY=";
  };

  cargoRoot = "temporalio/bridge";

  build-system = [
    poetry-core
  ];

  preBuild = ''
    export PROTOC=${buildPackages.protobuf}/bin/protoc
  '';

  dependencies = [
    protobuf
    types-protobuf
    typing-extensions
  ] ++ lib.optional (pythonOlder "3.11") python-dateutil;

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
    setuptools
    setuptools-rust
  ];

  pythonImportsCheck = [
    "temporalio"
    "temporalio.bridge.temporal_sdk_bridge"
    "temporalio.client"
    "temporalio.worker"
  ];

  meta = {
    description = "Temporal Python SDK";
    homepage = "https://temporal.io/";
    changelog = "https://github.com/temporalio/sdk-python/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jpds
      levigross
    ];
  };
}
