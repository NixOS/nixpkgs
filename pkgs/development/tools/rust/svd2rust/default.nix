{ lib, rustPlatform, fetchCrate, stdenv, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.24.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-P0s2mrfYA7DUThvje0LH3Pq0Os6UZJrrnjnzAm8UlDQ=";
  };

  cargoSha256 = "sha256-TDgd8RG97ROeAQJ1uDF2m+yIa8US7zFz+5qrQtFbazE=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    homepage = "https://github.com/rust-embedded/svd2rust";
    changelog = "https://github.com/rust-embedded/svd2rust/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ newam ];
  };
}
