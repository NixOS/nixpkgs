{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-chef";
  version = "0.1.52";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-eUFQT2zYABRtTqWxMi+AyU1ZHdt8+B1nMC0Sz6IK6+w=";
  };

  cargoHash = "sha256-uzuITRUvAOsuFaq+dkO8tRyozwUt4xB/3BP3mNCxr2g=";

  meta = with lib; {
    description = "A cargo-subcommand to speed up Rust Docker builds using Docker layer caching";
    homepage = "https://github.com/LukeMathWalker/cargo-chef";
    license = licenses.mit;
    maintainers = with maintainers; [ kkharji ];
  };
}
