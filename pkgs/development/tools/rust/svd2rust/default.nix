{ lib, rustPlatform, fetchCrate, stdenv, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.24.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-BIATH7GsTPtvEFpCb8Kfb0k6s8K7xfhRHni+IgzAQ8k=";
  };

  cargoSha256 = "sha256-kg+QW84bq+aD3/t0DmtL1W8ESC5Ug4X+I0pFJRalu7Q=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    homepage = "https://github.com/rust-embedded/svd2rust";
    changelog = "https://github.com/rust-embedded/svd2rust/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ newam ];
  };
}
