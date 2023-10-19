{ lib, stdenv, callPackage, rustPlatform, fetchFromGitHub, nixosTests
, pkg-config, openssl
, libiconv, Security, CoreServices
, dbBackend ? "sqlite", libmysqlclient, postgresql }:

let
  webvault = callPackage ./webvault.nix {};
in

rustPlatform.buildRustPackage rec {
  pname = "vaultwarden";
  version = "1.29.2";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = pname;
    rev = version;
    hash = "sha256-ByMPS68GBOvjB/RpoLAvgE+NcbbIa1qfU1TQ4yhbH+I=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rocket-0.5.0-rc.3" = "sha256-E71cktkHCbmQyjkjWWJ20KfCm3B/h3jQ2TMluYhvCQw=";
    };
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
