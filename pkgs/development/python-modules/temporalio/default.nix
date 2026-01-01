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
  pythonOlder,
  python-dateutil,

  # nativeBuildInputs
  cargo,
  rustc,

  # passthru
  nixosTests,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "temporalio";
<<<<<<< HEAD
  version = "1.21.1";
=======
  version = "1.20.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "sdk-python";
    tag = version;
    fetchSubmodules = true;
<<<<<<< HEAD
    hash = "sha256-eOhaT5phQdHpaZB+TefJObAWgrO3vLgFkjH0XZW4rWU=";
=======
    hash = "sha256-JScwBcVkl5kAxO4zKmt1ab6b1KlhGmPSjr7O0PRu0p8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      cargoRoot
      ;
<<<<<<< HEAD
    hash = "sha256-d/mrBcItzKCQx27HyZ2q4f9r/XI0oXc+M7Hwfm98csc=";
=======
    hash = "sha256-vhoXn4Aur4/VSwM2qVxOiWEI5/zAmep9ViQMGLln9PU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
  ]
  ++ lib.optional (pythonOlder "3.11") python-dateutil;

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
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
