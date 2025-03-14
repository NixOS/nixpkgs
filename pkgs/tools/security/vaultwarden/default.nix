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
  libpq,
}:

let
  webvault = callPackage ./webvault.nix { };
in

rustPlatform.buildRustPackage rec {
  pname = "vaultwarden";
  version = "1.33.2";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = "vaultwarden";
    rev = version;
    hash = "sha256-Lu3/qVTi5Eedcm+3XlHAAJ1nPHm9hW4HZncQKmzDdoo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-T/ehLSPJmEuQYhotK12iqXQSe5Ke8+dkr9PVDe4Kmis=";

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
    ++ lib.optional (dbBackend == "postgresql") libpq;

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
