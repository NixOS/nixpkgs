{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, zlib
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-edit";
<<<<<<< HEAD
  version = "0.12.2";
=======
  version = "0.11.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "killercup";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-tMYuhUb1e/wTMZGwrAa3bz3INAld/ZtQzJqpeG0w/G8=";
=======
    hash = "sha256-pxlwCeGOH0uqPdDJ7zIXFIRBuHwyByZ5r1VWzluvz10=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
<<<<<<< HEAD
      "cargo-test-macro-0.1.0" = "sha256-yE8BJMTRBT3P29t5ygMCybs0CYDcFLVlxi1L0LkBV9Q=";
=======
      "cargo-test-macro-0.1.0" = "sha256-nlFhe1q0D60dljAi6pFNaz+ssju2Ymtx/PNUl5kJmWo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl zlib ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  doCheck = false; # integration tests depend on changing cargo config

  meta = with lib; {
    description = "A utility for managing cargo dependencies from the command line";
    homepage = "https://github.com/killercup/cargo-edit";
    changelog = "https://github.com/killercup/cargo-edit/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ Br1ght0ne figsoda gerschtli jb55 killercup ];
  };
}
