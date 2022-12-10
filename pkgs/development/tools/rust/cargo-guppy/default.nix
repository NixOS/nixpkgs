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
  version = "unstable-2022-12-05";

  src = fetchFromGitHub {
    owner = "guppy-rs";
    repo = "guppy";
    rev = "4dad33053d3047293da35ade33158b709fe8bb23";
    sha256 = "sha256-CWyXNBBo+yyF2s6BT6FFu6CI7xId38vsyg0uSezsusc=";
  };

  cargoSha256 = "sha256-jwfZ5FH2qlzmxKT9LTXkmvwL5fhKljUPYwYXXqDRDXc=";

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
