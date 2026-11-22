{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  buildPackages,
  pkg-config,
  zstd,

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
  version = "1.36.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "sdk-python";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-Ri8wvWkfhTJcaYWTb6+1IWOLbsVbW8USaWOXVLN/QGk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-Xe0mIsgHExd+jBiC6Pr9ld7NgZPSs5+eGdUkNfQdL2g=";
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
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  buildInputs = [ zstd ];

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
