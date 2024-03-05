{ lib, stdenv, callPackage, rustPlatform, fetchFromGitHub, nixosTests
, pkg-config, openssl
, libiconv, Security, CoreServices, SystemConfiguration
, dbBackend ? "sqlite", libmysqlclient, postgresql }:

let
  webvault = callPackage ./webvault.nix {};
in

rustPlatform.buildRustPackage rec {
  pname = "vaultwarden";
  version = "1.30.3";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = pname;
    rev = version;
    hash = "sha256-vUAgW/kTFO9yzWFIWqM1f6xEZYH8ojIdt2eOhP9ID8g=";
  };

  cargoHash = "sha256-+FmVkemZTlFOf+fnTJED3u13pXeAuP/wIvEb96Vwa6I=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = with lib; [ openssl ]
    ++ optionals stdenv.isDarwin [ libiconv Security CoreServices SystemConfiguration ]
    ++ optional (dbBackend == "mysql") libmysqlclient
    ++ optional (dbBackend == "postgresql") postgresql;

  buildFeatures = dbBackend;

  passthru = {
    inherit webvault;
    tests = nixosTests.vaultwarden;
    updateScript = callPackage ./update.nix {};
  };

  meta = with lib; {
    description = "Unofficial Bitwarden compatible server written in Rust";
    homepage = "https://github.com/dani-garcia/vaultwarden";
    changelog = "https://github.com/dani-garcia/vaultwarden/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ SuperSandro2000 ivan ];
    mainProgram = "vaultwarden";
  };
}
