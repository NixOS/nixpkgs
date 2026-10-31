{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  rustPlatform,
  pkg-config,
  openssl,
}:
buildPythonPackage (finalAttrs: {
  pname = "tikv-client";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tikv";
    repo = "client-py";
    tag = finalAttrs.version;
    hash = "sha256-/Q8fuGBaPpLpGRIHcIfAKtk0d03HW34LBgWvLRzlyIU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-HC1KUg3r6nX2PhetPUKFduERTNKgG5dxsxi1sDOmDsE=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  env = {
    RUSTC_BOOTSTRAP = true;
    OPENSSL_NO_VENDOR = true;
  };

  meta = {
    description = "TiKV client in Python, supporting both synchronous and asynchronous API";
    maintainers = [ lib.maintainers.definfo ];
    license = lib.licenses.asl20;
  };
})
