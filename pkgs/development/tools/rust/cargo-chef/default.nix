{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-chef";
  version = "0.1.66";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-I4lD3+WFaW0kPmw5lPybDCRkG/at6VQH6l7pmngwoLU=";
  };

  cargoHash = "sha256-tSr4m10zS+/JynGmNY0+aoiYDATYwuyfr1VGKmIkHg4=";

  meta = with lib; {
    description = "A cargo-subcommand to speed up Rust Docker builds using Docker layer caching";
    homepage = "https://github.com/LukeMathWalker/cargo-chef";
    license = licenses.mit;
    maintainers = with maintainers; [ kkharji ];
  };
}
