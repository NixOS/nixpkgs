{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
  setuptools-rust,
  poetry-core,
  pythonOlder,
  protobuf,
  buildPackages,
  types-protobuf,
  typing-extensions,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "temporalio";
  version = "1.10.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "sdk-python";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-0y89P3+6n1Bi70uGQPCazPMiCexzFSFNu/yzwxAXNkI=";
  };

  build-system = [ poetry-core ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    sourceRoot = "${src.name}/${cargoRoot}";
    hash = "sha256-5UB8CjnkO7GF412ZC6AHq6MQFfHuI8mEYXNslrmYisY=";
  };

  cargoRoot = "temporalio/bridge";

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
    setuptools-rust
    protobuf
  ];
  preBuild = ''
    export PROTOC=${buildPackages.protobuf}/bin/protoc
  '';

  dependencies = [
    protobuf
    types-protobuf
    typing-extensions
  ];
  pythonImportsCheck = [
    "temporalio"
    "temporalio.bridge.temporal_sdk_bridge" # Check that the binary module imports
  ];

  meta = {
    description = "Temporal Python SDK is the framework for authoring workflows and activities using the Python programming language.";
    homepage = "https://github.com/temporalio/sdk-python";
    changelog = "https://github.com/temporalio/sdk-python/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ levigross ];
  };
}
