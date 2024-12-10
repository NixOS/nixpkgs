{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "ua-parser-rs";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "ua-parser";
    repo = "uap-rust";
    rev = "refs/tags/ua-parser-rs-${version}";
    hash = "sha256-+qAYNGZFOkQyHhzqZZGrxgKHrPTWolO/4KKuppIMSRE=";
    fetchSubmodules = true;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  buildAndTestSubdir = "ua-parser-py";

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  meta = {
    description = "Native accelerator for ua-parser";
    homepage = "https://github.com/ua-parser/uap-rust/tree/main/ua-parser-py";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
    mainProgram = "ua-parser-rs";
  };
}
