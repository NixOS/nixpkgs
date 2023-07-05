{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deps";
  version = "1.5.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-0zK1qwu+awZGd9hgH2WRrzJMzwpI830Lh//P0wVp6Js=";
  };

  cargoSha256 = "sha256-ZPQIt+TL1OKX3Ch4A17eAELjaSTo2uk+X6YWFAXvWJA=";

  meta = with lib; {
    description = "Cargo subcommand for building dependency graphs of Rust projects";
    homepage = "https://github.com/m-cat/cargo-deps";
    license = licenses.mit;
    maintainers = with maintainers; [ arcnmx ];
  };
}
