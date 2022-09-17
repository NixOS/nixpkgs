{ lib, rustPlatform, fetchFromGitHub, libiconv, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
  version = "1.18.1";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    rev = version;
    sha256 = "sha256-yTzLEV4yP6It4KrUPdTgIJrocW+VToOeyaSvOSQRVMU=";
  };

  sourceRoot = "source/cargo-insta";
  cargoSha256 = "sha256-y9o2sNiDIYKzrsgG+tA17PswR6DZn7ms8n5EG/J9oOU=";
  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  meta = with lib; {
    description = "A Cargo subcommand for snapshot testing";
    homepage = "https://github.com/mitsuhiko/insta";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ oxalica ];
  };
}
