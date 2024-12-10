{
  lib,
  stdenv,
  callPackage,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
  pkg-config,
  openssl,
  libiconv,
  Security,
  CoreServices,
  SystemConfiguration,
  dbBackend ? "sqlite",
  libmysqlclient,
  postgresql,
}:

let
  webvault = callPackage ./webvault.nix { };
in

rustPlatform.buildRustPackage rec {
  pname = "vaultwarden";
  version = "1.32.5";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = "vaultwarden";
    rev = version;
    hash = "sha256-n03SKzwtjPMm+OOUoI9PCnmiDVbrw/117uzfp18MwHc=";
  };

  cargoHash = "sha256-Cfk3pTIHauaAyTzjFUQQdvR0GxTU8k2etcx1LfPGGgg=";

  # used for "Server Installed" version in admin panel
  env.VW_VERSION = version;

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
      Security
      CoreServices
      SystemConfiguration
    ]
    ++ lib.optional (dbBackend == "mysql") libmysqlclient
    ++ lib.optional (dbBackend == "postgresql") postgresql;

  buildFeatures = dbBackend;

  passthru = {
    inherit webvault;
    tests = nixosTests.vaultwarden;
    updateScript = callPackage ./update.nix { };
  };

  meta = with lib; {
    description = "Unofficial Bitwarden compatible server written in Rust";
    homepage = "https://github.com/dani-garcia/vaultwarden";
    changelog = "https://github.com/dani-garcia/vaultwarden/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      dotlambda
      SuperSandro2000
    ];
    mainProgram = "vaultwarden";
  };
}
