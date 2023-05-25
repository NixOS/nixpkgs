{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2_1_5
, openssl
, stdenv
, curl
, darwin
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-release";
  version = "0.24.10";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "cargo-release";
    rev = "refs/tags/v${version}";
    hash = "sha256-3kOis5C0XOdp0CCCSZ8PoGtePqW7ozwzSTA9TGe7kAg=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cargo-test-macro-0.1.0" = "sha256-nlFhe1q0D60dljAi6pFNaz+ssju2Ymtx/PNUl5kJmWo=";
    };
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2_1_5
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
