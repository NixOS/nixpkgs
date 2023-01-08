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
  version = "unstable-2023-01-08";

  src = fetchFromGitHub {
    owner = "guppy-rs";
    repo = "guppy";
    rev = "81753212702ca2b11b65ac8b98db6c9e4f4d278f";
    sha256 = "sha256-fCZlnE+/U+Z+X9n6x6qWHxODH5ESV0cM+hwxeyUZs6c=";
  };

  cargoSha256 = "sha256-H2voc37Ywmi8oy15UY9J3hW6sbqc3RZuelxWJxrwZKg=";

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
