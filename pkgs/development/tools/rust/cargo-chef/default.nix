{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-chef";
  version = "0.1.63";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-AkkLK1WQFOevKAv+jGd4ofDMmM8l0oJOV9liYJETtIk=";
  };

  cargoHash = "sha256-iqAi+V3AZ+OhR/c9FJSUa8Fon16rpD0B2o5zsGown9U=";

  meta = with lib; {
    description = "A cargo-subcommand to speed up Rust Docker builds using Docker layer caching";
    homepage = "https://github.com/LukeMathWalker/cargo-chef";
    license = licenses.mit;
    maintainers = with maintainers; [ kkharji ];
  };
}
