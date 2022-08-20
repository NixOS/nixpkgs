{ lib, rustPlatform, fetchCrate, stdenv, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.25.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-k+/FxVCUPQuVXZFk+FE3cAtAf/YCgk/fGVtRKIeefJ8=";
  };

  cargoSha256 = "sha256-RxpBhA5lf+mcr4VMtsrdzlxN8oDttNcWuwxQAAYN8U8=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    homepage = "https://github.com/rust-embedded/svd2rust";
    changelog = "https://github.com/rust-embedded/svd2rust/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ newam ];
  };
}
