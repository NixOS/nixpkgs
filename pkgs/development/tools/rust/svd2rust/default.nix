{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.30.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-/fB6Ay9t5WkBtHVYne/dbj+PXurMpzKAb7/OFD4j7U4=";
  };

  cargoHash = "sha256-PD2UsLVfc6D726BpE6a1MKjspL3/g2D9sweCmVXtH1E=";

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
