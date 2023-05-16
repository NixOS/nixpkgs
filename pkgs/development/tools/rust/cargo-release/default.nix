{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
<<<<<<< HEAD
, libgit2
=======
, libgit2_1_5
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, openssl
, stdenv
, curl
, darwin
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-release";
<<<<<<< HEAD
  version = "0.24.12";
=======
  version = "0.24.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "cargo-release";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-dB5gpaY6OB/IjMvqLUMH41l6Q/xMookxfVGXRcdhcBM=";
=======
    hash = "sha256-3kOis5C0XOdp0CCCSZ8PoGtePqW7ozwzSTA9TGe7kAg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
<<<<<<< HEAD
      "cargo-test-macro-0.1.0" = "sha256-jXWdCc3wxcF02uL2OyMepJ+DmINAHRYtAUH6L16bCjI=";
=======
      "cargo-test-macro-0.1.0" = "sha256-nlFhe1q0D60dljAi6pFNaz+ssju2Ymtx/PNUl5kJmWo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
<<<<<<< HEAD
    libgit2
=======
    libgit2_1_5
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    curl
    darwin.apple_sdk.frameworks.Security
  ];

  nativeCheckInputs = [
    git
  ];

  # disable vendored-libgit2 and vendored-openssl
  buildNoDefaultFeatures = true;

  meta = with lib; {
    description = ''Cargo subcommand "release": everything about releasing a rust crate'';
    homepage = "https://github.com/crate-ci/cargo-release";
    changelog = "https://github.com/crate-ci/cargo-release/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda gerschtli ];
  };
}
