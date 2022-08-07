{ lib, rustPlatform, fetchFromGitHub, libiconv, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    rev = version;
    sha256 = "sha256-IwtAd8qhG7FgnC7esipwAbSssVKIirB6GCedgNRPabo=";
  };

  sourceRoot = "source/cargo-insta";
  cargoSha256 = "sha256-asWf+wIOpbZx9YOw5c4prg2D6FSRCTcc5FgWY93MNII=";
  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  meta = with lib; {
    description = "A Cargo subcommand for snapshot testing";
    homepage = "https://github.com/mitsuhiko/insta";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ oxalica ];
  };
}
