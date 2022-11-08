{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-guppy";
  version = "unstable-2022-11-07";

  src = fetchFromGitHub {
    owner = "guppy-rs";
    repo = "guppy";
    rev = "40d66ee25a12657c36b9cef67293fc4c296a144f";
    sha256 = "sha256-f+xUifb7TlaXONNQfFZpnuYDTxgkelL+Knc+X8vc3Gg=";
  };

  cargoSha256 = "sha256-qRFJJX/5hgveGAQtW0HJYAPZjHRlTHalvqSRdEjtYiU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  cargoBuildFlags = [ "-p" "cargo-guppy" ];
  cargoTestFlags = [ "-p" "cargo-guppy" ];

  meta = with lib; {
    description = "A command-line frontend for guppy";
    homepage = "https://github.com/guppy-rs/guppy/tree/main/cargo-guppy";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
