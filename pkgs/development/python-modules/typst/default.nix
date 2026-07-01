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
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "messense";
    repo = "typst-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9wHUikOf/WULPaGkCOXa0aXcSme+xbweC6IDwaJnwRk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-TyLKnJUVbodCHQXhpjIr1numNDmeUkvpsKH1o5tWFCM=";
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
    changelog = "https://github.com/messense/typst-py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
