{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.30.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-bvRDCki7K5ycYfp0b6LKSrFgC/mbWQvzWKraOXzFoHI=";
  };

  cargoHash = "sha256-LQB1wctx3h7APbND63GkHT+IfWI9KyVfyVrdUJHcyMs=";

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
