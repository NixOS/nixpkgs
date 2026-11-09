{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
}:

buildPythonPackage (finalAttrs: {
  pname = "eclipse-zenoh";
  version = "1.10.2"; # nixpkgs-update: no auto update
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-python";
    tag = finalAttrs.version;
    hash = "sha256-9S1ZwnMRHYl3ms/E8+Sv6oYJdKnvb+Kb0egU1zA1OuE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src pname version;
    hash = "sha256-GZd8iJwyQYeusRCbsu3rvDbXQVHTjRNnuelPDos4HWI=";
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
})
