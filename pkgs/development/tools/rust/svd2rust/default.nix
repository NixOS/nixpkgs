{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.31.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-byZYKf0FujtH5VShUCVeotDUV/66QKUmmRTRld8b1bk=";
  };

  cargoHash = "sha256-Ksj67uA9RVv09PfwnjPVA+TFG4My05Mi3eDxquox/K0=";

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  meta = with lib; {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    homepage = "https://github.com/rust-embedded/svd2rust";
    changelog = "https://github.com/rust-embedded/svd2rust/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ newam ];
  };
}
