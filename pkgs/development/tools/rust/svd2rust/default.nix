{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.29.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-VxjoS93OwJAc9Cb0VL9R/49pAcXPYrzC7q6vYJSDYB4=";
  };

  cargoHash = "sha256-f8dht3HCgzeTfyhFhJS2F+TL5Y0qi+A5PGZkNXF1AUw=";

  meta = with lib; {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    homepage = "https://github.com/rust-embedded/svd2rust";
    changelog = "https://github.com/rust-embedded/svd2rust/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ newam ];
  };
}
