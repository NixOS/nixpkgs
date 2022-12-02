{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.27.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-6HcJ9NPUPcVLZT8zpYxIPJ4UkqwaqPNWva8/wnaUrt8=";
  };

  cargoSha256 = "sha256-fsLRpRvdiZyOsxnfAc5xt63rLW5lwwQt+lxmZT7XIAc=";

  meta = with lib; {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    homepage = "https://github.com/rust-embedded/svd2rust";
    changelog = "https://github.com/rust-embedded/svd2rust/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ newam ];
  };
}
