{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "unicode-segmentation-rs";
  version = "0.3.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "unicode-segmentation-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GJj6+ppNYjwN9gmFAerr7UTZCAvF31wSr9xnXidEdWs=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    hash = "sha256-Uc9AlwOImk8UpwSq1r92APCWsrwJyI8WFUtqpgWkXE4=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "unicode_segmentation_rs" ];

  meta = {
    description = "Python bindings for the Rust unicode-segmentation and unicode-width crates";
    homepage = "https://github.com/WeblateOrg/unicode-segmentation-rs/";
    changelog = "https://github.com/WeblateOrg/unicode-segmentation-rs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erictapen ];
  };
})
