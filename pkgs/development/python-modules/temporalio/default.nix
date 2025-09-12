{
  lib,
  buildPackages,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  maturin,
  nexusrpc,
  nix-update-script,
  nixosTests,
  pythonOlder,
  poetry-core,
  protobuf5,
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
  version = "1.17.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "sdk-python";
    rev = "refs/tags/${version}";
    hash = "sha256-uxjZ3aINVP4g5UTzhGW7H/7dyaZlAqBuXH9uVS1zax0=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-yE5mShJ++Zx+5AwsotGn20b7dC6BEbTiIy1xST9du+U=";
  };

  cargoRoot = "temporalio/bridge";

  build-system = [
    maturin
    poetry-core
  ];

  preBuild = ''
    export PROTOC=${buildPackages.protobuf}/bin/protoc
  '';

  dependencies = [
    nexusrpc
    protobuf5
    types-protobuf
    typing-extensions
  ]
  ++ lib.optional (pythonOlder "3.11") python-dateutil;

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
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

  passthru = {
    tests = { inherit (nixosTests) temporal; };
    updateScript = nix-update-script { };
  };

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
