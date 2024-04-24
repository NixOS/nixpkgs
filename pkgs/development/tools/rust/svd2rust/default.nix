{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.33.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-omAL/nRdB5wngOQTaZdnq9XaPnDj6kxda+27TQS7dUQ=";
  };

  cargoHash = "sha256-YmnKZhGDQ+eqHy/KQxp3ZdCxKrZEKcS2R+5/t6HhOCg=";

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
