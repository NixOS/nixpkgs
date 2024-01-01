{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.31.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-uP3qxp6Y/VfuQ/uS+Plus/ITvHjlraWxJa2HFIzZEFI=";
  };

  cargoHash = "sha256-iPZrWOidQoA2SCKIm+utd9fXLlbcjGIYw1CaaJ7PV+I=";

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
