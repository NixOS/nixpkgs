{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
<<<<<<< HEAD
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
=======
  version = "0.28.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-/Pt0eKS6Rfrh18nb1lR/T+T+b73rmX4jmGIjbXJtcMA=";
  };

  cargoSha256 = "sha256-Vum7Ltq9h6BMXvIESO9jC2B775BZlCWmatazk1bavQs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    homepage = "https://github.com/rust-embedded/svd2rust";
    changelog = "https://github.com/rust-embedded/svd2rust/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ newam ];
  };
}
