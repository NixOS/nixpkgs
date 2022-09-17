{ lib, rustPlatform, fetchCrate, stdenv, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.25.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-mPkcefB9oTLYhtokhUVwoWfsvLtZWWb+LwElmJeZsiA=";
  };

  cargoSha256 = "sha256-sjjmsrgKfrvXynVsZuYkmGKmh0cTAlSNT4h2fVHATrU=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    homepage = "https://github.com/rust-embedded/svd2rust";
    changelog = "https://github.com/rust-embedded/svd2rust/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ newam ];
  };
}
