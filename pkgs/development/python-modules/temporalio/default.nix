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
  version = "1.18.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "sdk-python";
    rev = "refs/tags/${version}";
    hash = "sha256-uFcy348o4e7DZ+12Lc52wfANFHYCyMfLL/clhRsdkcI=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-2/AH8ffSRXBrzF2G9n8MdJfbOrSnSVPRfB1fDm8wFU0=";
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
