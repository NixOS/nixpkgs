{ lib, stdenv, callPackage, rustPlatform, fetchFromGitHub, fetchurl, nixosTests
, pkg-config, openssl
, libiconv, Security, CoreServices
, dbBackend ? "sqlite", libmysqlclient, postgresql }:

let
  webvault = callPackage ./webvault.nix {};
in

rustPlatform.buildRustPackage rec {
  pname = "vaultwarden";
  version = "1.28.1";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = pname;
    rev = version;
    hash = "sha256-YIR8if6lFJ+534qBN9k1ltFp5M7KBU5qYaI1KppTYwI=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = with lib; [ openssl ]
    ++ optionals stdenv.isDarwin [ libiconv Security CoreServices ]
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
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ msteen ivan ];
  };
}
