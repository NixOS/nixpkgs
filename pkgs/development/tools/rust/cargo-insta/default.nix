{ lib, rustPlatform, fetchFromGitHub, libiconv, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    rev = version;
    sha256 = "sha256-h0jRuY3GSqK85NCeFqdqjyVdNTMbdtD70zU5G3w1STc=";
  };

  sourceRoot = "source/cargo-insta";
  cargoHash = "sha256-GC2ggTJJV3Aww3qPfsnuND0eII1l3OBoZfi5RtvhO8I=";
  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  meta = with lib; {
    description = "A Cargo subcommand for snapshot testing";
    homepage = "https://github.com/mitsuhiko/insta";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ oxalica ];
  };
}
