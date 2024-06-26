{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.33.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-V7d/lVNL7J/ErBlJUf8btrukGC+KSvk3r9AAethFNyk=";
  };

  cargoHash = "sha256-Wu/F4PU02hrmiL7OaKIP59CfDVWrU5cw60TYngqJYNg=";

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  meta = with lib; {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    mainProgram = "svd2rust";
    homepage = "https://github.com/rust-embedded/svd2rust";
    changelog = "https://github.com/rust-embedded/svd2rust/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [ newam ];
  };
}
