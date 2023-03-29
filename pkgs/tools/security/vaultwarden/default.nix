{ lib, stdenv, callPackage, rustPlatform, fetchFromGitHub, fetchurl, nixosTests
, pkg-config, openssl
, libiconv, Security, CoreServices
, dbBackend ? "sqlite", libmysqlclient, postgresql }:

let
  webvault = callPackage ./webvault.nix {};
in

rustPlatform.buildRustPackage rec {
  pname = "vaultwarden";
  version = "1.28.0";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = pname;
    rev = version;
    hash = "sha256-ML5eblQUk4xMYbBeLxk9tNxi7N4ltrCjMG0oM9zL6JI=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = with lib; [ openssl ]
    ++ optionals stdenv.isDarwin [ libiconv Security CoreServices ]
    ++ optional (dbBackend == "mysql") libmysqlclient
    ++ optional (dbBackend == "postgresql") postgresql;

  # vaultwarden depends on rocket v0.5.0-dev, which requires nightly features.
  # This may be removed if https://github.com/dani-garcia/vaultwarden/issues/712 is fixed.
  RUSTC_BOOTSTRAP = 1;

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
