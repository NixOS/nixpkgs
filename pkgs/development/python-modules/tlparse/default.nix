{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "tlparse";
  version = "0.4.8";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "meta-pytorch";
    repo = "tlparse";
    tag = "v${version}";
    hash = "sha256-qqMhuMM9P32HqPzdTYeRwvmh3zpBOPdxNy/p1RQizVE=";
  };

  cargoHash = "sha256-q5JaOacChdg57dBL5vQjYd1ht2fBBYnw6+RFIWXYfkY=";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = cargoHash;
  };

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  # Run `cargo check` as integration test
  passthru.tests.integration = rustPlatform.buildRustPackage {
    inherit
      pname
      version
      src
      cargoHash
      ;
  };

  meta = {
    description = "Top-level parser for PyTorch profiler and autograd traces";
    homepage = "https://github.com/meta-pytorch/tlparse";
    changelog = "https://github.com/meta-pytorch/tlparse/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jherland ];
    mainProgram = "tlparse";
  };
}
