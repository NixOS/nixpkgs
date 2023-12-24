{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.31.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-5ilapONo4/zcNza3EFREAO/e/PMX7lr3EwFWduY6On0=";
  };

  cargoHash = "sha256-3Uk2qxkzR/0kgjzIXcJb2r27nNuo4cvprbdLb+e0fLM=";

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
