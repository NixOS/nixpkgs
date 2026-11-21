{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  writableTmpDirAsHomeHook,
  numpy,
  scipy,
  pytestCheckHook,
  apple-sdk_15,
}:

buildPythonPackage (finalAttrs: {
  pname = "sparta-solver";
  version = "0.3.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FennisRobert";
    repo = "SPARTA";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jONxtT8aiuujfAG6yT2iAj+YGhvSGBAuoIvbWK3OFFQ=";
  };

  cargoRoot = "python";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-Us3ufIqQ78j9IddL3A3tcXytF4NEUG7WCw/RSSH9KCg=";
  };

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
  ];

  dependencies = [
    numpy
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sparta"
  ];

  meta = {
    description = "Sparse direct solver for finite-element problems";
    homepage = "https://github.com/FennisRobert/SPARTA";
    license = lib.licenses.agpl3Plus;
    # dependency of emerge
    teams = with lib.teams; [ ngi ];
  };
})
