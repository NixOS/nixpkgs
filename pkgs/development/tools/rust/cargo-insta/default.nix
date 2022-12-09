{ lib, rustPlatform, fetchFromGitHub, libiconv, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    rev = version;
    sha256 = "sha256-tzC5AOlms5UDQ8+L7M2Tb5K/RtjZuDs23JSnLGH6pkI=";
  };

  sourceRoot = "source/cargo-insta";
  cargoSha256 = "sha256-9r/RPzjPzDSRamntfu8Xz4XWieAU/bnw2m9wtzwkcwk=";
  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  meta = with lib; {
    description = "A Cargo subcommand for snapshot testing";
    homepage = "https://github.com/mitsuhiko/insta";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ oxalica ];
  };
}
