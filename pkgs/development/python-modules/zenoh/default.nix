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
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-python";
    rev = version;
    hash = "sha256-N82KcLMYTOzkeFR6NLNR/g4MDjXk2aZRaAVMggXKwf0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src pname version;
    hash = "sha256-5JdqANf5roFY3J+iPxg+WhmAyTWARhgav+/jt7rttqg=";
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
