{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.27.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-fU/qaYuuZM9tfveWYD4tCJugLELTR4DlQsr4WP/0f4o=";
  };

  cargoSha256 = "sha256-csiwkBOiIzIVADjKFE8YvBRO0iqtEr4I4s0XDMyb7Sc=";

  meta = with lib; {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    homepage = "https://github.com/rust-embedded/svd2rust";
    changelog = "https://github.com/rust-embedded/svd2rust/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ newam ];
  };
}
