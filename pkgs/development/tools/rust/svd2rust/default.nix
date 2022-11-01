{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svd2rust";
  version = "0.27.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-Tnow5NjeDyz4oMY+UMs2TDquLTioElhSNzbC6eEYpTs=";
  };

  cargoSha256 = "sha256-sN3uJTU9h9Ls2fygz6My3hao77lQFdNkA0gkUevV7Jc=";

  meta = with lib; {
    description = "Generate Rust register maps (`struct`s) from SVD files";
    homepage = "https://github.com/rust-embedded/svd2rust";
    changelog = "https://github.com/rust-embedded/svd2rust/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ newam ];
  };
}
