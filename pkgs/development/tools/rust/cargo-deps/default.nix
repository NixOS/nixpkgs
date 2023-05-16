{ lib, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deps";
<<<<<<< HEAD
  version = "1.5.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-qnSHG4AhBrleYKZ4SJ4AwHdJyiidj8NTeSSphBRo7gg=";
  };

  cargoHash = "sha256-dpCbFA9AZmIFPx69tw0CqHF+lVw7uhUlwAeVX1+lIK8=";
=======
  version = "1.5.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-0zK1qwu+awZGd9hgH2WRrzJMzwpI830Lh//P0wVp6Js=";
  };

  cargoSha256 = "sha256-ZPQIt+TL1OKX3Ch4A17eAELjaSTo2uk+X6YWFAXvWJA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Cargo subcommand for building dependency graphs of Rust projects";
    homepage = "https://github.com/m-cat/cargo-deps";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ arcnmx matthiasbeyer ];
=======
    maintainers = with maintainers; [ arcnmx ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
