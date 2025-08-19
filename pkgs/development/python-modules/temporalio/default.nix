{
  lib,
  buildPackages,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  maturin,
  nexusrpc,
  nix-update-script,
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
  version = "1.15.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "sdk-python";
    rev = "refs/tags/${version}";
    hash = "sha256-NY7+ryldTV60K1Ky9Q1iNEmXqXlZgSMEE4f6PGeZ5BE=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-Z0LxIGY7af1tcRTcMe4FDCH1zxzX1J9AJuZfZUMAAUI=";
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

  passthru.updateScript = nix-update-script { };

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
