{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
}:

buildPythonPackage rec {
  pname = "zenoh";
  version = "1.4.0"; # nixpkgs-update: no auto update
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-python";
    rev = version;
    hash = "sha256-X9AUjuJYA8j41JVS+ZLRYcQUzSRoGwmkNIH0UK5+QoU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src pname version;
    hash = "sha256-Z6Wtor/aAdO1JUUafFEo9RdI7OXmsAD5MMtMUF6CZEg=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

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
