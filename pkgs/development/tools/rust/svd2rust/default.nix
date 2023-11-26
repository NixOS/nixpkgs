{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.31.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Ifi7KWq2jCSUvriKIVQ67a7Ow4aHriM2AjH6kW7+PGs=";
  };

  cargoHash = "sha256-+aK+Uv0gDmCxvR4VqVM+nvoSJkldD1hE10QC3B25r0Y=";

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
