{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.33.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Ed7dwVXjLOAtW9ZOh1g+yamnSzyoKo1lS4N2nyyqaJ8=";
  };

  cargoHash = "sha256-BppPMYsv0v7K6z9URYEWrz0SHPx+oe2jeP3EzydFcuI=";

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  meta = with lib; {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    mainProgram = "svd2rust";
    homepage = "https://github.com/rust-embedded/svd2rust";
    changelog = "https://github.com/rust-embedded/svd2rust/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ newam ];
  };
}
