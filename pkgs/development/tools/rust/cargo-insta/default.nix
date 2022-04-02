{ lib, rustPlatform, fetchFromGitHub, libiconv, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    rev = version;
    sha256 = "sha256-cSQEwsUqn+Q0ZWndBVatHL0btO7xLOJWO+MMjtSL0Zo=";
  };

  sourceRoot = "source/cargo-insta";
  cargoSha256 = "sha256-rn4ln/MeaDAQmWpxeTn3mGH4sEvO4876o1VPYiz/CR8=";
  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  meta = with lib; {
    description = "A Cargo subcommand for snapshot testing";
    homepage = "https://github.com/mitsuhiko/insta";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ oxalica ];
  };
}
