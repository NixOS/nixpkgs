{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.30.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-nZ9c4Rog7dvlsnu4y33Yp+PJzwvBKvwyxF4V5UeJCVE=";
  };

  cargoHash = "sha256-wVv46yYlKsyxk+2eXwsd0jMC64Xk5+Krp18B2pKo0mo=";

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
