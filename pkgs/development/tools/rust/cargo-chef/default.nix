{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-chef";
  version = "0.1.64";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-TjmtL/0rr/rJPdWSjL6zD3H49Qhg6YE7irS1xjyc3OA=";
  };

  cargoHash = "sha256-1SZZva0b7/0FGqZO4RL5gMnpG+xZwKqLU1Fgv54ewNM=";

  meta = with lib; {
    description = "A cargo-subcommand to speed up Rust Docker builds using Docker layer caching";
    homepage = "https://github.com/LukeMathWalker/cargo-chef";
    license = licenses.mit;
    maintainers = with maintainers; [ kkharji ];
  };
}
