{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deps";
  version = "1.5.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-qnSHG4AhBrleYKZ4SJ4AwHdJyiidj8NTeSSphBRo7gg=";
  };

  cargoHash = "sha256-dpCbFA9AZmIFPx69tw0CqHF+lVw7uhUlwAeVX1+lIK8=";

  meta = with lib; {
    description = "Cargo subcommand for building dependency graphs of Rust projects";
    homepage = "https://github.com/m-cat/cargo-deps";
    license = licenses.mit;
    maintainers = with maintainers; [ arcnmx matthiasbeyer ];
  };
}
