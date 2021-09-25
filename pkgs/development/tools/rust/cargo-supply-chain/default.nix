{ lib, rustPlatform, fetchCrate, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-supply-chain";
  version = "0.2.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-zjDZJOUjnEQ03rmo5CdSY1emE6YohOPlf7SKuvNLuV0=";
  };

  cargoSha256 = "sha256-xSJ5rx8k+my0NeGYHZyvDzbM7uMdbViT7Ou9a9JACfs=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Gather author, contributor and publisher data on crates in your dependency graph";
    homepage = "https://github.com/rust-secure-code/cargo-supply-chain";
    changelog = "https://github.com/rust-secure-code/cargo-supply-chain/blob/master/CHANGELOG.md";
    license = with licenses; [ asl20 mit zlib ]; # any of three
    maintainers = with maintainers; [ figsoda ];
  };
}
