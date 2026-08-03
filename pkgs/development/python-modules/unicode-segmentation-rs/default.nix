{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "unicode-segmentation-rs";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "unicode-segmentation-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZX4JSS2frZ/Ui6LXP7sEIwkdnNfEQQDltN/3OfYPOW8=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/WeblateOrg/unicode-segmentation-rs/commit/cf13e4ef688a3ab512f4f0edb78a939e991a0648.patch";
      hash = "sha256-ZC7lAagV+VHRjZmGzRzTOE9m7zklMQNfpULCZD2Kwm4=";
    })
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src patches;
    hash = "sha256-5G8DyfNK4/AaiJndc8GaCSCg4yEueLG34f2cmO1ChCw=";
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
