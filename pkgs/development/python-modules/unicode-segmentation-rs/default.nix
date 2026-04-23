{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  rustPlatform,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "unicode-segmentation-rs";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "unicode-segmentation-rs";
    tag = "v${version}";
    hash = "sha256-c/KWCJz8ZbWWE7S+2Uxp3+eQWHXAEZXcVN3C5OrFlrc=";
  };

  postPatch = ''
    ln -s '${./Cargo.lock}' Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "unicode_segmentation_rs" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--generate-lockfile"
    ];
  };

  meta = {
    description = "Python bindings for the Rust unicode-segmentation and unicode-width crates";
    homepage = "https://github.com/WeblateOrg/unicode-segmentation-rs/";
    changelog = "https://github.com/WeblateOrg/unicode-segmentation-rs/releases/tag/${src.tag}";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ erictapen ];
  };
}
