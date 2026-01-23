{
  lib,
  stdenv,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustc,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "typst";
  version = "0.14.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "messense";
    repo = "typst-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GhXsfsJieBMKvHji4YGfZtvGMIa3k353Erb7V8RSDkU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-A/iNQifMjpAMdoiEF3GaBe74mfsv8i/EwQL+ZmMc1YM=";
  };

  build-system = [
    cargo
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  buildInputs = [ openssl ];

  pythonImportsCheck = [ "typst" ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Python binding to typst";
    homepage = "https://github.com/messense/typst-py";
    changelog = "https://github.com/messense/typst-py/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
