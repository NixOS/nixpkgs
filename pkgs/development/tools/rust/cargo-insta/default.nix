{ lib, rustPlatform, fetchFromGitHub, libiconv, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    rev = version;
    sha256 = "sha256-kTICdLL3paJIj779w4i7QUzhdynzyjo+YjtBorJsms4=";
  };

  sourceRoot = "source/cargo-insta";
  cargoSha256 = "sha256-Hfjz3arOvRbMIvV3o60zjRB2p4JbBUFPj66OpHZdIJg=";
  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  meta = with lib; {
    description = "A Cargo subcommand for snapshot testing";
    homepage = "https://github.com/mitsuhiko/insta";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ oxalica ];
  };
}
