{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.28.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-/Pt0eKS6Rfrh18nb1lR/T+T+b73rmX4jmGIjbXJtcMA=";
  };

  cargoSha256 = "sha256-Vum7Ltq9h6BMXvIESO9jC2B775BZlCWmatazk1bavQs=";

  meta = with lib; {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    homepage = "https://github.com/rust-embedded/svd2rust";
    changelog = "https://github.com/rust-embedded/svd2rust/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ newam ];
  };
}
