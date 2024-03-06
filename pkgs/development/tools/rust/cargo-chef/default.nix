{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-chef";
  version = "0.1.65";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-3G2mgQDSj+IL6gqdhr3Sov9FHwLA6B+MRazLNF+zKZk=";
  };

  cargoHash = "sha256-hWkUvUFYAOqRkoU52bKzEmvNaqASfWLlnWtIuFLMDc8=";

  meta = with lib; {
    description = "A cargo-subcommand to speed up Rust Docker builds using Docker layer caching";
    homepage = "https://github.com/LukeMathWalker/cargo-chef";
    license = licenses.mit;
    maintainers = with maintainers; [ kkharji ];
  };
}
