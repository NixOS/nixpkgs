{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.26.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-XoiAnJDTwO93cMH8Z8mJbPfVMhq7c/Xc38gUNYmSX6Y=";
  };

  cargoSha256 = "sha256-5mu+8tmO70PZq13VuFeovgAmhPmL5G4ju5AvjsC7Idc=";

  meta = with lib; {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    homepage = "https://github.com/rust-embedded/svd2rust";
    changelog = "https://github.com/rust-embedded/svd2rust/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ newam ];
  };
}
