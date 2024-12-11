{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
  stdenv,
  darwin,
}:

buildPythonPackage rec {
  pname = "zenoh";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-python";
    rev = version;
    hash = "sha256-LQ6zu0yD2heprN2p6zO/ZC6uIsMlc1FyDuZ/dvOnVqU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src pname version;
    hash = "sha256-6a2OSZLn1OYpe4tAv60uBhh/b+3QewPxVtQIDOnpk3A=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  buildInputs = lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  pythonImportsCheck = [
    "zenoh"
  ];

  meta = {
    description = "Python API for zenoh";
    homepage = "https://github.com/eclipse-zenoh/zenoh-python";
    license = with lib.licenses; [
      asl20
      epl20
    ];
    maintainers = with lib.maintainers; [ markuskowa ];
  };
}
