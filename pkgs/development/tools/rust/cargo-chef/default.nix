{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-chef";
  version = "0.1.61";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-O3q0gfVnFMgcwWGfRgdGOwU6fauRN2qPkyTe72p3zS4=";
  };

  cargoHash = "sha256-A22x2s5tHf9M6UbFHwmVNgO2qe65io/GysF1+ZE8NXM=";

  meta = with lib; {
    description = "A cargo-subcommand to speed up Rust Docker builds using Docker layer caching";
    homepage = "https://github.com/LukeMathWalker/cargo-chef";
    license = licenses.mit;
    maintainers = with maintainers; [ kkharji ];
  };
}
