{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.31.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-iJWF2BDLFH/sNi5xc8BIVmt4A+CSROxxp1TW5fcIp1Q=";
  };

  cargoHash = "sha256-WcF7XeDfCdGiQQBH1LN3q3iIUJlfLTjJ7xlMG52AO/w=";

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
