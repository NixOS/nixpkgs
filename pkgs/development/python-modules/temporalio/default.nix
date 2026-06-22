{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  buildPackages,

  # build-system
  maturin,

  # dependencies
  nexusrpc,
  protobuf,
  types-protobuf,
  typing-extensions,

  # nativeBuildInputs
  cargo,
  rustc,

  # passthru
  nixosTests,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "temporalio";
  version = "1.29.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "sdk-python";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-A92qKOnoOf8D3YO+NOo7s2UwjsFmOG+m7FyASPJtn4U=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-ER3iSeBQp5N934VrZCe3J9IMJ53EByIfXOu6MJT2PY4=";
  };

  cargoRoot = "temporalio/bridge";

  build-system = [
    maturin
  ];

  env.PROTOC = "${lib.getExe buildPackages.protobuf}";

  dependencies = [
    nexusrpc
    protobuf
    types-protobuf
    typing-extensions
  ];

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  pythonRelaxDeps = [
    "protobuf"
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
