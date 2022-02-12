{ lib, rustPlatform, fetchFromGitHub, libiconv, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    rev = version;
    sha256 = "sha256-Vi3FwetCpL8qMniaXypw1EYVHh6lfZu6GjDXPDKda5c=";
  };

  sourceRoot = "source/cargo-insta";
  cargoSha256 = "sha256-Bjh9we0OD8kqMJtovO1yw9Yta5u93dlYMRsxPdErkaY=";
  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  meta = with lib; {
    description = "A Cargo subcommand for snapshot testing";
    homepage = "https://github.com/mitsuhiko/insta";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ oxalica ];
  };
}
