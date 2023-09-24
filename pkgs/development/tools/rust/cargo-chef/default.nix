{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-chef";
  version = "0.1.62";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ZewsR6MgBf8wdqBIrYAuprmqthhbEA/WDShp9H3jfDs=";
  };

  cargoHash = "sha256-UHUNoI9QqHzgYIuKlj0giWfFgS+F3eUC/wuAXgwH2xQ=";

  meta = with lib; {
    description = "A cargo-subcommand to speed up Rust Docker builds using Docker layer caching";
    homepage = "https://github.com/LukeMathWalker/cargo-chef";
    license = licenses.mit;
    maintainers = with maintainers; [ kkharji ];
  };
}
