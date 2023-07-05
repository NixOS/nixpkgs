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
  version = "unstable-2023-06-26";

  src = fetchFromGitHub {
    owner = "guppy-rs";
    repo = "guppy";
    rev = "c05b95997a127cebef76d3b238e0341086e59e32";
    sha256 = "sha256-CQ0bpc5pmPMQMQ+8mcrUwo19zqyfkk5pE/lWRr9azXs=";
  };

  cargoSha256 = "sha256-OHtg3za8EyQVYQ6XQzLK7UgvGSl8ObfeKURFL6vBDnE=";

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
