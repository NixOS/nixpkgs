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
  version = "0.11.9";

  src = fetchFromGitHub {
    owner = "killercup";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2anmuenywCdmPncsof2nD0xrerMFMP3yhTMXs+Qux0s=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cargo-test-macro-0.1.0" = "sha256-nlFhe1q0D60dljAi6pFNaz+ssju2Ymtx/PNUl5kJmWo=";
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
