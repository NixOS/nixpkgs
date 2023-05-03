{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-chef";
  version = "0.1.59";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-96KfjxpFw1uNejN917KMX98zxzJmozMiS99Aex2w4tM=";
  };

  cargoHash = "sha256-t4MuazMC8VJLj2SwY/crkd2W/ioRkdjvL5ZWiCp+7tE=";

  meta = with lib; {
    description = "A cargo-subcommand to speed up Rust Docker builds using Docker layer caching";
    homepage = "https://github.com/LukeMathWalker/cargo-chef";
    license = licenses.mit;
    maintainers = with maintainers; [ kkharji ];
  };
}
