<<<<<<< HEAD
{ lib, stdenv, callPackage, rustPlatform, fetchFromGitHub, nixosTests
=======
{ lib, stdenv, callPackage, rustPlatform, fetchFromGitHub, fetchurl, nixosTests
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pkg-config, openssl
, libiconv, Security, CoreServices
, dbBackend ? "sqlite", libmysqlclient, postgresql }:

let
  webvault = callPackage ./webvault.nix {};
in

rustPlatform.buildRustPackage rec {
  pname = "vaultwarden";
<<<<<<< HEAD
  version = "1.29.2";
=======
  version = "1.28.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-ByMPS68GBOvjB/RpoLAvgE+NcbbIa1qfU1TQ4yhbH+I=";
=======
    hash = "sha256-YIR8if6lFJ+534qBN9k1ltFp5M7KBU5qYaI1KppTYwI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
<<<<<<< HEAD
    outputHashes = {
      "rocket-0.5.0-rc.3" = "sha256-E71cktkHCbmQyjkjWWJ20KfCm3B/h3jQ2TMluYhvCQw=";
    };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
