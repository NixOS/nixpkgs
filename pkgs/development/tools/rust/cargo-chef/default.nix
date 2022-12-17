{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-chef";
  version = "0.1.50";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-d467uk4UCtAKcpFYODxIhRrYoIOHzxhoaJVMA9ErRAw=";
  };

  cargoSha256 = "sha256-5xj4/uxuMhlqY1ncrMU1IFWdVB4ZjHVXg0ZbRXDvIak=";

  meta = with lib; {
    description = "A cargo-subcommand to speed up Rust Docker builds using Docker layer caching";
    homepage = "https://github.com/LukeMathWalker/cargo-chef";
    license = licenses.mit;
    maintainers = with maintainers; [ kkharji ];
  };
}
