{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.31.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-5+nQ7c71fXd0P51DYLBoZ3KWLkQu/dJ6s3Q90GbLQoM=";
  };

  cargoHash = "sha256-SrtOuzz5re0ptw1XyPSLLGh9jVs2dJVP/0giuQLsc08=";

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
